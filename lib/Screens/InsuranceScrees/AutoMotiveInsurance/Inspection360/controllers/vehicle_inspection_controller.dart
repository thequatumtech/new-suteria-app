import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;
import 'package:permission_handler/permission_handler.dart';

import '../models/inspection_manifest.dart';
import '../models/inspection_segment.dart';
import '../models/inspection_validation_result.dart';
import '../models/inspection_zone.dart';
import '../models/vehicle_profile.dart';
import '../services/coverage_engine.dart';
import '../services/guidance_engine.dart';
import '../services/inspection_storage_service.dart';
import '../services/inspection_validator.dart';
import '../services/sensor_orientation_service.dart';
import '../services/vehicle_detection_service.dart';
import '../../motor_insurance_controller.dart';

class VehicleInspectionController extends GetxController with WidgetsBindingObserver {
  // Services
  final CoverageEngine coverageEngine = CoverageEngine();
  final GuidanceEngine guidanceEngine = GuidanceEngine();
  final SensorOrientationService sensorService = SensorOrientationService();
  final InspectionStorageService storageService = InspectionStorageService();
  final InspectionValidator validator = InspectionValidator();
  final VehicleDetectionService detectionService = DefaultVehicleDetectionService();

  // Camera
  CameraController? cameraController;
  List<CameraDescription> availableCamerasList = [];

  // Observables
  Rx<VehicleProfile> vehicleProfile = VehicleProfile.sedan().obs;
  Rx<VehicleDetectionResult?> vehicleDetectionResult = Rx<VehicleDetectionResult?>(null);
  RxBool isVehicleVerified = false.obs;
  RxBool isCameraInitialized = false.obs;
  RxBool hasCameraPermission = false.obs;
  RxBool isPermissionPermanentlyDenied = false.obs;
  RxBool isRecording = false.obs;
  RxBool isPaused = false.obs;
  RxDouble currentAngle = 0.0.obs;
  RxDouble coveragePercentage = 0.0.obs;
  RxList<InspectionZone> zones = <InspectionZone>[].obs;
  Rx<InspectionZone?> activeZone = Rx<InspectionZone?>(null);
  RxList<InspectionSegment> recordedSegments = <InspectionSegment>[].obs;
  Rx<GuidanceMessage> currentGuidance = GuidanceMessage(
    title: 'Ready to Inspect',
    message: 'Tap record and walk slowly around the vehicle.',
    level: GuidanceLevel.info,
  ).obs;

  RxString recordingTimeDisplay = '00:00'.obs;
  RxBool isProcessingSegment = false.obs;

  // Active Session info
  String vehiclePlateNumber = '';
  String vehicleChassisNumber = '';
  String inspectionId = '';
  DateTime? recordingStartTime;
  DateTime? segmentStartTime;
  double segmentStartAngle = 0.0;
  Timer? _recordingTimer;
  Timer? _detectionTimer;
  int _secondsRecorded = 0;

  StreamSubscription? _sensorSub;
  StreamSubscription? _coverageSub;
  DeviceSensorReading? _lastSensorReading;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    syncFromMotorInsuranceController();

    _coverageSub = coverageEngine.stateStream.listen((state) {
      currentAngle.value = state.currentAngle;
      coveragePercentage.value = state.coveragePercentage;
      zones.assignAll(state.zones);
      activeZone.value = state.activeZone;
      _updateGuidance();
    });

    _sensorSub = sensorService.sensorStream.listen((reading) {
      _lastSensorReading = reading;
      coverageEngine.updateAngle(reading.headingDegrees);
      currentAngle.value = reading.headingDegrees;
      _updateGuidance();
      _evaluateVehiclePresence();
    });

