import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soperia_user/app_utils/app_button.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import '../controllers/vehicle_inspection_controller.dart';
import '../models/inspection_zone.dart';
import '../services/guidance_engine.dart';
import '../services/vehicle_detection_service.dart';
import '../widgets/guidance_banner.dart';
import '../widgets/vehicle_360_radar_widget.dart';
import 'inspection_review_screen.dart';
import 'missing_areas_screen.dart';

class Guided360CameraScreen extends StatefulWidget {
  const Guided360CameraScreen({Key? key}) : super(key: key);

  @override
  State<Guided360CameraScreen> createState() => _Guided360CameraScreenState();
}

class _Guided360CameraScreenState extends State<Guided360CameraScreen> {
  final VehicleInspectionController controller = Get.find<VehicleInspectionController>();

  @override
  void initState() {
    super.initState();
    controller.syncFromMotorInsuranceController();
    controller.initializeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Obx(() {
          return Stack(
            children: [
              // 1. Camera Preview or Permission Request View
              Positioned.fill(
                child: !controller.hasCameraPermission.value
                    ? Container(
                        color: Colors.black87,
                        padding: const EdgeInsets.all(24),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white10,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.camera_alt_outlined, size: 48, color: primaryWhite),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Camera Access Required',
                                style: TextStyle(color: primaryWhite, fontSize: 18, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Please allow camera and microphone access to record the 360° vehicle exterior inspection.',
                                style: TextStyle(color: Colors.white70, fontSize: 13),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 24),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: buttonColorApp,
                                  foregroundColor: primaryWhite,
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                onPressed: () async {
                                  if (controller.isPermissionPermanentlyDenied.value) {
                                    await controller.openSettings();
                                  } else {
                                    await controller.initializeCamera();
                                  }
                                },
                                icon: Icon(
                                  controller.isPermissionPermanentlyDenied.value ? Icons.settings : Icons.camera_alt,
                                  size: 18,
                                ),
                                label: Text(
                                  controller.isPermissionPermanentlyDenied.value ? 'Open Settings' : 'Grant Camera Access',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
                              ),
                            ],
                          ),
                        ),
                      )
                    : controller.isCameraInitialized.value && controller.cameraController != null
                        ? CameraPreview(controller.cameraController!)
                        : const Center(
                            child: CircularProgressIndicator(color: primaryWhite),
                          ),
              ),

              // 2. Viewfinder Target Overlay with Vehicle Profile Silhouette
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.86,
                  height: MediaQuery.of(context).size.height * 0.44,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: controller.isRecording.value
                          ? (controller.currentGuidance.value.level == GuidanceLevel.warning
                              ? const Color(0xffF4C211).withOpacity(0.85)
                              : const Color(0xff00BD79).withOpacity(0.85))
                          : (controller.isVehicleVerified.value
                              ? const Color(0xff00BD79).withOpacity(0.85)
                              : const Color(0xffF4C211).withOpacity(0.85)),
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Stack(
                    children: [
                      // Viewfinder top bar (Active Zone & Vehicle Profile)
                      Positioned(
                        top: 8,
                        left: 8,
                        right: 8,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(controller.vehicleProfile.value.icon, size: 14, color: buttonColorApp),
                                  const SizedBox(width: 4),
                                  Text(
                                    controller.vehicleProfile.value.effectiveDisplayName,
                                    style: const TextStyle(
                                      color: primaryWhite,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                controller.activeZone.value?.label ?? 'FRONT',
                                style: const TextStyle(
                                  color: primaryWhite,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Center Wireframe Silhouette
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              controller.vehicleProfile.value.icon,
                              size: 80,
                              color: controller.isRecording.value || controller.isVehicleVerified.value
                                  ? const Color(0xff00BD79).withOpacity(0.35)
                                  : const Color(0xffF4C211).withOpacity(0.25),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              controller.activeZone.value?.label ?? controller.vehicleProfile.value.effectiveDisplayName,
                              style: TextStyle(
                                color: controller.isRecording.value || controller.isVehicleVerified.value
                                    ? const Color(0xff00BD79).withOpacity(0.7)
                                    : const Color(0xffF4C211).withOpacity(0.6),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Status Badge (Bottom of Viewfinder)
                      Positioned(
                        bottom: 8,
                        left: 8,
                        right: 8,
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: (controller.isRecording.value || controller.isVehicleVerified.value)
                                  ? const Color(0xff00BD79).withOpacity(0.9)
                                  : Colors.amber.shade800.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.transparent,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  (controller.isRecording.value || controller.isVehicleVerified.value)
                                      ? Icons.check_circle_rounded
                                      : Icons.sync_rounded,
                                  size: 13,
                                  color: primaryWhite,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  controller.isRecording.value
                                      ? 'Area: ${controller.activeZone.value?.label ?? "Front"} • ${controller.coveragePercentage.value.toStringAsFixed(0)}%'
                                      : (controller.isVehicleVerified.value
                                          ? '${controller.vehicleProfile.value.effectiveDisplayName} in Frame • Ready'
                                          : 'Align with vehicle front'),
                                  style: const TextStyle(
                                    color: primaryWhite,
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 3. Top HUD Bar (Vehicle Plate, Timer & Coverage)
              Positioned(
                top: 10,
                left: 16,
                right: 16,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            if (controller.isRecording.value) {
                              _showExitConfirmationDialog();
                            } else {
                              Navigator.pop(context);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.close, color: primaryWhite, size: 22),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white24),
                          ),
                          child: Row(
                            children: [
                              Icon(controller.vehicleProfile.value.icon, color: buttonColorApp, size: 16),
                              const SizedBox(width: 6),
                              Text(
                                controller.vehiclePlateNumber.isNotEmpty
                                    ? '${controller.vehicleProfile.value.effectiveDisplayName} • ${controller.vehiclePlateNumber}'
                                    : controller.vehicleProfile.value.effectiveDisplayName,
                                style: const TextStyle(color: primaryWhite, fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: controller.isRecording.value ? const Color(0xffE53935) : Colors.black54,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              if (controller.isRecording.value) ...[
                                const Icon(Icons.fiber_manual_record, color: primaryWhite, size: 12),
                                const SizedBox(width: 4),
                              ],
                              Text(
                                controller.recordingTimeDisplay.value,
                                style: const TextStyle(color: primaryWhite, fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Live Guidance Banner
                    GuidanceBanner(guidance: controller.currentGuidance.value),
                  ],
                ),
              ),

              // 4. Floating 360° Radar Arc Overlay (Bottom Right)
              Positioned(
                bottom: 120,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.65),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Vehicle360RadarWidget(
                    zones: controller.zones.toList(),
                    currentAngle: controller.currentAngle.value,
                    activeZone: controller.activeZone.value,
                    vehicleProfile: controller.vehicleProfile.value,
                    size: 110,
                  ),
                ),
              ),

              // 5. Coverage Progress Indicator (Bottom Left)
              Positioned(
                bottom: 120,
                left: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.65),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Coverage: ',
                            style: TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                          Text(
                            '${controller.coveragePercentage.value.toStringAsFixed(0)}%',
                            style: TextStyle(
                              color: controller.coveragePercentage.value >= 100 ? const Color(0xff00BD79) : buttonColorApp,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${controller.recordedSegments.length} Segments',
                        style: const TextStyle(color: Colors.white54, fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ),

              // 6. Bottom Controls Bar
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Missing Areas button
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MissingAreasScreen(),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white24),
                        ),
                        child: const Icon(Icons.checklist_rounded, color: primaryWhite, size: 24),
                      ),
                    ),

                    // Main Record / Stop Button (gated by real-vehicle presence)
                    GestureDetector(
                      onTap: () async {
                        if (controller.isRecording.value) {
                          await controller.stopAndSaveSegment();
                        } else {
                          await controller.startRecording();
                        }
                      },
                      child: Container(
                        width: 76,
                        height: 76,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: controller.isRecording.value
                                ? const Color(0xffFF3B30)
                                : (controller.isVehicleVerified.value
                                    ? primaryWhite
                                    : Colors.white38),
                            width: 4,
                          ),
                          color: controller.isRecording.value
                              ? Colors.transparent
                              : (controller.isVehicleVerified.value
                                  ? buttonColorApp
                                  : Colors.black54),
                        ),
                        child: Center(
                          child: controller.isRecording.value
                              ? Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: const Color(0xffFF3B30),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                )
                              : (controller.isVehicleVerified.value
                                  ? Container(
                                      width: 56,
                                      height: 56,
                                      decoration: BoxDecoration(
                                        color: buttonColorApp,
                                        shape: BoxShape.circle,
                                      ),
                                    )
                                  : const Icon(
                                      Icons.lock_outline_rounded,
                                      color: Colors.white70,
                                      size: 28,
                                    )),
                        ),
                      ),
                    ),

                    // Finish / Review button
                    InkWell(
                      onTap: () async {
                        if (controller.isRecording.value) {
                          await controller.stopAndSaveSegment();
                        }

                        final validation = await controller.validateCurrentInspection();
                        if (validation.isComplete) {
                          if (mounted) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const InspectionReviewScreen(),
                              ),
                            );
                          }
                        } else {
                          if (mounted) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MissingAreasScreen(),
                              ),
                            );
                          }
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: controller.coveragePercentage.value >= 100 ? const Color(0xff00BD79) : Colors.black54,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white24),
                        ),
                        child: const Icon(Icons.check, color: primaryWhite, size: 24),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  void _showExitConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit Inspection?'),
        content: const Text('Your recorded segments are saved locally and can be resumed later.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Stay'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (controller.isRecording.value) {
                await controller.stopAndSaveSegment();
              }
              if (mounted) {
                Navigator.pop(context); // close dialog
                Navigator.pop(context); // close camera screen
              }
            },
            child: const Text('Save & Exit'),
          ),
        ],
      ),
    );
  }
}
