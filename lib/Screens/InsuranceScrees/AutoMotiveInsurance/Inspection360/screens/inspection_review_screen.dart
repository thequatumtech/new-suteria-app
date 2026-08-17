import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soperia_user/Screens/InsuranceScrees/AutoMotiveInsurance/motor_insurance_controller.dart';
import 'package:soperia_user/app_utils/app_button.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import 'package:video_player/video_player.dart';
import '../controllers/vehicle_inspection_controller.dart';
import '../models/inspection_zone.dart';
import '../widgets/vehicle_360_radar_widget.dart';

class InspectionReviewScreen extends StatefulWidget {
  const InspectionReviewScreen({super.key});

  @override
  State<InspectionReviewScreen> createState() => _InspectionReviewScreenState();
}

class _InspectionReviewScreenState extends State<InspectionReviewScreen> {
  final VehicleInspectionController inspectionController = Get.find<VehicleInspectionController>();
  final MotorInsuranceController motorInsuranceController = Get.find<MotorInsuranceController>();

  VideoPlayerController? _videoPlayerController;
  int _selectedSegmentIndex = 0;
  bool _isPlaying = false;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  Future<void> _initializeVideoPlayer() async {
    if (inspectionController.recordedSegments.isNotEmpty) {
      final segment = inspectionController.recordedSegments[_selectedSegmentIndex];
      final file = File(segment.filePath);
      if (await file.exists()) {
        _videoPlayerController?.dispose();
        _videoPlayerController = VideoPlayerController.file(file);
        await _videoPlayerController!.initialize();
        _videoPlayerController!.addListener(() {
          if (mounted) {
            setState(() {
              _isPlaying = _videoPlayerController!.value.isPlaying;
            });
          }
        });
        setState(() {});
      }
    }
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          text: 'Review 360° Inspection',
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
            // Status Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xffE8F8F0),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xff00BD79), width: 1.5),
              ),
              child: Row(
                children: [
                  const Icon(Icons.verified, color: Color(0xff00BD79), size: 36),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          text: '360° Exterior Validated',
                          size: 16,
                          fontWeight: FontWeight.bold,
                          txtColor: const Color(0xff008A58),
                        ),
                        const SizedBox(height: 2),
                        AppText(
                          text: 'All required exterior zones captured with high integrity evidence.',
                          size: 12,
                          txtColor: lightBlack,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 360 Radar & Overview
            Center(
              child: Vehicle360RadarWidget(
                zones: inspectionController.zones.toList(),
                currentAngle: 0.0,
                showPointer: false,
                size: 200,
              ),
            ),
            const SizedBox(height: 20),

            // Video Player Section
            if (inspectionController.recordedSegments.isNotEmpty) ...[
              AppText(
                text: 'Recorded Video Segments',
                size: 16,
                fontWeight: FontWeight.bold,
                txtColor: primaryBlack,
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                height: 220,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: _videoPlayerController != null && _videoPlayerController!.value.isInitialized
                    ? Stack(
                        alignment: Alignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: AspectRatio(
                              aspectRatio: _videoPlayerController!.value.aspectRatio,
                              child: VideoPlayer(_videoPlayerController!),
                            ),
                          ),
                          IconButton(
                            iconSize: 50,
                            icon: Icon(
                              _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                              color: primaryWhite.withOpacity(0.85),
                            ),
                            onPressed: () {
                              setState(() {
                                if (_videoPlayerController!.value.isPlaying) {
                                  _videoPlayerController!.pause();
                                } else {
                                  _videoPlayerController!.play();
                                }
                              });
                            },
                          ),
                        ],
                      )
                    : const Center(
                        child: CircularProgressIndicator(color: primaryWhite),
                      ),
              ),
              const SizedBox(height: 10),

              // Segment Selector chips
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: inspectionController.recordedSegments.length,
                  itemBuilder: (context, index) {
                    final isSelected = index == _selectedSegmentIndex;
                    final seg = inspectionController.recordedSegments[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text('Segment ${index + 1} (${seg.durationSeconds.toStringAsFixed(1)}s)'),
                        selected: isSelected,
                        selectedColor: buttonColorApp,
                        labelStyle: TextStyle(
                          color: isSelected ? primaryWhite : primaryBlack,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _selectedSegmentIndex = index;
                            });
                            _initializeVideoPlayer();
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Evidence Checklist & SHA-256 Hashes
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: primaryWhite,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: primaryGreyShade1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: 'Evidence Integrity & Metadata',
                    size: 15,
                    fontWeight: FontWeight.bold,
                    txtColor: primaryBlack,
                  ),
                  const SizedBox(height: 10),
                  _buildEvidenceRow(
                    label: 'Inspection ID',
                    value: inspectionController.inspectionId,
                  ),
                  _buildEvidenceRow(
                    label: 'Vehicle Plate',
                    value: inspectionController.vehiclePlateNumber,
                  ),
                  _buildEvidenceRow(
                    label: 'Coverage',
                    value: '${inspectionController.coveragePercentage.value.toStringAsFixed(0)}% Complete',
                  ),
                  _buildEvidenceRow(
                    label: 'Segments Recorded',
                    value: '${inspectionController.recordedSegments.length} files',
                  ),
                  if (inspectionController.recordedSegments.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    const Divider(),
                    const SizedBox(height: 8),
                    AppText(
                      text: 'SHA-256 Checksums:',
                      size: 12,
                      fontWeight: FontWeight.bold,
                      txtColor: primaryGray,
                    ),
                    const SizedBox(height: 4),
                    ...inspectionController.recordedSegments.take(3).map(
                          (s) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Text(
                              '${s.id}: ${s.sha256Hash.isNotEmpty ? '${s.sha256Hash.substring(0, 16)}...' : 'Generated'}',
                              style: const TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 11,
                                color: lightBlack,
                              ),
                            ),
                          ),
                        ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Submit Button
            _isSubmitting
                ? const Center(child: CircularProgressIndicator())
                : AppBtnWithColorShades(
                    onTap: () async {
                      setState(() {
                        _isSubmitting = true;
                      });

                      final manifest = await inspectionController.buildManifest();
                      manifest.isCompleted = true;
                      manifest.coveragePercentage = 100.0;
                      for (var z in manifest.zones) {
                        z.status = ZoneCaptureStatus.captured;
                      }
                      motorInsuranceController.inspectionManifest.value = manifest;
                      motorInsuranceController.is360InspectionCompleted.value = true;
                      motorInsuranceController.selectedInspection360Videos.assignAll(
                        manifest.segments.map((s) => s.filePath).where((p) => p.isNotEmpty).toList(),
                      );

                      setState(() {
                        _isSubmitting = false;
                      });

                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: Color(0xff00BD79),
                            content: Text('360° exterior inspection successfully attached!'),
                          ),
                        );
                        // Return back to AutomotiveInsuranceFourthScreen
                        Navigator.of(context).popUntil((route) => route.isFirst || route.settings.name == null);
                      }
                    },
                    btnTxt: 'Attach & Confirm Inspection',
                    color1: darkBlue2,
                    color2: darkBlue1,
                  ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildEvidenceRow({required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppText(text: label, size: 13, txtColor: primaryGray),
          AppText(text: value, size: 13, fontWeight: FontWeight.w600, txtColor: primaryBlack),
        ],
      ),
    );
  }
}
