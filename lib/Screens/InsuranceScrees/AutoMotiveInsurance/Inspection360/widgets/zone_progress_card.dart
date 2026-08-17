import 'package:flutter/material.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import '../models/inspection_zone.dart';

class ZoneProgressCard extends StatelessWidget {
  final List<InspectionZone> zones;
  final Function(InspectionZone)? onZoneTap;

  const ZoneProgressCard({
    super.key,
    required this.zones,
    this.onZoneTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: primaryWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryGreyShade1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                text: 'Inspection Zones',
                size: 16,
                fontWeight: FontWeight.bold,
                txtColor: primaryBlack,
              ),
              AppText(
                text: '${zones.where((z) => z.status == ZoneCaptureStatus.captured).length} / ${zones.length} Captured',
                size: 13,
                fontWeight: FontWeight.w600,
                txtColor: buttonColorApp,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: zones.map((zone) {
              Color chipBg;
              Color chipBorder;
              Color textCol;
              IconData? icon;

              switch (zone.status) {
                case ZoneCaptureStatus.captured:
                  chipBg = const Color(0xffE8F8F0);
                  chipBorder = const Color(0xff00BD79);
                  textCol = const Color(0xff008A58);
                  icon = Icons.check_circle_rounded;
                  break;
                case ZoneCaptureStatus.recording:
                  chipBg = const Color(0xffFFF8E4);
                  chipBorder = const Color(0xffF2B200);
                  textCol = const Color(0xff996B00);
                  icon = Icons.fiber_manual_record;
                  break;
                case ZoneCaptureStatus.missing:
                  chipBg = const Color(0xffFDECEB);
                  chipBorder = const Color(0xffFF3B30);
                  textCol = const Color(0xffD32F2F);
                  icon = Icons.error_outline;
                  break;
                case ZoneCaptureStatus.notCaptured:
                  chipBg = primarywhiteShade1;
                  chipBorder = primaryGreyShade1;
                  textCol = primaryGray;
                  icon = Icons.radio_button_unchecked;
                  break;
              }

              return InkWell(
                onTap: onZoneTap != null ? () => onZoneTap!(zone) : null,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: chipBg,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: chipBorder, width: 1.1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(icon, size: 14, color: textCol),
                      const SizedBox(width: 5),
                      Text(
                        zone.shortLabel,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: textCol,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
