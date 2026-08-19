import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soperia_user/Services/chat_realtime_service.dart';
import 'package:soperia_user/app_utils/api_set_up/api_call.dart';
import 'package:soperia_user/app_utils/api_set_up/api_keys.dart';
import 'package:soperia_user/app_utils/api_set_up/api_urls.dart';
import 'package:soperia_user/app_utils/api_set_up/header_file.dart';
import 'package:soperia_user/app_utils/api_set_up/service_locator.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import 'package:soperia_user/app_utils/file_upload_gallary.dart';
import 'package:soperia_user/model_class/chat_model.dart';
import 'package:dio/dio.dart' as m;

class ContactUsController extends GetxController {
  final repo = getIt.get<ApiCall>();

  RxBool isLoadingChatsList = false.obs;
  RxBool isLoadingSendClaimsMessage = false.obs;
  RxBool isLoadingMore = false.obs;

  RxInt currentPage = 1.obs;
  RxInt lastPage = 1.obs;
  RxBool hasMorePages = false.obs;

  Rx<TextEditingController> messageController = TextEditingController().obs;

  RxnInt activeChatId = RxnInt();
  RxList<ChatMessageItem> chatMessagesList = <ChatMessageItem>[].obs;
  final Set<int> seenMessageIds = {};
  final ChatRealtimeService _realtimeService = ChatRealtimeService();
  Timer? _pollTimer;

  File selectedFileDocuments = File("");
  Rx<ScrollController> listScrollController = ScrollController().obs;
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void onInit() {
    super.onInit();
    setupScrollListener();
  }

  @override
  void onClose() {
    stopPolling();
    _realtimeService.dispose();
    super.onClose();
  }

  void setupScrollListener() {
    listScrollController.value.addListener(() {
      if (listScrollController.value.position.pixels <= 80 &&
          !isLoadingMore.value &&
          hasMorePages.value &&
          !isLoadingChatsList.value &&
          activeChatId.value != null) {
        loadMoreOlderMessages();
      }
    });
  }

