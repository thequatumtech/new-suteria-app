import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:soperia_user/Screens/InsuranceScrees/AutoMotiveInsurance/Inspection360/models/inspection_manifest.dart';
import 'package:soperia_user/Screens/InsuranceScrees/AutoMotiveInsurance/Inspection360/models/inspection_segment.dart';
import 'package:soperia_user/Screens/InsuranceScrees/AutoMotiveInsurance/Inspection360/models/inspection_zone.dart';
import 'package:soperia_user/Screens/InsuranceScrees/AutoMotiveInsurance/Inspection360/models/vehicle_profile.dart';
import 'package:soperia_user/Screens/InsuranceScrees/AutoMotiveInsurance/Inspection360/services/coverage_engine.dart';
import 'package:soperia_user/Screens/InsuranceScrees/AutoMotiveInsurance/Inspection360/services/guidance_engine.dart';
import 'package:soperia_user/Screens/InsuranceScrees/AutoMotiveInsurance/Inspection360/services/inspection_storage_service.dart';
import 'package:soperia_user/Screens/InsuranceScrees/AutoMotiveInsurance/Inspection360/services/inspection_validator.dart';
import 'package:soperia_user/Screens/InsuranceScrees/AutoMotiveInsurance/Inspection360/services/sensor_orientation_service.dart';
import 'package:soperia_user/Screens/InsuranceScrees/AutoMotiveInsurance/Inspection360/services/vehicle_detection_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('InspectionZone and Angular Math Tests', () {
    test('Front Zone should handle 359° <-> 0° wraparound correctly', () {
      final frontZone = InspectionZone(
        id: 'FRONT',
        label: 'Front',
        shortLabel: 'Front',
        centerAngle: 0.0,
        startAngle: 345.0,
        endAngle: 15.0,
      );

      expect(frontZone.containsAngle(0.0), isTrue);
      expect(frontZone.containsAngle(350.0), isTrue);
      expect(frontZone.containsAngle(359.0), isTrue);
      expect(frontZone.containsAngle(10.0), isTrue);
      expect(frontZone.containsAngle(180.0), isFalse);
    });

    test('Side and Rear zones should match their angular sectors', () {
      final rightSideZone = InspectionZone(
        id: 'RIGHT_SIDE',
        label: 'Right Side',
        shortLabel: 'Right',
        centerAngle: 90.0,
        startAngle: 75.0,
        endAngle: 105.0,
      );

      expect(rightSideZone.containsAngle(90.0), isTrue);
      expect(rightSideZone.containsAngle(80.0), isTrue);
      expect(rightSideZone.containsAngle(100.0), isTrue);
      expect(rightSideZone.containsAngle(0.0), isFalse);
      expect(rightSideZone.containsAngle(270.0), isFalse);
    });

    test('12-zone default configuration covers all sectors around vehicle', () {
      final zones = VehicleInspectionZoneConfig.getDefault12Zones();
      expect(zones.length, equals(12));

      // Test angles across full 360 circle
      for (double angle = 0; angle < 360; angle += 15) {
        bool covered = zones.any((z) => z.containsAngle(angle, tolerance: 25.0));
        expect(covered, isTrue, reason: 'Angle $angle should be covered by at least one zone');
      }
    });
  });

  group('CoverageEngine Tests', () {
    test('Initial coverage should be 0%', () {
      final engine = CoverageEngine();
      expect(engine.coveragePercentage, equals(0.0));
      expect(engine.completedZones.length, equals(0));
      expect(engine.missingZones.length, equals(12));
      expect(engine.isFullyCovered, isFalse);
      engine.dispose();
    });

    test('Marking zones completed increases coverage percentage', () {
      final engine = CoverageEngine();
      engine.markZoneCompleted('FRONT');
      engine.markZoneCompleted('FRONT_RIGHT');
      engine.markZoneCompleted('RIGHT_FRONT');

      expect(engine.completedZones.length, equals(3));
      expect(engine.coveragePercentage, closeTo(25.0, 0.1));
      expect(engine.isFullyCovered, isFalse);

      // Complete all remaining zones
      for (var z in engine.zones) {
        engine.markZoneCompleted(z.id);
      }

      expect(engine.coveragePercentage, equals(100.0));
      expect(engine.isFullyCovered, isTrue);
      expect(engine.missingZones.isEmpty, isTrue);
      engine.dispose();
    });
  });

  group('InspectionValidator Tests', () {
    test('Validator fails when required zones are missing', () async {
      final validator = InspectionValidator(minimumRequiredCoverage: 100.0);
      final manifest = InspectionManifest(
        inspectionId: 'INS_TEST_001',
        vehiclePlateNumber: 'GJ01AB1234',
        vehicleChassisNumber: 'CHAS12345678',
        createdAt: DateTime.now(),
      );

      final result = await validator.validate(manifest);
      expect(result.isComplete, isFalse);
      expect(result.canSubmit, isFalse);
      expect(result.missingZones.isNotEmpty, isTrue);
      expect(result.errors.isNotEmpty, isTrue);
    });

    test('Validator passes when 100% zones captured and segments exist', () async {
      final validator = InspectionValidator(minimumRequiredCoverage: 100.0);
      final zones = VehicleInspectionZoneConfig.getDefault12Zones();
      for (var z in zones) {
        z.status = ZoneCaptureStatus.captured;
      }

      // Create a temporary dummy video file to test existence
      final tempDir = Directory.systemTemp;
      final tempVideo = File('${tempDir.path}/test_segment.mp4');
      await tempVideo.writeAsString('mock video binary content');

      final segment = InspectionSegment(
        id: 'SEG_TEST_01',
        inspectionId: 'INS_TEST_002',
        zoneId: 'FRONT',
        startAngle: 345,
        endAngle: 15,
        startTime: DateTime.now().subtract(const Duration(seconds: 10)),
        endTime: DateTime.now(),
        durationSeconds: 10.0,
        filePath: tempVideo.path,
        sha256Hash: 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
        fileSizeBytes: await tempVideo.length(),
      );

      final manifest = InspectionManifest(
        inspectionId: 'INS_TEST_002',
        vehiclePlateNumber: 'GJ01AB1234',
        vehicleChassisNumber: 'CHAS12345678',
        createdAt: DateTime.now(),
        zones: zones,
        segments: [segment],
        isCompleted: true,
      );

      final result = await validator.validate(manifest);
      expect(result.isComplete, isTrue);
      expect(result.canSubmit, isTrue);
      expect(result.coveragePercentage, equals(100.0));

      if (await tempVideo.exists()) {
        await tempVideo.delete();
      }
    });
  });

  group('GuidanceEngine Tests', () {
    test('Speed warning is triggered when angular velocity is too high', () {
      final guidance = GuidanceEngine();
      final reading = DeviceSensorReading(
        headingDegrees: 90.0,
        angularVelocity: 110.0, // Exceeds threshold (90 deg/sec)
        pitch: 0.0,
        roll: 0.0,
        isSteady: false,
        isMovingTooFast: true,
      );

      final msg = guidance.getGuidance(
        isRecording: true,
        sensorReading: reading,
        activeZone: null,
        missingZones: [],
        coveragePercentage: 50.0,
      );

      expect(msg.level, equals(GuidanceLevel.warning));
      expect(msg.title, contains('Walk Slowly'));
    });
  });

  group('Manifest Serialization Tests', () {
    test('Manifest serializes and deserializes cleanly with JSON', () {
      final original = InspectionManifest(
        inspectionId: 'INS_9999',
        vehiclePlateNumber: 'XYZ-999',
        vehicleChassisNumber: 'CHAS-999',
        createdAt: DateTime.now(),
        coveragePercentage: 75.0,
        deviceModel: 'Pixel 8',
        appVersion: '1.0.0',
        isCompleted: false,
      );

      final json = original.toJson();
      final deserialized = InspectionManifest.fromJson(json);

      expect(deserialized.inspectionId, equals(original.inspectionId));
      expect(deserialized.vehiclePlateNumber, equals(original.vehiclePlateNumber));
      expect(deserialized.coveragePercentage, equals(original.coveragePercentage));
      expect(deserialized.deviceModel, equals(original.deviceModel));
      expect(deserialized.zones.length, equals(12));
    });
  });

  group('VehicleProfile and Type Adaptation Tests', () {
    test('Correctly identifies Sedan, SUV, Motorcycle, and Truck profiles', () {
      final carProfile = VehicleProfile.fromTypeString('Sedan', categoryName: 'Private');
      expect(carProfile.bodyType, equals(VehicleBodyType.sedan));
      expect(carProfile.defaultZones.length, equals(12));

      final suvProfile = VehicleProfile.fromTypeString('SUV 4x4');
      expect(suvProfile.bodyType, equals(VehicleBodyType.suv));
      expect(suvProfile.defaultZones.length, equals(12));

      final bikeProfile = VehicleProfile.fromTypeString('Motorcycle Two Wheeler');
      expect(bikeProfile.bodyType, equals(VehicleBodyType.motorcycle));
      expect(bikeProfile.defaultZones.length, equals(8));

      final truckProfile = VehicleProfile.fromTypeString('Heavy Commercial Truck');
      expect(truckProfile.bodyType, equals(VehicleBodyType.truck));
      expect(truckProfile.defaultZones.length, equals(12));
    });
  });

  group('Real-Vehicle Verification & Anti-Toy Detection Tests', () {
    test('Severe downward tilt angle is rejected as suspicious angle', () async {
      final detector = DefaultVehicleDetectionService();
      final toySensorReading = DeviceSensorReading(
        headingDegrees: 0.0,
        angularVelocity: 5.0,
        pitch: -60.0, // Pointed straight down at ground/feet
        roll: 0.0,
        isSteady: true,
        isMovingTooFast: false,
      );

      final result = await detector.evaluateVehiclePresence(
        targetProfile: VehicleProfile.sedan(),
        sensorReading: toySensorReading,
      );

      expect(result.isReadyToInspect, isFalse);
      expect(result.status, equals(VehicleValidationStatus.suspiciousToyOrAngle));
      expect(result.isAuthenticScale, isFalse);
    });

    test('Vertical portrait phone holding passes validation without false red errors', () async {
      final detector = DefaultVehicleDetectionService();
      final uprightReading = DeviceSensorReading(
        headingDegrees: 0.0,
        angularVelocity: 8.0,
        pitch: -15.0, // Natural human eye-level walking angle
        roll: 5.0,
        isSteady: true,
        isMovingTooFast: false,
      );

      final result = await detector.evaluateVehiclePresence(
        targetProfile: VehicleProfile.sedan(),
        sensorReading: uprightReading,
        steadyAlignmentTicks: 1,
      );

      expect(result.isReadyToInspect, isTrue);
      expect(result.status, equals(VehicleValidationStatus.verified));
      expect(result.isAuthenticScale, isTrue);
    });
  });

  group('Acceptance Scenario Tests (Left Route, Right Route & Geographic Independence)', () {
    test('Test 1: Walking FRONT -> LEFT -> REAR marks zones covered correctly', () {
      final engine = CoverageEngine();
      engine.startRecording();

      // Front
      engine.updateAngle(0.0);
      expect(engine.activeZone?.id, equals('FRONT'));
      engine.markZoneCompleted(engine.activeZone!.id);

      // Front Left
      engine.updateAngle(330.0);
      expect(engine.activeZone?.id, equals('FRONT_LEFT'));
      engine.markZoneCompleted(engine.activeZone!.id);

      // Left Side
      engine.updateAngle(270.0);
      expect(engine.activeZone?.id, equals('LEFT_SIDE'));
      engine.markZoneCompleted(engine.activeZone!.id);

      // Left Rear
      engine.updateAngle(240.0);
      expect(engine.activeZone?.id, equals('LEFT_REAR'));
      engine.markZoneCompleted(engine.activeZone!.id);

      // Rear
      engine.updateAngle(180.0);
      expect(engine.activeZone?.id, equals('REAR'));
      engine.markZoneCompleted(engine.activeZone!.id);

      expect(engine.completedZones.length, equals(5));
      expect(engine.coveragePercentage, closeTo(41.6, 0.5));
      engine.dispose();
    });

    test('Test 2: Walking FRONT -> RIGHT -> REAR marks zones covered correctly', () {
      final engine = CoverageEngine();
      engine.startRecording();

      // Front
      engine.updateAngle(0.0);
      expect(engine.activeZone?.id, equals('FRONT'));
      engine.markZoneCompleted(engine.activeZone!.id);

      // Front Right
      engine.updateAngle(30.0);
      expect(engine.activeZone?.id, equals('FRONT_RIGHT'));
      engine.markZoneCompleted(engine.activeZone!.id);

      // Right Side
      engine.updateAngle(90.0);
      expect(engine.activeZone?.id, equals('RIGHT_SIDE'));
      engine.markZoneCompleted(engine.activeZone!.id);

      // Right Rear
      engine.updateAngle(120.0);
      expect(engine.activeZone?.id, equals('RIGHT_REAR'));
      engine.markZoneCompleted(engine.activeZone!.id);

      // Rear
      engine.updateAngle(180.0);
      expect(engine.activeZone?.id, equals('REAR'));
      engine.markZoneCompleted(engine.activeZone!.id);

      expect(engine.completedZones.length, equals(5));
      expect(engine.coveragePercentage, closeTo(41.6, 0.5));
      engine.dispose();
    });

    test('Test 3: Vehicle relative tracking is independent of physical compass direction', () {
      final service = SensorOrientationService();
      service.startListening();

      // Suppose vehicle is parked facing South (180°) or West (270°)
      service.calibrateOrigin();
      expect(service.currentHeading, equals(0.0)); // Always 0° relative to vehicle Front!

      // Turning 90° right relative to vehicle
      service.setHeadingManually(90.0);
      expect(service.currentHeading, equals(90.0));

      service.dispose();
    });
  });
}
