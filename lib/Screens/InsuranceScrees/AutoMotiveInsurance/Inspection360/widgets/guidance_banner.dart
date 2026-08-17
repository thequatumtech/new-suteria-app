import 'package:flutter/material.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import '../services/guidance_engine.dart';

class GuidanceBanner extends StatelessWidget {
  final GuidanceMessage guidance;

  const GuidanceBanner({
    super.key,
    required this.guidance,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color borderColor;
    Color iconColor;

    switch (guidance.level) {
      case GuidanceLevel.success:
        bgColor = const Color(0xffE8F8F0);
        borderColor = const Color(0xff00BD79);
        iconColor = const Color(0xff00BD79);
        break;
      case GuidanceLevel.warning:
        bgColor = const Color(0xffFFF8E4);
        borderColor = const Color(0xffF2B200);
        iconColor = const Color(0xffEEB300);
        break;
      case GuidanceLevel.info:
        bgColor = skyBlueShade4;
        borderColor = buttonColorApp;
        iconColor = buttonColorApp;
        break;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              guidance.icon,
              color: iconColor,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                AppText(
                  text: guidance.title,
                  size: 14,
                  fontWeight: FontWeight.bold,
                  txtColor: primaryBlack,
                ),
                const SizedBox(height: 2),
                AppText(
                  text: guidance.message,
                  size: 12,
                  txtColor: lightBlack,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
