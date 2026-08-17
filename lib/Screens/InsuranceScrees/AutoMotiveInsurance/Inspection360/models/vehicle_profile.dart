import 'package:flutter/material.dart';
import 'inspection_zone.dart';

enum VehicleBodyType {
  sedan,
  suv,
  motorcycle,
  truck,
  commercial,
}

class VehicleProfile {
  final VehicleBodyType bodyType;
  final String displayName;
  final String? originalTypeName;
  final String? brandName;
  final double recommendedDistanceMeters;
  final double minPitchAngle;
  final double maxPitchAngle;
  final IconData icon;
  final List<InspectionZone> defaultZones;

  const VehicleProfile({
    required this.bodyType,
    required this.displayName,
    this.originalTypeName,
    this.brandName,
    required this.recommendedDistanceMeters,
    required this.minPitchAngle,
    required this.maxPitchAngle,
    required this.icon,
    required this.defaultZones,
  });

  String get effectiveDisplayName {
    if (brandName != null && brandName!.trim().isNotEmpty) {
      if (originalTypeName != null && originalTypeName!.trim().isNotEmpty) {
        return '$brandName $originalTypeName'.trim();
      }
      return '$brandName $displayName'.trim();
    }
    if (originalTypeName != null && originalTypeName!.trim().isNotEmpty) {
      return originalTypeName!;
    }
    return displayName;
  }

  /// Factory to parse from API vehicle type string and brand
  factory VehicleProfile.fromTypeString(
    String? typeName, {
    String? categoryName,
    String? brandName,
  }) {
    final cleanType = typeName?.trim();
    final lowerType = (cleanType ?? '').toLowerCase();
    final lowerCat = (categoryName ?? '').toLowerCase();
    final combined = '$lowerType $lowerCat';

    if (combined.contains('motor') ||
        combined.contains('bike') ||
        combined.contains('scooter') ||
        combined.contains('two wheeler') ||
        combined.contains('2 wheeler') ||
        combined.contains('moped') ||
        combined.contains('cycle')) {
      return VehicleProfile(
        bodyType: VehicleBodyType.motorcycle,
        displayName: 'Motorcycle / Scooter',
        originalTypeName: cleanType,
        brandName: brandName,
        recommendedDistanceMeters: 1.8,
        minPitchAngle: -30.0,
        maxPitchAngle: 30.0,
        icon: Icons.two_wheeler_rounded,
        defaultZones: _motorcycle8Zones(),
      );
    }

    if (combined.contains('truck') ||
        combined.contains('pickup') ||
        combined.contains('pick up') ||
        combined.contains('bus') ||
        combined.contains('van') ||
        combined.contains('commercial') ||
        combined.contains('heavy') ||
        combined.contains('lorry') ||
        combined.contains('trailer') ||
        combined.contains('cargo') ||
        combined.contains('transport')) {
      return VehicleProfile(
        bodyType: VehicleBodyType.truck,
        displayName: 'Pickup / Commercial',
        originalTypeName: cleanType,
        brandName: brandName,
        recommendedDistanceMeters: 3.2,
        minPitchAngle: -30.0,
        maxPitchAngle: 30.0,
        icon: Icons.local_shipping_rounded,
        defaultZones: VehicleInspectionZoneConfig.getDefault12Zones(),
      );
    }

    if (combined.contains('suv') ||
        combined.contains('4x4') ||
        combined.contains('4wd') ||
        combined.contains('crossover') ||
        combined.contains('mpv') ||
        combined.contains('muv') ||
        combined.contains('jeep') ||
        combined.contains('offroad') ||
        combined.contains('off-road')) {
      return VehicleProfile(
        bodyType: VehicleBodyType.suv,
        displayName: 'SUV / 4x4',
        originalTypeName: cleanType,
        brandName: brandName,
        recommendedDistanceMeters: 2.8,
        minPitchAngle: -25.0,
        maxPitchAngle: 25.0,
        icon: Icons.airport_shuttle_rounded,
        defaultZones: VehicleInspectionZoneConfig.getDefault12Zones(),
      );
    }

    // Default to Passenger Sedan / Car
    return VehicleProfile(
      bodyType: VehicleBodyType.sedan,
      displayName: 'Sedan / Hatchback',
      originalTypeName: cleanType,
      brandName: brandName,
      recommendedDistanceMeters: 2.5,
      minPitchAngle: -25.0,
      maxPitchAngle: 25.0,
      icon: Icons.directions_car_rounded,
      defaultZones: VehicleInspectionZoneConfig.getDefault12Zones(),
    );
  }

