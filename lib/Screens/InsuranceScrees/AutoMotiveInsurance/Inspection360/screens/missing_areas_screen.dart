import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soperia_user/app_utils/app_button.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import '../controllers/vehicle_inspection_controller.dart';
import '../models/inspection_zone.dart';
import '../widgets/vehicle_360_radar_widget.dart';
import '../widgets/zone_progress_card.dart';

class MissingAreasScreen extends StatelessWidget {
  const MissingAreasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<VehicleInspectionController>();

    return Scaffold(
      backgroundColor: primarywhiteShade,
      appBar: AppBar(
        backgroundColor: primaryWhite,
        elevation: 0,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.keyboard_backspace_outlined, color: primaryBlack),
        ),
        title: AppText(
          text: 'Inspection Coverage Status',
          size: 18,
          fontWeight: FontWeight.bold,
          txtColor: primaryBlack,
        ),
      ),
      body: Obx(() {
        final missingZones = controller.zones.where((z) => z.status != ZoneCaptureStatus.captured).toList();
        final capturedZones = controller.zones.where((z) => z.status == ZoneCaptureStatus.captured).toList();
        final coverage = controller.coveragePercentage.value;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 360 Radar View
              Center(
                child: Vehicle360RadarWidget(
                  zones: controller.zones.toList(),
                  currentAngle: controller.currentAngle.value,
                  size: 200,
                ),
              ),
              const SizedBox(height: 20),

              // Coverage status card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: primaryWhite,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: skyBlueShade2),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText(
                          text: 'Exterior Coverage',
                          size: 15,
                          fontWeight: FontWeight.bold,
                          txtColor: primaryBlack,
                        ),
                        AppText(
                          text: '${coverage.toStringAsFixed(0)}%',
                          size: 16,
                          fontWeight: FontWeight.bold,
                          txtColor: coverage >= 100 ? const Color(0xff00BD79) : const Color(0xffE53935),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: coverage / 100.0,
                        minHeight: 8,
                        backgroundColor: primaryGreyShade1,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          coverage >= 100 ? const Color(0xff00BD79) : buttonColorApp,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatChip(
                          icon: Icons.check_circle,
                          color: const Color(0xff00BD79),
                          label: '${capturedZones.length} Completed',
                        ),
                        _buildStatChip(
                          icon: Icons.warning_amber_rounded,
                          color: const Color(0xffE53935),
                          label: '${missingZones.length} Remaining',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Breakdown of Zones
              ZoneProgressCard(
                zones: controller.zones.toList(),
                onZoneTap: (zone) {
                  // Direct recovery jump
                  controller.simulateAngle(zone.centerAngle);
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 24),

              if (missingZones.isNotEmpty)
                AppBtnWithColorShades(
                  onTap: () {
                    // Navigate back to camera to record missing areas
                    Navigator.pop(context);
                  },
                  btnTxt: 'Capture Missing Areas (${missingZones.length})',
                  color1: darkBlue2,
                  color2: darkBlue1,
                )
              else
                AppBtnWithColorShades(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  btnTxt: 'Return to Inspection',
                  color1: const Color(0xff00BD79),
                  color2: const Color(0xff008A58),
                ),
              const SizedBox(height: 16),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStatChip({required IconData icon, required Color color, required String label}) {
    return Row(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 6),
        AppText(
          text: label,
          size: 13,
          fontWeight: FontWeight.w600,
          txtColor: primaryBlack,
        ),
      ],
    );
  }
}
