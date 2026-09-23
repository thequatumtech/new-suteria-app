import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import 'package:soperia_user/model_class/notification_model.dart';

IconData getNotificationIcon(String? type) {
  switch (type) {
    case 'chat_message':
      return Icons.chat_bubble_outline_rounded;
    case 'claim_message':
      return Icons.mark_chat_unread_outlined;
    case 'claim_status':
      return Icons.verified_user_outlined;
    case 'complaint_status':
      return Icons.support_agent_rounded;
    case 'coupon':
      return Icons.local_offer_outlined;
    case 'expiry_reminder':
      return Icons.alarm_outlined;
    default:
      return Icons.notifications_active_outlined;
  }
}

Color getNotificationColor(String? type) {
  switch (type) {
    case 'chat_message':
      return deepBlue;
    case 'claim_message':
      return deepBlueShade2;
    case 'claim_status':
      return availableColor;
    case 'complaint_status':
      return orange;
    case 'coupon':
      return purpleColor;
    case 'expiry_reminder':
      return brightRed;
    default:
      return deepBlue;
  }
}

void showInAppNotificationBanner({
  required NotificationItem notification,
  required VoidCallback onTap,
}) {
  final icon = getNotificationIcon(notification.type);
  final color = getNotificationColor(notification.type);

  Get.rawSnackbar(
    snackPosition: SnackPosition.TOP,
    backgroundColor: Colors.transparent,
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    padding: EdgeInsets.zero,
    duration: const Duration(seconds: 4),
    isDismissible: true,
    messageText: InkWell(
      onTap: () {
        Get.closeCurrentSnackbar();
        onTap();
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: primaryWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: skyBlueShade2, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: AppText(
                          text: notification.title ?? 'Notification',
                          size: 14,
                          fontWeight: FontWeight.w700,
                          txtColor: blackShade,
                          maxLine: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  AppText(
                    text: notification.body ?? '',
                    size: 12,
                    fontWeight: FontWeight.w400,
                    txtColor: lightBlack,
                    maxLine: 2,
                    overflow: TextOverflow.ellipsis,
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