    _startPeriodicDetection();
  }

  void syncFromMotorInsuranceController({
    String? plateNumber,
    String? chassisNumber,
    String? vehicleTypeName,
    String? vehicleCategoryName,
    String? vehicleBrandName,
  }) {
    String? typeName = vehicleTypeName;
    String? catName = vehicleCategoryName;
    String? brandName = vehicleBrandName;
    String plate = plateNumber ?? '';
    String chassis = chassisNumber ?? '';

    if (Get.isRegistered<MotorInsuranceController>()) {
      final motorCtrl = Get.find<MotorInsuranceController>();
      typeName ??= motorCtrl.selectVehicleType.value.name;
      catName ??= motorCtrl.selectVehicleTypeCategory.value.name;
      brandName ??= motorCtrl.selectVehicleBrand.value.name;
      if (plate.isEmpty) {
        plate = motorCtrl.vehiclePlateNoController.value.text;
      }
      if (chassis.isEmpty) {
        chassis = motorCtrl.vehicleChassisNoController.value.text;
      }
    }

    if (plate.isNotEmpty) vehiclePlateNumber = plate;
    if (chassis.isNotEmpty) vehicleChassisNumber = chassis;

    vehicleProfile.value = VehicleProfile.fromTypeString(
      typeName,
      categoryName: catName,
      brandName: brandName,
    );

    coverageEngine.loadZones(vehicleProfile.value.defaultZones);
    zones.assignAll(vehicleProfile.value.defaultZones);
  }

  int _steadyAlignmentTicks = 0;

  void _startPeriodicDetection() {
    _detectionTimer?.cancel();
    _detectionTimer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      _evaluateVehiclePresence();
    });
  }

  Future<void> _evaluateVehiclePresence() async {
    final result = await detectionService.evaluateVehiclePresence(
      targetProfile: vehicleProfile.value,
      sensorReading: _lastSensorReading,
      steadyAlignmentTicks: _steadyAlignmentTicks,
    );

    if (result.status == VehicleValidationStatus.aligning ||
        result.status == VehicleValidationStatus.verified) {
      _steadyAlignmentTicks++;
    } else {
      _steadyAlignmentTicks = 0;
    }

    vehicleDetectionResult.value = result;
    isVehicleVerified.value = result.isReadyToInspect;
  }

  void _updateGuidance() {
    currentGuidance.value = guidanceEngine.getGuidance(
      isRecording: isRecording.value,
      sensorReading: _lastSensorReading,
      activeZone: activeZone.value,
      missingZones: coverageEngine.missingZones,
      coveragePercentage: coveragePercentage.value,
    );
  }

  Future<bool> requestPermissions() async {
    final cameraStatus = await Permission.camera.status;
    final micStatus = await Permission.microphone.status;

    if (cameraStatus.isGranted && micStatus.isGranted) {
      hasCameraPermission.value = true;
      isPermissionPermanentlyDenied.value = false;
      return true;
    }

    final statuses = await [
      Permission.camera,
      Permission.microphone,
    ].request();

    final cameraGranted = statuses[Permission.camera]?.isGranted ?? false;
    final micGranted = statuses[Permission.microphone]?.isGranted ?? false;

    hasCameraPermission.value = cameraGranted && micGranted;
    isPermissionPermanentlyDenied.value =
        statuses[Permission.camera]?.isPermanentlyDenied == true ||
        statuses[Permission.microphone]?.isPermanentlyDenied == true;

    return hasCameraPermission.value;
  }

  Future<void> openSettings() async {
    await openAppSettings();
  }

  Future<void> initializeCamera() async {
    bool hasPermission = await requestPermissions();
    if (!hasPermission) {
      isCameraInitialized.value = false;
      return;
    }

    try {
      if (availableCamerasList.isEmpty) {
        availableCamerasList = await availableCameras();
      }

      if (availableCamerasList.isEmpty) {
        debugPrint('No cameras available on this device.');
        return;
      }

      final backCamera = availableCamerasList.firstWhere(
        (cam) => cam.lensDirection == CameraLensDirection.back,
        orElse: () => availableCamerasList.first,
      );

      cameraController = CameraController(
        backCamera,
        ResolutionPreset.high,
        enableAudio: true,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      await cameraController!.initialize();
      isCameraInitialized.value = true;
    } catch (e) {
      debugPrint('Error initializing camera: $e');
    }
  }

  Future<void> startInspectionSession({
    required String plateNumber,
    required String chassisNumber,
    String? vehicleTypeName,
    String? vehicleCategoryName,
    String? vehicleBrandName,
  }) async {
    inspectionId = 'INS_${DateTime.now().millisecondsSinceEpoch}';
    _steadyAlignmentTicks = 0;

    syncFromMotorInsuranceController(
      plateNumber: plateNumber,
      chassisNumber: chassisNumber,
      vehicleTypeName: vehicleTypeName,
      vehicleCategoryName: vehicleCategoryName,
      vehicleBrandName: vehicleBrandName,
    );

    // Check if there is an existing saved inspection to resume
    final saved = await storageService.loadActiveManifest();
    if (saved != null &&
        saved.vehiclePlateNumber == vehiclePlateNumber &&
        !saved.isCompleted) {
      inspectionId = saved.inspectionId;
      recordedSegments.assignAll(saved.segments);
      coverageEngine.loadZones(saved.zones);
      zones.assignAll(saved.zones);
      coveragePercentage.value = saved.coveragePercentage;
    } else {
      coverageEngine.loadZones(vehicleProfile.value.defaultZones);
      zones.assignAll(vehicleProfile.value.defaultZones);
      recordedSegments.clear();
      coveragePercentage.value = 0.0;
    }

    sensorService.startListening();
    _evaluateVehiclePresence();
  }

  Future<void> startRecording() async {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      await initializeCamera();
    }

    // Evaluate vehicle verification before starting recording
    final verification = await detectionService.evaluateVehiclePresence(
      targetProfile: vehicleProfile.value,
      sensorReading: _lastSensorReading,
      steadyAlignmentTicks: _steadyAlignmentTicks,
    );
    vehicleDetectionResult.value = verification;
    isVehicleVerified.value = verification.isReadyToInspect;

    if (!verification.isReadyToInspect) {
      Get.snackbar(
        'Vehicle Not Detected',
        verification.statusMessage,
        backgroundColor: const Color(0xffD32F2F),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 4),
        icon: const Icon(Icons.warning_amber_rounded, color: Colors.white),
      );
      return;
    }

    try {
      sensorService.calibrateOrigin();
      if (cameraController != null && !cameraController!.value.isRecordingVideo) {
        await cameraController!.startVideoRecording();
      }

      isRecording.value = true;
      isPaused.value = false;
      recordingStartTime = DateTime.now();
      segmentStartTime = DateTime.now();
      segmentStartAngle = 0.0;

      coverageEngine.startRecording();
      _startTimer();
    } catch (e) {
      debugPrint('Error starting video recording: $e');
    }
  }

  Future<void> pauseRecording() async {
    if (cameraController != null && cameraController!.value.isRecordingVideo) {
      try {
        await cameraController!.pauseVideoRecording();
        isPaused.value = true;
        coverageEngine.pauseRecording();
        _recordingTimer?.cancel();
      } catch (e) {
        debugPrint('Error pausing recording: $e');
      }
    }
  }

  Future<void> resumeRecording() async {
    if (cameraController != null && cameraController!.value.isRecordingVideo) {
      try {
        await cameraController!.resumeVideoRecording();
        isPaused.value = false;
        coverageEngine.resumeRecording();
        _startTimer();
      } catch (e) {
        debugPrint('Error resuming recording: $e');
      }
    }
  }

  Future<void> stopAndSaveSegment() async {
    if (cameraController == null || !cameraController!.value.isRecordingVideo) return;

    try {
      isProcessingSegment.value = true;
      final xFile = await cameraController!.stopVideoRecording();
      isRecording.value = false;
      isPaused.value = false;
      _recordingTimer?.cancel();
      coverageEngine.stopRecording();

      final now = DateTime.now();
      final dir = await storageService.getInspectionDirectory(inspectionId);
      final segmentIndex = recordedSegments.length + 1;
      final newFileName = 'segment_${segmentIndex.toString().padLeft(3, '0')}.mp4';
      final newFilePath = p.join(dir.path, newFileName);

      final originalFile = File(xFile.path);
      await originalFile.copy(newFilePath);

      // Compute SHA-256 hash & file size
      final shaHash = await storageService.calculateFileSha256(newFilePath);
      final fileSize = await storageService.getFileSize(newFilePath);

      final currentZoneId = activeZone.value?.id ?? 'SECTOR_${segmentStartAngle.toInt()}';
      final duration = segmentStartTime != null
          ? (now.difference(segmentStartTime!).inMilliseconds / 1000.0)
          : _secondsRecorded.toDouble();

      final segment = InspectionSegment(
        id: 'SEG_${DateTime.now().millisecondsSinceEpoch}',
        inspectionId: inspectionId,
        zoneId: currentZoneId,
        startAngle: segmentStartAngle,
        endAngle: currentAngle.value,
        startTime: segmentStartTime ?? now,
        endTime: now,
        durationSeconds: duration,
        filePath: newFilePath,
        sha256Hash: shaHash,
        fileSizeBytes: fileSize,
      );

      recordedSegments.add(segment);

      // Save manifest state locally
      await _persistManifest();

      isProcessingSegment.value = false;
    } catch (e) {
      isProcessingSegment.value = false;
      debugPrint('Error stopping and saving segment: $e');
    }
  }

  void _startTimer() {
    _recordingTimer?.cancel();
    _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _secondsRecorded++;
      final minutes = (_secondsRecorded ~/ 60).toString().padLeft(2, '0');
      final seconds = (_secondsRecorded % 60).toString().padLeft(2, '0');
      recordingTimeDisplay.value = '$minutes:$seconds';
    });
  }

  Future<void> _persistManifest() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String deviceModel = 'Mobile Device';
    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        deviceModel = '${androidInfo.brand} ${androidInfo.model}';
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        deviceModel = '${iosInfo.name} ${iosInfo.model}';
      }
    } catch (e) {}

    final manifest = InspectionManifest(
      inspectionId: inspectionId,
      vehiclePlateNumber: vehiclePlateNumber,
      vehicleChassisNumber: vehicleChassisNumber,
      createdAt: recordingStartTime ?? DateTime.now(),
      completedAt: coveragePercentage.value >= 100.0 ? DateTime.now() : null,
      coveragePercentage: coveragePercentage.value,
      segments: recordedSegments.toList(),
      zones: zones.toList(),
      deviceModel: deviceModel,
      appVersion: '1.0.0',
      isCompleted: coveragePercentage.value >= 100.0,
    );

    await storageService.saveManifest(manifest);
  }

  Future<InspectionManifest> buildManifest() async {
    await _persistManifest();
    final manifest = await storageService.loadManifest(inspectionId);
    return manifest ??
        InspectionManifest(
          inspectionId: inspectionId,
          vehiclePlateNumber: vehiclePlateNumber,
          vehicleChassisNumber: vehicleChassisNumber,
          createdAt: recordingStartTime ?? DateTime.now(),
          coveragePercentage: coveragePercentage.value,
          segments: recordedSegments.toList(),
          zones: zones.toList(),
          isCompleted: coveragePercentage.value >= 100.0,
        );
  }

  Future<InspectionValidationResult> validateCurrentInspection() async {
    final manifest = await buildManifest();
    return await validator.validate(manifest);
  }

  // Simulation / Manual angle update for testing or devices without compass
  void simulateAngle(double angleDeg) {
    sensorService.setHeadingManually(angleDeg);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive || state == AppLifecycleState.paused) {
      if (isRecording.value) {
        pauseRecording();
      }
    } else if (state == AppLifecycleState.resumed) {
      if (isPaused.value) {
        resumeRecording();
      }
    }
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    _recordingTimer?.cancel();
    _detectionTimer?.cancel();
    _sensorSub?.cancel();
    _coverageSub?.cancel();
    sensorService.dispose();
    coverageEngine.dispose();
    cameraController?.dispose();
    super.onClose();
  }
}
