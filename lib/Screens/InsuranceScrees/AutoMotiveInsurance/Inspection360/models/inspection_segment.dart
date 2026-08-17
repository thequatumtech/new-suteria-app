class InspectionSegment {
  final String id;
  final String inspectionId;
  final String zoneId;
  final double startAngle;
  final double endAngle;
  final DateTime startTime;
  final DateTime endTime;
  final double durationSeconds;
  final String filePath;
  final String sha256Hash;
  final int fileSizeBytes;
  final String? thumbnailPath;

  InspectionSegment({
    required this.id,
    required this.inspectionId,
    required this.zoneId,
    required this.startAngle,
    required this.endAngle,
    required this.startTime,
    required this.endTime,
    required this.durationSeconds,
    required this.filePath,
    required this.sha256Hash,
    required this.fileSizeBytes,
    this.thumbnailPath,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'inspectionId': inspectionId,
        'zoneId': zoneId,
        'startAngle': startAngle,
        'endAngle': endAngle,
        'startTime': startTime.toIso8601String(),
        'endTime': endTime.toIso8601String(),
        'durationSeconds': durationSeconds,
        'filePath': filePath,
        'sha256Hash': sha256Hash,
        'fileSizeBytes': fileSizeBytes,
        'thumbnailPath': thumbnailPath,
      };

  factory InspectionSegment.fromJson(Map<String, dynamic> json) {
    return InspectionSegment(
      id: json['id'] ?? '',
      inspectionId: json['inspectionId'] ?? '',
      zoneId: json['zoneId'] ?? '',
      startAngle: (json['startAngle'] as num?)?.toDouble() ?? 0.0,
      endAngle: (json['endAngle'] as num?)?.toDouble() ?? 0.0,
      startTime: DateTime.tryParse(json['startTime'] ?? '') ?? DateTime.now(),
      endTime: DateTime.tryParse(json['endTime'] ?? '') ?? DateTime.now(),
      durationSeconds: (json['durationSeconds'] as num?)?.toDouble() ?? 0.0,
      filePath: json['filePath'] ?? '',
      sha256Hash: json['sha256Hash'] ?? '',
      fileSizeBytes: (json['fileSizeBytes'] as num?)?.toInt() ?? 0,
      thumbnailPath: json['thumbnailPath'],
    );
  }
}
