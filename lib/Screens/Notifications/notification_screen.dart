import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:soperia_user/Screens/Notifications/notification_controller.dart';
import 'package:soperia_user/app_utils/Common%20Widgets/in_app_notification_banner.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import 'package:soperia_user/language/language_constants.dart';
import 'package:soperia_user/model_class/notification_model.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final NotificationController controller = NotificationController.instance;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    controller.fetchNotifications(isRefresh: true);
    controller.fetchUnreadCount();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 150) {
        controller.loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  String _formatTime(DateTime? date) {
    if (date == null) return '';
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inSeconds < 60) {
      return getTranslated(context, 'just_now');
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ${getTranslated(context, 'ago')}';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ${getTranslated(context, 'ago')}';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ${getTranslated(context, 'ago')}';
    } else {
      return DateFormat('dd MMM yyyy').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: primaryWhite,
        surfaceTintColor: Colors.transparent,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: blackShade),
          onPressed: () => Navigator.pop(context),
        ),
        title: AppText(
          text: getTranslated(context, 'notifications'),
          size: 18,
          fontWeight: FontWeight.w700,
          txtColor: blackShade,
        ),
        centerTitle: true,
        actions: [
          Obx(() {
            if (controller.unreadCount.value == 0 && controller.notifications.every((e) => e.isRead)) {
              return const SizedBox.shrink();
            }
            return TextButton(
              onPressed: () => controller.markAllAsRead(),
              child: AppText(
                text: getTranslated(context, 'mark_all_read'),
                size: 13,
                fontWeight: FontWeight.w600,
                txtColor: deepBluedark,
              ),
            );
          }),
          const SizedBox(width: 8),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.notifications.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.notifications.isEmpty) {
          return _buildEmptyState();
        }

        return RefreshIndicator(
          color: deepBluedark,
          onRefresh: () async {
            await Future.wait([
              controller.fetchNotifications(isRefresh: true),
              controller.fetchUnreadCount(),
            ]);
          },
          child: ListView.separated(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            itemCount: controller.notifications.length + (controller.isMoreLoading.value ? 1 : 0),
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              if (index == controller.notifications.length) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              final item = controller.notifications[index];
              return _buildNotificationCard(item);
            },
          ),
        );
      }),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: skyBlueShade4,
                shape: BoxShape.circle,
                border: Border.all(color: gold.withValues(alpha: 0.5), width: 1.5),
              ),
              child: const Icon(
                Icons.notifications_none_rounded,
                size: 54,
                color: deepBluedark,
              ),
            ),
            const SizedBox(height: 20),
            AppText(
              text: 'no_notifications',
              size: 18,
              fontWeight: FontWeight.w700,
              txtColor: blackShade,
              txtAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            AppText(
              text: 'no_notifications_desc',
              size: 13,
              fontWeight: FontWeight.w400,
              txtColor: primaryGrey,
              txtAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard(NotificationItem item) {
    final icon = getNotificationIcon(item.type);
    final isUnread = !item.isRead;
    const Color listIconColor = deepBluedark; // deepblue (R:34, G:85, B:164 / #2255A4)
    const Color listBorderColor = gold; // (R:214, G:178, B:104 / #D6B268)

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => controller.handleNotificationTap(item, context),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isUnread ? primaryWhite : primaryWhite.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isUnread ? listBorderColor : listBorderColor.withValues(alpha: 0.5),
              width: isUnread ? 1.2 : 0.8,
            ),
            boxShadow: [
              BoxShadow(
                color: isUnread
                    ? listBorderColor.withValues(alpha: 0.1)
                    : Colors.black.withValues(alpha: 0.03),
                blurRadius: isUnread ? 12 : 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon Badge
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: listIconColor.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: listBorderColor.withValues(alpha: 0.35),
                    width: 1,
                  ),
                ),
                child: Icon(icon, color: listIconColor, size: 22),
              ),
              const SizedBox(width: 12),

              // Title, Body, Time
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: AppText(
                            text: item.title ?? 'Notification',
                            size: 14,
                            fontWeight: isUnread ? FontWeight.w700 : FontWeight.w600,
                            txtColor: blackShade,
                            maxLine: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isUnread) ...[
                          const SizedBox(width: 8),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: listIconColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    AppText(
                      text: item.body ?? '',
                      size: 13,
                      fontWeight: isUnread ? FontWeight.w500 : FontWeight.w400,
                      txtColor: isUnread ? blackShade1 : lightBlack,
                      maxLine: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    AppText(
                      text: _formatTime(item.createdAt),
                      size: 11,
                      fontWeight: FontWeight.w400,
                      txtColor: primaryGrey,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
