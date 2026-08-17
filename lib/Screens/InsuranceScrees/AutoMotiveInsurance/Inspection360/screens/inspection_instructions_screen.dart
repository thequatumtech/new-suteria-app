import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soperia_user/app_utils/app_button.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import '../controllers/vehicle_inspection_controller.dart';
import '../models/vehicle_profile.dart';
import 'guided_360_camera_screen.dart';

class InspectionInstructionsScreen extends StatefulWidget {
  final String plateNumber;
  final String chassisNumber;
  final String? vehicleTypeName;
  final String? vehicleCategoryName;
  final String? vehicleBrandName;

  const InspectionInstructionsScreen({
    super.key,
    required this.plateNumber,
    required this.chassisNumber,
    this.vehicleTypeName,
    this.vehicleCategoryName,
    this.vehicleBrandName,
  });

  @override
  State<InspectionInstructionsScreen> createState() => _InspectionInstructionsScreenState();
}

class _InspectionInstructionsScreenState extends State<InspectionInstructionsScreen> {
  final VehicleInspectionController controller = Get.put(VehicleInspectionController());

  @override
  Widget build(BuildContext context) {
    final vehicleProfile = VehicleProfile.fromTypeString(
      widget.vehicleTypeName,
      categoryName: widget.vehicleCategoryName,
      brandName: widget.vehicleBrandName,
    );

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
          text: '360° Exterior Inspection',
          size: 18,
          fontWeight: FontWeight.bold,
          txtColor: primaryBlack,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Vehicle Information Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: primaryWhite,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: skyBlueShade2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: skyBlueShade4,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(vehicleProfile.icon, color: buttonColorApp, size: 32),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppText(
                              text: 'Vehicle Plate Number',
                              size: 12,
                              txtColor: primaryGray,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: buttonColorApp.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                vehicleProfile.displayName,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: buttonColorApp,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        AppText(
                          text: widget.plateNumber.isNotEmpty ? widget.plateNumber : 'GJ01XX1234',
                          size: 17,
                          fontWeight: FontWeight.bold,
                          txtColor: primaryBlack,
                        ),
                        if (widget.chassisNumber.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          AppText(
                            text: 'Chassis: ${widget.chassisNumber}',
                            size: 12,
                            txtColor: primaryGray,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            AppText(
              text: 'How it works',
              size: 18,
              fontWeight: FontWeight.bold,
              txtColor: primaryBlack,
            ),
            const SizedBox(height: 14),

            _buildInstructionItem(
              icon: Icons.directions_walk_rounded,
              title: '1. Walk around the vehicle',
              description: 'Start at the front and walk clockwise in a continuous circle around the entire vehicle exterior.',
            ),
            const SizedBox(height: 12),
            _buildInstructionItem(
              icon: Icons.track_changes_rounded,
              title: '2. Real-time 360° Radar Guide',
              description: 'The circular guide tracks device heading. Ensure all arc zones turn green.',
            ),
            const SizedBox(height: 12),
            _buildInstructionItem(
              icon: Icons.speed_rounded,
              title: '3. Maintain steady speed',
              description: 'Walk slowly and keep the entire vehicle in frame. Avoid fast jerky movements.',
            ),
            const SizedBox(height: 12),
            _buildInstructionItem(
              icon: Icons.verified_user_outlined,
              title: '4. Real Vehicle Verification',
              description: 'Hold phone upright at eye level 2-3 meters from the vehicle. Toys or indoor objects are rejected.',
            ),
            const SizedBox(height: 32),

            AppBtnWithColorShades(
              onTap: () async {
                bool granted = await controller.requestPermissions();
                if (!granted) {
                  if (mounted) {
                    if (controller.isPermissionPermanentlyDenied.value) {
                      _showPermissionSettingsDialog();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: brightRed,
                          content: Text('Camera and microphone permissions are required to record the vehicle inspection.'),
                        ),
                      );
                    }
                  }
                  return;
                }

                await controller.startInspectionSession(
                  plateNumber: widget.plateNumber,
                  chassisNumber: widget.chassisNumber,
                  vehicleTypeName: widget.vehicleTypeName,
                  vehicleCategoryName: widget.vehicleCategoryName,
                  vehicleBrandName: widget.vehicleBrandName,
                );

                if (mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Guided360CameraScreen(),
                    ),
                  );
                }
              },
              btnTxt: 'Begin 360° Inspection',
              color1: darkBlue2,
              color2: darkBlue1,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showPermissionSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Camera Permission Required'),
        content: const Text(
          'Camera and microphone access are required to record the 360° vehicle inspection. Please enable permissions in your device settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: buttonColorApp),
            onPressed: () {
              Navigator.pop(context);
              controller.openSettings();
            },
            child: const Text('Open Settings', style: TextStyle(color: primaryWhite)),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: primaryWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primaryGreyShade1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: skyBlueShade2.withOpacity(0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: darkBlue2, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: title,
                  size: 14,
                  fontWeight: FontWeight.bold,
                  txtColor: primaryBlack,
                ),
                const SizedBox(height: 4),
                AppText(
                  text: description,
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
