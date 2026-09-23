import 'dart:async';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soperia_user/Screens/HomeScreen/home_screen_bottom.dart';
import 'package:soperia_user/Screens/Profile/Complaint/complaint_screen.dart';
import 'package:soperia_user/Screens/Profile/Contact%20Us/contact_us_message_screen.dart';
import 'package:soperia_user/Screens/Profile/Coupons/my_coupons_screen.dart';
import 'package:soperia_user/Screens/Profile/My%20Claims/claim_message_screen.dart';
import 'package:soperia_user/Screens/Profile/My%20Claims/review_my_claim_status_screen.dart';
import 'package:soperia_user/app_utils/Common%20Widgets/in_app_notification_banner.dart';
import 'package:soperia_user/app_utils/api_set_up/api_call.dart';
import 'package:soperia_user/app_utils/api_set_up/api_keys.dart';
import 'package:soperia_user/app_utils/api_set_up/api_urls.dart';
import 'package:soperia_user/app_utils/api_set_up/header_file.dart';
import 'package:soperia_user/app_utils/api_set_up/service_locator.dart';
import 'package:soperia_user/model_class/get_claims_list_model.dart';
import 'package:soperia_user/model_class/notification_model.dart';

class NotificationController extends GetxController with WidgetsBindingObserver {
  static NotificationController get instance {
    if (!Get.isRegistered<NotificationController>()) {
      return Get.put(NotificationController(), permanent: true);
    }
    return Get.find<NotificationController>();
  }

  final repo = getIt.get<ApiCall>();

  // Observables
  RxInt unreadCount = 0.obs;
  RxList<NotificationItem> notifications = <NotificationItem>[].obs;
  RxBool isLoading = false.obs;
  RxBool isMoreLoading = false.obs;
  RxInt currentPage = 1.obs;
  RxInt lastPage = 1.obs;
  RxBool hasMore = false.obs;

