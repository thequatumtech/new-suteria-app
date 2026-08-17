import 'package:flutter/material.dart';
import 'package:soperia_user/app_utils/app_button.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import '../models/inspection_manifest.dart';
import '../models/inspection_zone.dart';
import 'vehicle_360_radar_widget.dart';

class InspectionStatusCard extends StatelessWidget {
  final InspectionManifest? manifest;
  final bool isCompleted;
  final VoidCallback onStartInspection;
  final VoidCallback onReviewInspection;
  final VoidCallback onRetakeInspection;

  const InspectionStatusCard({
    super.key,
    required this.manifest,
    required this.isCompleted,
    required this.onStartInspection,
    required this.onReviewInspection,
    required this.onRetakeInspection,
  });

  @override
  Widget build(BuildContext context) {
    final double rawCoverage = manifest?.coveragePercentage ?? 0.0;
    final double coverage = isCompleted
        ? 100.0
        : (rawCoverage > 0.0 ? rawCoverage : 0.0);

    final List<InspectionZone> baseZones = manifest?.zones ?? VehicleInspectionZoneConfig.getDefault12Zones();
    final List<InspectionZone> currentZones = baseZones.map((z) {
      if (isCompleted || z.status == ZoneCaptureStatus.captured) {
        return z.copyWith(status: ZoneCaptureStatus.captured);
      }
      return z;
    }).toList();

    final int totalZones = currentZones.length;
    final int capturedZones = isCompleted
        ? totalZones
        : currentZones.where((z) => z.status == ZoneCaptureStatus.captured).length;

    // Calculate total duration and file size
    double totalDurationSeconds = 0.0;
    int totalBytes = 0;
    if (manifest != null && manifest!.segments.isNotEmpty) {
      for (var s in manifest!.segments) {
        totalDurationSeconds += s.durationSeconds;
        totalBytes += s.fileSizeBytes;
      }
    }
    final double totalMb = totalBytes / (1024 * 1024);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: primaryWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCompleted ? const Color(0xff00BD79) : skyBlueShade2,
          width: isCompleted ? 1.8 : 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Header with Icon & Status
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isCompleted ? const Color(0xffE8F8F0) : skyBlueShade2.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isCompleted ? Icons.check_circle : Icons.videocam_rounded,
                  color: isCompleted ? const Color(0xff00BD79) : buttonColorApp,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      text: 'Guided 360° Exterior Inspection',
                      size: 16,
                      fontWeight: FontWeight.bold,
                      txtColor: primaryBlack,
                    ),
                    const SizedBox(height: 2),
                    AppText(
                      text: isCompleted
                          ? 'Video Inspection Complete ($capturedZones/$totalZones Sectors Captured)'
                          : manifest != null && coverage > 0
                              ? 'Inspection in progress (${coverage.toStringAsFixed(0)}% completed)'
                              : 'Continuous video recording around vehicle required',
                      size: 12,
                      txtColor: isCompleted ? const Color(0xff008A58) : primaryGray,
                    ),
                  ],
                ),
              ),
              if (isCompleted)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xffE8F8F0),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xff00BD79)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.verified, size: 13, color: Color(0xff00BD79)),
                      SizedBox(width: 3),
                      Text(
                        'Attached',
                        style: TextStyle(
                          color: Color(0xff008A58),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),

          // 2. Radar and Recording Statistics
          Row(
            children: [
              Vehicle360RadarWidget(
                zones: currentZones,
                currentAngle: 0.0,
                size: 110,
                showPointer: false,
                showCarIcon: true,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText(
                          text: 'Coverage Status',
                          size: 13,
                          fontWeight: FontWeight.w600,
                          txtColor: primaryBlack,
                        ),
                        AppText(
                          text: '${coverage.toStringAsFixed(0)}%',
                          size: 14,
                          fontWeight: FontWeight.bold,
                          txtColor: isCompleted ? const Color(0xff00BD79) : buttonColorApp,
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: coverage / 100.0,
                        minHeight: 8,
                        backgroundColor: primaryGreyShade1,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isCompleted ? const Color(0xff00BD79) : buttonColorApp,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (isCompleted && manifest != null) ...[
                      Row(
                        children: [
                          const Icon(Icons.videocam_outlined, size: 14, color: primaryGray),
                          const SizedBox(width: 4),
                          Expanded(
                            child: AppText(
                              text: '${manifest!.segments.length} Video Clip${manifest!.segments.length > 1 ? 's' : ''}'
                                  '${totalDurationSeconds > 0 ? ' (${totalDurationSeconds.toStringAsFixed(0)}s)' : ''}',
                              size: 11.5,
                              txtColor: primaryGray,
                              maxLine: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      if (totalMb > 0) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.cloud_done_outlined, size: 14, color: Color(0xff00BD79)),
                            const SizedBox(width: 4),
                            Expanded(
                              child: AppText(
                                text: '${totalMb.toStringAsFixed(1)} MB • Policy Upload Ready',
                                size: 11,
                                txtColor: const Color(0xff008A58),
                                maxLine: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ] else ...[
                      Row(
                        children: [
                          const Icon(Icons.info_outline, size: 14, color: primaryGray),
                          const SizedBox(width: 4),
                          Expanded(
                            child: AppText(
                              text: '12 angles to be recorded',
                              size: 11.5,
                              txtColor: primaryGray,
                              maxLine: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),

          // 3. Captured Angle Pills (when completed)
          if (isCompleted) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: primarywhiteShade,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.shield_outlined, size: 14, color: Color(0xff008A58)),
                      SizedBox(width: 4),
                      Text(
                        'Verified Angle Coverage',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: primaryBlack),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: currentZones.map((zone) {
                      final isZoneCaptured = zone.status == ZoneCaptureStatus.captured || isCompleted;
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: isZoneCaptured ? const Color(0xffE8F8F0) : Colors.black12,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: isZoneCaptured ? const Color(0xff00BD79).withOpacity(0.4) : Colors.transparent,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isZoneCaptured ? Icons.check : Icons.circle,
                              size: 10,
                              color: isZoneCaptured ? const Color(0xff008A58) : Colors.grey,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              zone.shortLabel,
                              style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w600,
                                color: isZoneCaptured ? const Color(0xff008A58) : Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 16),

          // 4. Action Buttons
          if (isCompleted)
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onRetakeInspection,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: darkBlue2,
                      side: const BorderSide(color: darkBlue2),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    icon: const Icon(Icons.refresh, size: 18),
                    label: const Text('Retake', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onReviewInspection,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColorApp,
                      foregroundColor: primaryWhite,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    icon: const Icon(Icons.play_circle_fill, size: 18),
                    label: const Text('Watch & Review', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            )
          else
            AppBtnWithColorShades(
              onTap: onStartInspection,
              btnTxt: manifest != null && coverage > 0 ? 'Continue Inspection' : 'Start 360° Video Inspection',
              color1: darkBlue2,
              color2: darkBlue1,
            ),
        ],
      ),
    );
  }
}
