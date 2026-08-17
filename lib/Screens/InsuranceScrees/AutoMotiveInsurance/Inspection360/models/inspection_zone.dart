import 'package:flutter/material.dart';

enum ZoneCaptureStatus {
  notCaptured,
  recording,
  captured,
  missing,
}

class InspectionZone {
  final String id;
  final String label;
  final String shortLabel;
  final double centerAngle; // In degrees, 0° = Front
  final double startAngle;  // Start angle in 0-360 degrees
  final double endAngle;    // End angle in 0-360 degrees
  final bool isRequired;
  final double minDwellSeconds; // Minimum time needed in this zone
  ZoneCaptureStatus status;
  double recordedSeconds;

  InspectionZone({
    required this.id,
    required this.label,
    required this.shortLabel,
    required this.centerAngle,
    required this.startAngle,
    required this.endAngle,
    this.isRequired = true,
    this.minDwellSeconds = 1.5,
    this.status = ZoneCaptureStatus.notCaptured,
    this.recordedSeconds = 0.0,
  });

  bool containsAngle(double angle, {double tolerance = 5.0}) {
    double normAngle = (angle % 360 + 360) % 360;
    double effectiveStart = (startAngle - tolerance + 360) % 360;
    double effectiveEnd = (endAngle + tolerance) % 360;

    if (effectiveStart > effectiveEnd) {
      // Crosses 360°/0° boundary (e.g. 345° to 15°)
      return normAngle >= effectiveStart || normAngle <= effectiveEnd;
    } else {
      return normAngle >= effectiveStart && normAngle <= effectiveEnd;
    }
  }

  double angularDistanceTo(double angle) {
    double normAngle = (angle % 360 + 360) % 360;
    double diff = (normAngle - centerAngle).abs() % 360;
    return diff > 180 ? 360 - diff : diff;
  }

  InspectionZone copyWith({
    String? id,
    String? label,
    String? shortLabel,
    double? centerAngle,
    double? startAngle,
    double? endAngle,
    bool? isRequired,
    double? minDwellSeconds,
    ZoneCaptureStatus? status,
    double? recordedSeconds,
  }) {
    return InspectionZone(
      id: id ?? this.id,
      label: label ?? this.label,
      shortLabel: shortLabel ?? this.shortLabel,
      centerAngle: centerAngle ?? this.centerAngle,
      startAngle: startAngle ?? this.startAngle,
      endAngle: endAngle ?? this.endAngle,
      isRequired: isRequired ?? this.isRequired,
      minDwellSeconds: minDwellSeconds ?? this.minDwellSeconds,
      status: status ?? this.status,
      recordedSeconds: recordedSeconds ?? this.recordedSeconds,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'label': label,
        'shortLabel': shortLabel,
        'centerAngle': centerAngle,
        'startAngle': startAngle,
        'endAngle': endAngle,
        'isRequired': isRequired,
        'status': status.name,
        'recordedSeconds': recordedSeconds,
      };

  factory InspectionZone.fromJson(Map<String, dynamic> json) {
    return InspectionZone(
      id: json['id'] ?? '',
      label: json['label'] ?? '',
      shortLabel: json['shortLabel'] ?? '',
      centerAngle: (json['centerAngle'] as num?)?.toDouble() ?? 0.0,
      startAngle: (json['startAngle'] as num?)?.toDouble() ?? 0.0,
      endAngle: (json['endAngle'] as num?)?.toDouble() ?? 0.0,
      isRequired: json['isRequired'] ?? true,
      status: ZoneCaptureStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => ZoneCaptureStatus.notCaptured,
      ),
      recordedSeconds: (json['recordedSeconds'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class VehicleInspectionZoneConfig {
  static List<InspectionZone> getDefault12Zones() {
    return [
      InspectionZone(
        id: 'FRONT',
        label: 'Front',
        shortLabel: 'Front',
        centerAngle: 0.0,
        startAngle: 345.0,
        endAngle: 15.0,
      ),
      InspectionZone(
        id: 'FRONT_RIGHT',
        label: 'Front Right',
        shortLabel: 'F-Right',
        centerAngle: 30.0,
        startAngle: 15.0,
        endAngle: 45.0,
      ),
      InspectionZone(
        id: 'RIGHT_FRONT',
        label: 'Right Front Side',
        shortLabel: 'R-Front',
        centerAngle: 60.0,
        startAngle: 45.0,
        endAngle: 75.0,
      ),
      InspectionZone(
        id: 'RIGHT_SIDE',
        label: 'Right Side',
        shortLabel: 'Right',
        centerAngle: 90.0,
        startAngle: 75.0,
        endAngle: 105.0,
      ),
      InspectionZone(
        id: 'RIGHT_REAR',
        label: 'Right Rear Side',
        shortLabel: 'R-Rear',
        centerAngle: 120.0,
        startAngle: 105.0,
        endAngle: 135.0,
      ),
      InspectionZone(
        id: 'REAR_RIGHT',
        label: 'Rear Right',
        shortLabel: 'Rear-R',
        centerAngle: 150.0,
        startAngle: 135.0,
        endAngle: 165.0,
      ),
      InspectionZone(
        id: 'REAR',
        label: 'Rear',
        shortLabel: 'Rear',
        centerAngle: 180.0,
        startAngle: 165.0,
        endAngle: 195.0,
      ),
      InspectionZone(
        id: 'REAR_LEFT',
        label: 'Rear Left',
        shortLabel: 'Rear-L',
        centerAngle: 210.0,
        startAngle: 195.0,
        endAngle: 225.0,
      ),
      InspectionZone(
        id: 'LEFT_REAR',
        label: 'Left Rear Side',
        shortLabel: 'L-Rear',
        centerAngle: 240.0,
        startAngle: 225.0,
        endAngle: 255.0,
      ),
      InspectionZone(
        id: 'LEFT_SIDE',
        label: 'Left Side',
        shortLabel: 'Left',
        centerAngle: 270.0,
        startAngle: 255.0,
        endAngle: 285.0,
      ),
      InspectionZone(
        id: 'LEFT_FRONT',
        label: 'Left Front Side',
        shortLabel: 'L-Front',
        centerAngle: 300.0,
        startAngle: 285.0,
        endAngle: 315.0,
      ),
      InspectionZone(
        id: 'FRONT_LEFT',
        label: 'Front Left',
        shortLabel: 'F-Left',
        centerAngle: 330.0,
        startAngle: 315.0,
        endAngle: 345.0,
      ),
    ];
  }
}
