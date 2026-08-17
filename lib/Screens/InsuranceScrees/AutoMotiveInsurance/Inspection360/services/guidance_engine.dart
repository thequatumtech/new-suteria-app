import 'package:flutter/material.dart';
import '../models/inspection_zone.dart';
import 'sensor_orientation_service.dart';

enum GuidanceLevel {
  info,
  warning,
  success,
}

class GuidanceMessage {
  final String title;
  final String message;
  final GuidanceLevel level;
  final IconData icon;

  GuidanceMessage({
    required this.title,
    required this.message,
    this.level = GuidanceLevel.info,
    this.icon = Icons.info_outline,
  });
}

class GuidanceEngine {
  GuidanceMessage getGuidance({
    required bool isRecording,
    required DeviceSensorReading? sensorReading,
    required InspectionZone? activeZone,
    required List<InspectionZone> missingZones,
    required double coveragePercentage,
  }) {
    if (!isRecording) {
      if (coveragePercentage >= 100.0) {
        return GuidanceMessage(
          title: '360° Inspection Complete',
          message: 'All exterior angles captured. Tap Review to submit.',
          level: GuidanceLevel.success,
          icon: Icons.check_circle_outline,
        );
      }
      return GuidanceMessage(
        title: 'Ready to Inspect',
        message: 'Point camera horizontally at vehicle front and tap record.',
        level: GuidanceLevel.info,
        icon: Icons.play_arrow_rounded,
      );
    }

    // 1. Walking speed warning (YELLOW)
    if (sensorReading != null && sensorReading.isMovingTooFast) {
      return GuidanceMessage(
        title: 'Walk Slowly',
        message: 'Keep the vehicle centered and move slowly around it.',
        level: GuidanceLevel.warning,
        icon: Icons.speed_rounded,
      );
    }

    // 2. Active Zone in Progress (GREEN / Info)
    if (activeZone != null) {
      if (activeZone.status == ZoneCaptureStatus.captured) {
        return GuidanceMessage(
          title: '${activeZone.label} Captured ✓',
          message: 'Continue slowly around to the next area.',
          level: GuidanceLevel.success,
          icon: Icons.check_circle_rounded,
        );
      } else {
        return GuidanceMessage(
          title: 'Inspecting ${activeZone.label}',
          message: 'Keep vehicle framed while walking around.',
          level: GuidanceLevel.info,
          icon: Icons.videocam,
        );
      }
    }

    // 3. Sequential next area guidance
    if (missingZones.isNotEmpty) {
      final nextZone = missingZones.first;
      return GuidanceMessage(
        title: 'Next: ${nextZone.label}',
        message: 'Walk slowly toward the ${nextZone.label.toLowerCase()}.',
        level: GuidanceLevel.info,
        icon: Icons.directions_walk,
      );
    }

    // 4. Default completion
    return GuidanceMessage(
      title: 'Recording 360° Inspection',
      message: 'Walk around the vehicle until all zones turn green.',
      level: GuidanceLevel.info,
      icon: Icons.camera_alt_outlined,
    );
  }
}
