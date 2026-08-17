import 'inspection_segment.dart';
import 'inspection_zone.dart';

class InspectionManifest {
  final String inspectionId;
  final String vehiclePlateNumber;
  final String vehicleChassisNumber;
  final DateTime createdAt;
  DateTime? completedAt;
  double coveragePercentage;
  final List<InspectionSegment> segments;
  final List<InspectionZone> zones;
  final String? deviceModel;
  final String? appVersion;
  final double? latitude;
  final double? longitude;
  bool isCompleted;

  InspectionManifest({
    required this.inspectionId,
    required this.vehiclePlateNumber,
    required this.vehicleChassisNumber,
    required this.createdAt,
    this.completedAt,
    this.coveragePercentage = 0.0,
    List<InspectionSegment>? segments,
    List<InspectionZone>? zones,
    this.deviceModel,
    this.appVersion,
    this.latitude,
    this.longitude,
    this.isCompleted = false,
  })  : segments = segments ?? [],
        zones = zones ?? VehicleInspectionZoneConfig.getDefault12Zones();

  Map<String, dynamic> toJson() => {
        'inspectionId': inspectionId,
        'vehiclePlateNumber': vehiclePlateNumber,
        'vehicleChassisNumber': vehicleChassisNumber,
        'createdAt': createdAt.toIso8601String(),
        'completedAt': completedAt?.toIso8601String(),
        'coveragePercentage': coveragePercentage,
        'segments': segments.map((s) => s.toJson()).toList(),
        'zones': zones.map((z) => z.toJson()).toList(),
        'deviceModel': deviceModel,
        'appVersion': appVersion,
        'latitude': latitude,
        'longitude': longitude,
        'isCompleted': isCompleted,
      };

  factory InspectionManifest.fromJson(Map<String, dynamic> json) {
    return InspectionManifest(
      inspectionId: json['inspectionId'] ?? '',
      vehiclePlateNumber: json['vehiclePlateNumber'] ?? '',
      vehicleChassisNumber: json['vehicleChassisNumber'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      completedAt: json['completedAt'] != null ? DateTime.tryParse(json['completedAt']) : null,
      coveragePercentage: (json['coveragePercentage'] as num?)?.toDouble() ?? 0.0,
      segments: (json['segments'] as List<dynamic>?)
              ?.map((s) => InspectionSegment.fromJson(s as Map<String, dynamic>))
              .toList() ??
          [],
      zones: (json['zones'] as List<dynamic>?)
              ?.map((z) => InspectionZone.fromJson(z as Map<String, dynamic>))
              .toList() ??
          VehicleInspectionZoneConfig.getDefault12Zones(),
      deviceModel: json['deviceModel'],
      appVersion: json['appVersion'],
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      isCompleted: json['isCompleted'] ?? false,
    );
  }
}
