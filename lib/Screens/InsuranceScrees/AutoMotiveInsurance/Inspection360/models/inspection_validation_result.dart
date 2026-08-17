import 'inspection_zone.dart';

class InspectionValidationResult {
  final bool isComplete;
  final double coveragePercentage;
  final List<InspectionZone> completedZones;
  final List<InspectionZone> missingZones;
  final List<String> warnings;
  final List<String> errors;

  InspectionValidationResult({
    required this.isComplete,
    required this.coveragePercentage,
    required this.completedZones,
    required this.missingZones,
    this.warnings = const [],
    this.errors = const [],
  });

  bool get canSubmit => isComplete && errors.isEmpty;
  bool get hasMissingZones => missingZones.isNotEmpty;
}
