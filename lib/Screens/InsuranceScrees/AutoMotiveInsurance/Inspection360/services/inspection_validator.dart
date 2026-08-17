import 'dart:io';
import '../models/inspection_manifest.dart';
import '../models/inspection_validation_result.dart';
import '../models/inspection_zone.dart';

class InspectionValidator {
  final double minimumRequiredCoverage;

  InspectionValidator({this.minimumRequiredCoverage = 100.0});

  Future<InspectionValidationResult> validate(InspectionManifest manifest) async {
    final List<String> errors = [];
    final List<String> warnings = [];

    // 1. Check vehicle metadata
    if (manifest.vehiclePlateNumber.trim().isEmpty) {
      errors.add('Vehicle plate number is missing.');
    }
    if (manifest.inspectionId.trim().isEmpty) {
      errors.add('Inspection ID is missing.');
    }

    // 2. Check zone coverage
    final completedZones = manifest.zones.where((z) => z.status == ZoneCaptureStatus.captured).toList();
    final missingZones = manifest.zones.where((z) => z.isRequired && z.status != ZoneCaptureStatus.captured).toList();

    double actualCoverage = manifest.zones.isEmpty
        ? 0.0
        : (completedZones.length / manifest.zones.length) * 100.0;

    if (actualCoverage < minimumRequiredCoverage || missingZones.isNotEmpty) {
      errors.add('360° coverage is incomplete ($actualCoverage% / $minimumRequiredCoverage%). ${missingZones.length} required zones are missing.');
    }

    // 3. Check segments & physical video files
    if (manifest.segments.isEmpty) {
      errors.add('No video recording segments found.');
    } else {
      for (var segment in manifest.segments) {
        final file = File(segment.filePath);
        if (!await file.exists()) {
          errors.add('Video file for zone ${segment.zoneId} not found on device: ${segment.filePath}');
        } else {
          final len = await file.length();
          if (len == 0) {
            errors.add('Video file for zone ${segment.zoneId} is empty (0 bytes).');
          }
        }

        if (segment.sha256Hash.isEmpty) {
          warnings.add('Integrity SHA-256 hash missing for segment ${segment.id}.');
        }
      }
    }

    bool isComplete = errors.isEmpty && missingZones.isEmpty && actualCoverage >= minimumRequiredCoverage;

    return InspectionValidationResult(
      isComplete: isComplete,
      coveragePercentage: actualCoverage,
      completedZones: completedZones,
      missingZones: missingZones,
      warnings: warnings,
      errors: errors,
    );
  }
}