  void startPolling() {
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      if (activeChatId.value != null) {
        pollNewMessages();
      }
    });
  }

  void stopPolling() {
    _pollTimer?.cancel();
    _pollTimer = null;
  }

  Future<void> apiMethod(BuildContext context) async {
    isLoadingChatsList.value = true;
    await startAndLoadChat(context);
    isLoadingChatsList.value = false;
    await Future.delayed(const Duration(milliseconds: 300));
    scrollToBottom();
  }

  Future<void> startAndLoadChat(BuildContext context) async {
    try {
      currentPage.value = 1;
      hasMorePages.value = false;
      await startChatApi(context);
      if (activeChatId.value != null) {
        await getChatMessagesApi(context, page: 1);
        await markChatAsReadApi(context);
        startPolling();
      }
    } catch (e) {
      debugPrint('startAndLoadChat error: $e');
    }
  }

  /// POST /api/chat/start
  Future<void> startChatApi(BuildContext context, {int receiverId = 1, String receiverType = 'admin'}) async {
    try {
      Map<String, String> header = await getHeader();
      Map<String, dynamic> response = await ApiCall(dioClient: repo.dioClient).postRequest(
        context: context,
        endpoint: chatStartURL,
        body: {'receiver_id': receiverId, 'receiver_type': receiverType},
        options: Options(headers: header),
      );

      debugPrint('startChatApi response: $response');

      final chatData = response['chat'] ?? response['data'] ?? response;
      if (chatData != null && chatData['id'] != null) {
        activeChatId.value = chatData['id'] is int
            ? chatData['id']
            : int.tryParse(chatData['id'].toString());
        debugPrint('activeChatId set to: ${activeChatId.value}');
      }
    } catch (e) {
      debugPrint('startChatApi error: $e');
    }
  }

  /// POST /api/chat/{chatId}/mark-read
  Future<void> markChatAsReadApi(BuildContext context) async {
    if (activeChatId.value == null) return;
    try {
      Map<String, String> header = await getHeader();
      await ApiCall(dioClient: repo.dioClient).postRequest(
        context: context,
        endpoint: markChatReadURL(activeChatId.value!),
        options: Options(headers: header),
      );
    } catch (e) {
      debugPrint('markChatAsReadApi error: $e');
    }
  }

  void sortMessages() {
    chatMessagesList.sort((a, b) {
      final aDate = a.parsedCreatedAt;
      final bDate = b.parsedCreatedAt;
      final cmp = aDate.compareTo(bDate);
      if (cmp != 0) return cmp;
      return a.id.compareTo(b.id);
    });
  }

  /// GET /api/chat/{chatId}/messages?page=1
  Future<void> getChatMessagesApi(BuildContext context, {int page = 1}) async {
    if (activeChatId.value == null) return;
    try {
      Map<String, String> header = await getHeader();
      Map<String, dynamic> response = await ApiCall(dioClient: repo.dioClient).getRequest(
        context: context,
        endpoint: getChatMessagesURL(activeChatId.value!, page: page),
        options: Options(headers: header),
      );

      debugPrint('getChatMessagesApi response: $response');

      if (response['data'] != null) {
        final List listData = response['data'] is List ? response['data'] : (response['data']?['data'] ?? []);
        final items = listData.map((e) => ChatMessageItem.fromJson(e)).toList();

        // Extract last_page
        int extractedLastPage = 1;
        if (response['last_page'] != null) {
          extractedLastPage = response['last_page'] is int ? response['last_page'] : int.tryParse(response['last_page'].toString()) ?? 1;
        } else if (response['data'] is Map && response['data']['last_page'] != null) {
          extractedLastPage = response['data']['last_page'] is int ? response['data']['last_page'] : int.tryParse(response['data']['last_page'].toString()) ?? 1;
        }
        lastPage.value = extractedLastPage;
        currentPage.value = page;
        hasMorePages.value = currentPage.value < lastPage.value;

        if (page == 1) {
          seenMessageIds.clear();
          chatMessagesList.clear();
        }

        for (var item in items) {
          if (!seenMessageIds.contains(item.id)) {
            seenMessageIds.add(item.id);
            chatMessagesList.add(item);
          }
        }

        // If multiple pages exist on initial load, fetch all remaining pages so user sees complete chat up to newest
        if (page == 1 && lastPage.value > 1) {
          for (int p = 2; p <= lastPage.value; p++) {
            try {
              Map<String, dynamic> nextResp = await ApiCall(dioClient: repo.dioClient).getRequest(
                context: context,
                endpoint: getChatMessagesURL(activeChatId.value!, page: p),
                options: Options(headers: header),
              );
              if (nextResp['data'] != null) {
                final List nextListData = nextResp['data'] is List ? nextResp['data'] : (nextResp['data']?['data'] ?? []);
                final nextItems = nextListData.map((e) => ChatMessageItem.fromJson(e)).toList();
                for (var item in nextItems) {
                  if (!seenMessageIds.contains(item.id)) {
                    seenMessageIds.add(item.id);
                    chatMessagesList.add(item);
                  }
                }
              }
            } catch (e) {
              debugPrint('Error fetching chat page $p: $e');
            }
          }
          currentPage.value = lastPage.value;
          hasMorePages.value = false;
        }

        sortMessages();

        // Initialize Firebase listener
        _realtimeService.init(activeChatId.value!);
        _realtimeService.seedExistingIds(seenMessageIds.toList());
        _realtimeService.listenForNewMessages((newMsg) {
          if (!seenMessageIds.contains(newMsg.id)) {
            seenMessageIds.add(newMsg.id);
            chatMessagesList.add(newMsg);
            sortMessages();
            scrollToBottom();
          }
        });
      }
    } catch (e) {
      debugPrint('getChatMessagesApi error: $e');
    }
    scrollToBottom();
  }

  /// Pagination: Load older messages when user scrolls to top
  Future<void> loadMoreOlderMessages() async {
    if (isLoadingMore.value || !hasMorePages.value || activeChatId.value == null) return;
    
    isLoadingMore.value = true;
    final nextPage = currentPage.value + 1;

    try {
      Map<String, String> header = await getHeader();
      final BuildContext? currentContext = Get.context;
      if (currentContext == null) return;

      Map<String, dynamic> response = await ApiCall(dioClient: repo.dioClient).getRequest(
        context: currentContext,
        endpoint: getChatMessagesURL(activeChatId.value!, page: nextPage),
        options: Options(headers: header),
      );

      debugPrint('loadMoreOlderMessages page $nextPage response: $response');

      if (response['data'] != null) {
        final List listData = response['data'] is List ? response['data'] : (response['data']?['data'] ?? []);
        final newItems = listData.map((e) => ChatMessageItem.fromJson(e)).toList();

        int extractedLastPage = lastPage.value;
        if (response['last_page'] != null) {
          extractedLastPage = response['last_page'] is int ? response['last_page'] : int.tryParse(response['last_page'].toString()) ?? lastPage.value;
        } else if (response['data'] is Map && response['data']['last_page'] != null) {
          extractedLastPage = response['data']['last_page'] is int ? response['data']['last_page'] : int.tryParse(response['data']['last_page'].toString()) ?? lastPage.value;
        }
        lastPage.value = extractedLastPage;
        currentPage.value = nextPage;
        hasMorePages.value = currentPage.value < lastPage.value;

        for (var item in newItems) {
          if (!seenMessageIds.contains(item.id)) {
            seenMessageIds.add(item.id);
            chatMessagesList.add(item);
          }
        }

        sortMessages();
      }
    } catch (e) {
      debugPrint('loadMoreOlderMessages error: $e');
    } finally {
      isLoadingMore.value = false;
    }
  }

  /// Silent REST polling for background/fallback message updates
  Future<void> pollNewMessages() async {
    if (activeChatId.value == null) return;
    try {
      Map<String, String> header = await getHeader();
      final BuildContext? currentContext = Get.context;
      if (currentContext == null) return;

      Map<String, dynamic> response = await ApiCall(dioClient: repo.dioClient).getRequest(
        context: currentContext,
        endpoint: getChatMessagesURL(activeChatId.value!, page: lastPage.value),
        options: Options(headers: header),
      );

      if (response['data'] != null) {
        final List listData = response['data'] is List ? response['data'] : (response['data']?['data'] ?? []);
        bool addedNew = false;
        for (var e in listData) {
          final item = ChatMessageItem.fromJson(e);
          if (!seenMessageIds.contains(item.id)) {
            seenMessageIds.add(item.id);
            chatMessagesList.add(item);
            addedNew = true;
          }
        }
        if (addedNew) {
          sortMessages();
          scrollToBottom();
        }
      }
    } catch (_) {}
  }

  /// POST /api/chat/send
  Future<void> sendContactMessageApi(BuildContext context) async {
    String textMsg = messageController.value.text.trim();
    bool hasFile = selectedFileDocuments.path.isNotEmpty;

    if (textMsg.isEmpty && !hasFile) return;

    isLoadingSendClaimsMessage.value = true;

    // Get current time in UTC to pass in created_at
    final nowUtc = DateTime.now().toUtc();
    final utcTimeString = nowUtc.toIso8601String();

    try {
      if (activeChatId.value == null) {
        await startChatApi(context);
      }

      if (activeChatId.value != null) {
        Map<String, String> header = await getHeader();
        Map<String, dynamic> response;

        if (hasFile) {
          Map<String, dynamic> bodyData = {
            'chat_id': activeChatId.value,
            'created_at': utcTimeString,
            'time': utcTimeString,
          };
          if (textMsg.isNotEmpty) {
            bodyData['message'] = textMsg;
          }
          bodyData['file'] = await m.MultipartFile.fromFile(selectedFileDocuments.path);

          response = await ApiCall(dioClient: repo.dioClient).postRequestFormData(
            context: context,
            endpoint: chatSendURL,
            body: bodyData,
            options: Options(headers: header),
          );
        } else {
          Map<String, dynamic> bodyData = {
            'chat_id': activeChatId.value,
            'message': textMsg,
            'created_at': utcTimeString,
            'time': utcTimeString,
          };

          response = await ApiCall(dioClient: repo.dioClient).postRequest(
            context: context,
            endpoint: chatSendURL,
            body: bodyData,
            options: Options(headers: header),
          );
        }

        debugPrint('sendContactMessageApi response: $response');

        if (response['status'] == true || response['data'] != null || response[statusCode] == 200 || response[statusCode] == 201) {
          messageController.value.clear();
          selectedFileDocuments = File("");

          if (response['data'] != null && response['data'] is Map) {
            final msgMap = Map<String, dynamic>.from(response['data'] as Map);
            if (msgMap['created_at'] == null || msgMap['created_at'].toString().isEmpty) {
              msgMap['created_at'] = utcTimeString;
            }
            final newMsg = ChatMessageItem.fromJson(msgMap);
            if (!seenMessageIds.contains(newMsg.id)) {
              seenMessageIds.add(newMsg.id);
              chatMessagesList.add(newMsg);
              sortMessages();
            }
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: AppText(
                text: response[messageKey]?.toString() ?? response['message']?.toString() ?? 'Failed to send message',
                txtColor: primaryWhite,
                size: 12,
              ),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: AppText(
              text: 'Unable to start chat session. Please try again.',
              txtColor: primaryWhite,
              size: 12,
            ),
          ),
        );
      }
    } on DioException catch (e) {
      debugPrint('sendContactMessageApi DioException: ${e.response?.data ?? e.message}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: AppText(
            text: e.response?.data?['message']?.toString() ?? e.response?.statusMessage ?? e.message ?? 'Network error',
            txtColor: primaryWhite,
            size: 12,
          ),
        ),
      );
    } catch (f) {
      debugPrint('sendContactMessageApi error: $f');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: AppText(
            text: "$f",
            txtColor: primaryWhite,
            size: 12,
          ),
        ),
      );
    } finally {
      isLoadingSendClaimsMessage.value = false;
    }
    scrollToBottom();
  }

  showPicker(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(children: <Widget>[
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: AppText(text: photoLibrary, size: 14, txtColor: primaryBlack),
              onTap: () async {
                Navigator.of(bc).pop();
                final file = await selectImageFromGallery(context);
                if (file != null && file.path.isNotEmpty) {
                  selectedFileDocuments = file;
                  if (context.mounted) {
                    sendContactMessageApi(context);
                  }
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: AppText(text: camera, size: 14, txtColor: primaryBlack),
              onTap: () async {
                Navigator.of(bc).pop();
                final file = await selectImageFromCamera(context);
                if (file != null && file.path.isNotEmpty) {
                  selectedFileDocuments = file;
                  if (context.mounted) {
                    sendContactMessageApi(context);
                  }
                }
              },
            )
          ]),
        );
      },
    );
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (listScrollController.value.hasClients) {
        final position = listScrollController.value.position.maxScrollExtent;
        listScrollController.value.animateTo(
          position,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> refreshList(BuildContext context) async {
    await startAndLoadChat(context);
  }

  /// Converts UTC createdAt timestamp to device region local time
  static DateTime parseUtcToLocal(String createdAt) {
    if (createdAt.isEmpty) return DateTime.fromMillisecondsSinceEpoch(0);
    try {
      String clean = createdAt.trim();
      if (!clean.endsWith('Z') && !clean.contains('+')) {
        if (clean.contains('T')) {
          clean = '${clean}Z';
        } else if (clean.contains(' ')) {
          clean = '${clean.replaceFirst(' ', 'T')}Z';
        }
      }
      return DateTime.parse(clean).toLocal();
    } catch (_) {
      try {
        return DateTime.parse(createdAt.replaceFirst(' ', 'T')).toLocal();
      } catch (_) {
        return DateTime.fromMillisecondsSinceEpoch(0);
      }
    }
  }

  // WhatsApp-style Date & Time Formatters (converts UTC to local device region/time)
  String formatDateLabel(String createdAt) {
    if (createdAt.isEmpty) return '';
    try {
      final msgDate = parseUtcToLocal(createdAt);
      final now = DateTime.now();
      final yesterday = now.subtract(const Duration(days: 1));

      bool isSameDay(DateTime a, DateTime b) =>
          a.year == b.year && a.month == b.month && a.day == b.day;

      if (isSameDay(msgDate, now)) return 'Today';
      if (isSameDay(msgDate, yesterday)) return 'Yesterday';

      return '${msgDate.day.toString().padLeft(2, '0')}/'
          '${msgDate.month.toString().padLeft(2, '0')}/'
          '${msgDate.year}';
    } catch (e) {
      return createdAt;
    }
  }

  String formatTimeLabel(String createdAt) {
    if (createdAt.isEmpty) return '';
    try {
      final d = parseUtcToLocal(createdAt);
      final hour = d.hour % 12 == 0 ? 12 : d.hour % 12;
      final minute = d.minute.toString().padLeft(2, '0');
      final ampm = d.hour >= 12 ? 'PM' : 'AM';
      return '$hour:$minute $ampm';
    } catch (e) {
      return createdAt;
    }
  }
}