  factory VehicleProfile.sedan({String? originalTypeName, String? brandName}) {
    return VehicleProfile(
      bodyType: VehicleBodyType.sedan,
      displayName: 'Sedan / Hatchback',
      originalTypeName: originalTypeName,
      brandName: brandName,
      recommendedDistanceMeters: 2.5,
      minPitchAngle: -25.0,
      maxPitchAngle: 25.0,
      icon: Icons.directions_car_rounded,
      defaultZones: VehicleInspectionZoneConfig.getDefault12Zones(),
    );
  }

  factory VehicleProfile.suv({String? originalTypeName, String? brandName}) {
    return VehicleProfile(
      bodyType: VehicleBodyType.suv,
      displayName: 'SUV / 4x4',
      originalTypeName: originalTypeName,
      brandName: brandName,
      recommendedDistanceMeters: 2.8,
      minPitchAngle: -25.0,
      maxPitchAngle: 25.0,
      icon: Icons.airport_shuttle_rounded,
      defaultZones: VehicleInspectionZoneConfig.getDefault12Zones(),
    );
  }

  factory VehicleProfile.truck({String? originalTypeName, String? brandName}) {
    return VehicleProfile(
      bodyType: VehicleBodyType.truck,
      displayName: 'Pickup / Commercial',
      originalTypeName: originalTypeName,
      brandName: brandName,
      recommendedDistanceMeters: 3.2,
      minPitchAngle: -30.0,
      maxPitchAngle: 30.0,
      icon: Icons.local_shipping_rounded,
      defaultZones: VehicleInspectionZoneConfig.getDefault12Zones(),
    );
  }

  factory VehicleProfile.motorcycle({String? originalTypeName, String? brandName}) {
    return VehicleProfile(
      bodyType: VehicleBodyType.motorcycle,
      displayName: 'Motorcycle / Scooter',
      originalTypeName: originalTypeName,
      brandName: brandName,
      recommendedDistanceMeters: 1.8,
      minPitchAngle: -30.0,
      maxPitchAngle: 30.0,
      icon: Icons.two_wheeler_rounded,
      defaultZones: _motorcycle8Zones(),
    );
  }

  static List<InspectionZone> _motorcycle8Zones() {
    return [
      InspectionZone(
        id: 'FRONT',
        label: 'Front Headlight & Fork',
        shortLabel: 'Front',
        centerAngle: 0.0,
        startAngle: 337.5,
        endAngle: 22.5,
        minDwellSeconds: 1.5,
      ),
      InspectionZone(
        id: 'FRONT_RIGHT',
        label: 'Front Right & Handlebar',
        shortLabel: 'F-Right',
        centerAngle: 45.0,
        startAngle: 22.5,
        endAngle: 67.5,
        minDwellSeconds: 1.5,
      ),
      InspectionZone(
        id: 'RIGHT_SIDE',
        label: 'Right Engine & Exhaust',
        shortLabel: 'Right',
        centerAngle: 90.0,
        startAngle: 67.5,
        endAngle: 112.5,
        minDwellSeconds: 1.5,
      ),
      InspectionZone(
        id: 'REAR_RIGHT',
        label: 'Rear Right Wheel',
        shortLabel: 'R-Right',
        centerAngle: 135.0,
        startAngle: 112.5,
        endAngle: 157.5,
        minDwellSeconds: 1.5,
      ),
      InspectionZone(
        id: 'REAR',
        label: 'Rear Tail & Plate',
        shortLabel: 'Rear',
        centerAngle: 180.0,
        startAngle: 157.5,
        endAngle: 202.5,
        minDwellSeconds: 1.5,
      ),
      InspectionZone(
        id: 'REAR_LEFT',
        label: 'Rear Left Wheel & Chain',
        shortLabel: 'R-Left',
        centerAngle: 225.0,
        startAngle: 202.5,
        endAngle: 247.5,
        minDwellSeconds: 1.5,
      ),
      InspectionZone(
        id: 'LEFT_SIDE',
        label: 'Left Engine & Stand',
        shortLabel: 'Left',
        centerAngle: 270.0,
        startAngle: 247.5,
        endAngle: 292.5,
        minDwellSeconds: 1.5,
      ),
      InspectionZone(
        id: 'FRONT_LEFT',
        label: 'Front Left & Controls',
        shortLabel: 'F-Left',
        centerAngle: 315.0,
        startAngle: 292.5,
        endAngle: 337.5,
        minDwellSeconds: 1.5,
      ),
    ];
  }
}