  // Firebase RTDB state
  DatabaseReference? _rtdbRef;
  StreamSubscription? _childAddedSub;
  StreamSubscription? _childChangedSub;
  int? _currentClientId;
  int _listenerStartTimeSeconds = 0;
  final Set<int> _seenNotificationIds = {};

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    initNotificationSystem();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    detachRtdbListener();
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      debugPrint('[NotificationController] App resumed -> refresh & attach RTDB');
      refreshOnResume();
    } else if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      debugPrint('[NotificationController] App paused/backgrounded -> detach RTDB');
      detachRtdbListener();
    }
  }

  /// Initialize system on app open / login
  Future<void> initNotificationSystem({int? clientId}) async {
    int? resolvedId = clientId ?? getProfileModelGlobal.data?.id;

    if (resolvedId == null || resolvedId == 0) {
      final prefs = await SharedPreferences.getInstance();
      resolvedId = prefs.getInt('client_id');
    }

    if (resolvedId != null && resolvedId > 0) {
      _currentClientId = resolvedId;
      attachRtdbListener(resolvedId);
    }

    await fetchUnreadCount();
  }

  /// Update client ID and restart listener if changed
  void updateClientId(int? clientId) {
    if (clientId != null && clientId > 0 && clientId != _currentClientId) {
      _currentClientId = clientId;
      detachRtdbListener();
      attachRtdbListener(clientId);
    }
  }

  /// Called on app open / resume
  Future<void> refreshOnResume() async {
    int? clientId = _currentClientId ?? getProfileModelGlobal.data?.id;
    if (clientId != null && clientId > 0) {
      attachRtdbListener(clientId);
    }
    await fetchUnreadCount();
    if (notifications.isNotEmpty) {
      await fetchNotifications(isRefresh: true);
    }
  }

  // ---------------------------------------------------------------------------
  // REST API Methods
  // ---------------------------------------------------------------------------

  /// GET /api/notifications/unread-count
  Future<void> fetchUnreadCount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(tokenKey);
      if (token == null || token.isEmpty || token == 'null') {
        unreadCount.value = 0;
        return;
      }

      Map<String, String> header = await getHeader();
      Map<String, dynamic> response = await ApiCall(dioClient: repo.dioClient).getRequest(
        context: Get.context ?? (navigator?.overlay?.context)!,
        endpoint: notificationsUnreadCountURL,
        options: Options(headers: header),
      );

      debugPrint('[NotificationController] Unread count response: $response');
      if (response.containsKey('unread_count')) {
        int count = response['unread_count'] is int
            ? response['unread_count']
            : int.tryParse(response['unread_count']?.toString() ?? '0') ?? 0;
        unreadCount.value = count;
      } else if (response['data'] is Map && (response['data'] as Map).containsKey('unread_count')) {
        final dataMap = response['data'] as Map;
        int count = dataMap['unread_count'] is int
            ? dataMap['unread_count']
            : int.tryParse(dataMap['unread_count']?.toString() ?? '0') ?? 0;
        unreadCount.value = count;
      }
    } catch (e) {
      debugPrint('[NotificationController] fetchUnreadCount error: $e');
    }
  }

  /// GET /api/notifications (paginated)
  Future<void> fetchNotifications({bool isRefresh = false}) async {
    try {
      if (isRefresh) {
        currentPage.value = 1;
        hasMore.value = false;
      }

      if (currentPage.value == 1) {
        isLoading.value = true;
      } else {
        isMoreLoading.value = true;
      }

      Map<String, String> header = await getHeader();
      Map<String, dynamic> response = await ApiCall(dioClient: repo.dioClient).getRequest(
        context: Get.context ?? (navigator?.overlay?.context)!,
        endpoint: notificationsListURL(currentPage.value, perPage: 20),
        options: Options(headers: header),
      );

      debugPrint('[NotificationController] Notifications response: $response');

      final paginationModel = NotificationPaginationModel.fromJson(response);
      final newItems = paginationModel.data ?? [];

      if (currentPage.value == 1) {
        notifications.assignAll(newItems);
        // Track seen IDs
        for (var item in newItems) {
          if (item.id != null) _seenNotificationIds.add(item.id!);
        }
      } else {
        notifications.addAll(newItems);
        for (var item in newItems) {
          if (item.id != null) _seenNotificationIds.add(item.id!);
        }
      }

      currentPage.value = paginationModel.currentPage ?? 1;
      lastPage.value = paginationModel.lastPage ?? 1;
      hasMore.value = currentPage.value < lastPage.value;
      debugPrint('[NotificationController] Notifications loaded: ${notifications.length} (page: ${currentPage.value}/${lastPage.value}, total: ${paginationModel.total})');
    } catch (e) {
      debugPrint('[NotificationController] fetchNotifications error: $e');
    } finally {
      isLoading.value = false;
      isMoreLoading.value = false;
    }
  }

  /// Load next page for pagination
  Future<void> loadMore() async {
    if (isLoading.value || isMoreLoading.value || !hasMore.value) return;
    currentPage.value++;
    await fetchNotifications();
  }

  /// PATCH /api/notifications/{id}/read
  Future<void> markAsRead(NotificationItem item) async {
    if (item.id == null || item.isRead) return;

    // Optimistic local update
    item.isRead = true;
    notifications.refresh();
    if (unreadCount.value > 0) {
      unreadCount.value--;
    }

    try {
      Map<String, String> header = await getHeader();
      final response = await ApiCall(dioClient: repo.dioClient).patchRequest(
        endpoint: notificationsReadURL(item.id!),
        options: Options(headers: header),
      );
      debugPrint('[NotificationController] markAsRead response: $response');
    } catch (e) {
      debugPrint('[NotificationController] markAsRead API error: $e');
    }
  }

  /// PATCH /api/notifications/read-all
  Future<void> markAllAsRead() async {
    // Optimistic local update
    for (var item in notifications) {
      item.isRead = true;
    }
    notifications.refresh();
    unreadCount.value = 0;

    try {
      Map<String, String> header = await getHeader();
      final response = await ApiCall(dioClient: repo.dioClient).patchRequest(
        endpoint: notificationsReadAllURL,
        options: Options(headers: header),
      );
      debugPrint('[NotificationController] markAllAsRead response: $response');
    } catch (e) {
      debugPrint('[NotificationController] markAllAsRead API error: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // Firebase RTDB Realtime Listener
  // ---------------------------------------------------------------------------

  void attachRtdbListener(int clientId) {
    if (Firebase.apps.isEmpty) {
      debugPrint('[NotificationController] Firebase not initialized');
      return;
    }

    try {
      detachRtdbListener();

      _currentClientId = clientId;
      _listenerStartTimeSeconds = DateTime.now().millisecondsSinceEpoch ~/ 1000 - 3; // allow 3s leeway
      _rtdbRef = FirebaseDatabase.instance.ref('notifications/$clientId');

      debugPrint('[NotificationController] Listening to RTDB: notifications/$clientId');

      // 1. child_added: Live new notification in foreground
      _childAddedSub = _rtdbRef!.onChildAdded.listen((event) {
        try {
          if (event.snapshot.value == null || event.snapshot.value is! Map) return;

          final rawMap = Map<String, dynamic>.from(event.snapshot.value as Map);
          final notification = NotificationItem.fromRtdb(rawMap, key: event.snapshot.key);

          // Avoid processing same ID twice
          if (notification.id != null && _seenNotificationIds.contains(notification.id)) {
            return;
          }
          if (notification.id != null) {
            _seenNotificationIds.add(notification.id!);
          }

          // Prepend to local notification list if list is populated
          if (!notifications.any((e) => e.id == notification.id)) {
            notifications.insert(0, notification);
          }

          // Check if this is a fresh live notification (after listener started)
          final createdSeconds = _getTimestampSeconds(notification.rawCreatedAt);
          final isFresh = createdSeconds == null || createdSeconds >= _listenerStartTimeSeconds;

          if (!notification.isRead && isFresh) {
            unreadCount.value++;

            // Trigger floating in-app banner alert
            showInAppNotificationBanner(
              notification: notification,
              onTap: () {
                handleNotificationTap(notification, Get.context ?? (navigator?.overlay?.context)!);
              },
            );
          }
        } catch (e) {
          debugPrint('[NotificationController] RTDB child_added parse error: $e');
        }
      });

      // 2. child_changed: Read state synchronization across devices / API
      _childChangedSub = _rtdbRef!.onChildChanged.listen((event) {
        try {
          if (event.snapshot.value == null || event.snapshot.value is! Map) return;

          final rawMap = Map<String, dynamic>.from(event.snapshot.value as Map);
          final notification = NotificationItem.fromRtdb(rawMap, key: event.snapshot.key);

          if (notification.id != null) {
            final index = notifications.indexWhere((e) => e.id == notification.id);
            if (index != -1) {
              final oldItem = notifications[index];
              final wasUnread = !oldItem.isRead;

              notifications[index] = notification;
              notifications.refresh();

              // If marked read elsewhere, adjust badge count
              if (wasUnread && notification.isRead && unreadCount.value > 0) {
                unreadCount.value--;
              }
            }
          }
        } catch (e) {
          debugPrint('[NotificationController] RTDB child_changed parse error: $e');
        }
      });
    } catch (e) {
      debugPrint('[NotificationController] attachRtdbListener error: $e');
    }
  }

  void detachRtdbListener() {
    try {
      _childAddedSub?.cancel();
      _childAddedSub = null;
      _childChangedSub?.cancel();
      _childChangedSub = null;
      _rtdbRef = null;
      debugPrint('[NotificationController] RTDB listener detached');
    } catch (e) {
      debugPrint('[NotificationController] detachRtdbListener error: $e');
    }
  }

  int? _getTimestampSeconds(dynamic raw) {
    if (raw == null) return null;
    if (raw is int) {
      return raw > 100000000000 ? raw ~/ 1000 : raw;
    }
    if (raw is String) {
      final asInt = int.tryParse(raw);
      if (asInt != null) {
        return asInt > 100000000000 ? asInt ~/ 1000 : asInt;
      }
      final parsedDate = DateTime.tryParse(raw);
      if (parsedDate != null) {
        return parsedDate.millisecondsSinceEpoch ~/ 1000;
      }
    }
    return null;
  }

  // ---------------------------------------------------------------------------
  // Deep Linking / Navigation
  // ---------------------------------------------------------------------------

  void handleNotificationTap(NotificationItem notification, BuildContext context) {
    // Mark as read first
    markAsRead(notification);

    final type = notification.type ?? '';
    debugPrint('[NotificationController] Navigating for type: $type with data: ${notification.data}');

    switch (type) {
      case 'chat_message':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ContactUsMessageScreen()),
        );
        break;

      case 'claim_message':
        final claimId = notification.claimId ?? 0;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ClaimMessageScreen(
              data: ClaimsListData(
                id: claimId,
                companyName: 'Claim #$claimId',
              ),
            ),
          ),
        );
        break;

      case 'claim_status':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ReviewMyClaimStatusScreen()),
        );
        break;

      case 'complaint_status':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ComplaintScreen()),
        );
        break;

      case 'coupon':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MyCouponsScreen(
              insuranceType: '',
              isApplyCoupon: false,
            ),
          ),
        );
        break;

      case 'expiry_reminder':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePageBottomNav(initialIndex: 1),
          ),
        );
        break;

      default:
        debugPrint('[NotificationController] Unknown notification type: $type');
        break;
    }
  }
}
