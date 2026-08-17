import 'dart:async';
import '../models/inspection_zone.dart';

enum InspectionWalkDirection {
  undetermined,
  leftRoute,  // Front -> Left -> Rear -> Right -> Front
  rightRoute, // Front -> Right -> Rear -> Left -> Front
}

class CoverageState {
  final double currentAngle;
  final InspectionZone? activeZone;
  final List<InspectionZone> zones;
  final double coveragePercentage;
  final List<InspectionZone> completedZones;
  final List<InspectionZone> missingZones;
  final bool isFullyCovered;
  final String activeAreaName;
  final String nextInstruction;

  CoverageState({
    required this.currentAngle,
    required this.activeZone,
    required this.zones,
    required this.coveragePercentage,
    required this.completedZones,
    required this.missingZones,
    required this.isFullyCovered,
    required this.activeAreaName,
    required this.nextInstruction,
  });
}

class CoverageEngine {
  final List<InspectionZone> _zones;
  double _currentAngle = 0.0;
  bool _isRecording = false;
  InspectionWalkDirection _walkDirection = InspectionWalkDirection.undetermined;

  Timer? _dwellTimer;
  DateTime? _lastTickTime;

  final _stateController = StreamController<CoverageState>.broadcast();
  Stream<CoverageState> get stateStream => _stateController.stream;

  CoverageEngine({List<InspectionZone>? zones})
      : _zones = zones ?? VehicleInspectionZoneConfig.getDefault12Zones();

  List<InspectionZone> get zones => List.unmodifiable(_zones);
  double get currentAngle => _currentAngle;
  bool get isRecording => _isRecording;
  InspectionWalkDirection get walkDirection => _walkDirection;

  /// Vehicle-relative zone selection (closest angular match)
  InspectionZone? get activeZone {
    if (_zones.isEmpty) return null;

    // 1. Direct match with standard tolerance
    for (var zone in _zones) {
      if (zone.containsAngle(_currentAngle, tolerance: 5.0)) {
        return zone;
      }
    }

    // 2. Closest zone by angular distance
    InspectionZone closestZone = _zones.first;
    double minDistance = closestZone.angularDistanceTo(_currentAngle);

    for (int i = 1; i < _zones.length; i++) {
      double dist = _zones[i].angularDistanceTo(_currentAngle);
      if (dist < minDistance) {
        minDistance = dist;
        closestZone = _zones[i];
      }
    }

    return closestZone;
  }

  double get coveragePercentage {
    if (_zones.isEmpty) return 0.0;
    int completedCount = _zones.where((z) => z.status == ZoneCaptureStatus.captured).length;
    return (completedCount / _zones.length) * 100.0;
  }

  List<InspectionZone> get completedZones =>
      _zones.where((z) => z.status == ZoneCaptureStatus.captured).toList();

  List<InspectionZone> get missingZones =>
      _zones.where((z) => z.status != ZoneCaptureStatus.captured).toList();

  bool get isFullyCovered =>
      _zones.every((z) => !z.isRequired || z.status == ZoneCaptureStatus.captured);

  void startRecording() {
    _isRecording = true;
    _lastTickTime = DateTime.now();
    _startDwellTracking();
    _notifyState();
  }

  void pauseRecording() {
    _isRecording = false;
    _dwellTimer?.cancel();
    _notifyState();
  }

  void resumeRecording() {
    if (!_isRecording) {
      _isRecording = true;
      _lastTickTime = DateTime.now();
      _startDwellTracking();
      _notifyState();
    }
  }

  void stopRecording() {
    _isRecording = false;
    _dwellTimer?.cancel();
    _notifyState();
  }

  void updateAngle(double angleDeg) {
    _currentAngle = (angleDeg % 360.0 + 360.0) % 360.0;

    // Detect walking direction if still undetermined
    if (_isRecording && _walkDirection == InspectionWalkDirection.undetermined) {
      if (_currentAngle > 15.0 && _currentAngle < 180.0) {
        _walkDirection = InspectionWalkDirection.rightRoute;
      } else if (_currentAngle > 180.0 && _currentAngle < 345.0) {
        _walkDirection = InspectionWalkDirection.leftRoute;
      }
    }

    _notifyState();
  }

  void _startDwellTracking() {
    _dwellTimer?.cancel();
    _dwellTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (!_isRecording) return;

      final now = DateTime.now();
      final dt = _lastTickTime != null
          ? (now.difference(_lastTickTime!).inMilliseconds / 1000.0)
          : 0.1;
      _lastTickTime = now;

      final current = activeZone;
      if (current != null) {
        if (current.status != ZoneCaptureStatus.captured) {
          current.status = ZoneCaptureStatus.recording;
          current.recordedSeconds += dt;

          if (current.recordedSeconds >= current.minDwellSeconds) {
            current.status = ZoneCaptureStatus.captured;
          }
        }
      }

      // Keep uncaptured non-active zones marked properly without erasing captured ones
      for (var z in _zones) {
        if (z.status != ZoneCaptureStatus.captured && z != current) {
          z.status = ZoneCaptureStatus.notCaptured;
        }
      }

      _notifyState();
    });
  }

  void markZoneCompleted(String zoneId) {
    final zoneIndex = _zones.indexWhere((z) => z.id == zoneId);
    if (zoneIndex != -1) {
      _zones[zoneIndex].status = ZoneCaptureStatus.captured;
      _zones[zoneIndex].recordedSeconds = _zones[zoneIndex].minDwellSeconds;
      _notifyState();
    }
  }

  void markZoneMissing(String zoneId) {
    final zoneIndex = _zones.indexWhere((z) => z.id == zoneId);
    if (zoneIndex != -1) {
      _zones[zoneIndex].status = ZoneCaptureStatus.missing;
      _zones[zoneIndex].recordedSeconds = 0.0;
      _notifyState();
    }
  }

  void loadZones(List<InspectionZone> loadedZones) {
    _zones.clear();
    _zones.addAll(loadedZones);
    _notifyState();
  }

  void reset() {
    _dwellTimer?.cancel();
    _isRecording = false;
    _currentAngle = 0.0;
    _walkDirection = InspectionWalkDirection.undetermined;
    for (var z in _zones) {
      z.status = ZoneCaptureStatus.notCaptured;
      z.recordedSeconds = 0.0;
    }
    _notifyState();
  }

  String get activeAreaName {
    final current = activeZone;
    if (current != null) {
      return current.label.toUpperCase();
    }
    return 'VEHICLE FRONT';
  }

  String get nextInstruction {
    if (coveragePercentage >= 100.0) {
      return '360° Inspection complete. Tap Finish to review.';
    }
    if (activeZone != null && activeZone!.status == ZoneCaptureStatus.captured) {
      return 'Area captured. Continue slowly around the vehicle.';
    }
    return 'Hold vehicle in frame and move slowly.';
  }

  CoverageState getCurrentState() {
    return CoverageState(
      currentAngle: _currentAngle,
      activeZone: activeZone,
      zones: List.unmodifiable(_zones),
      coveragePercentage: coveragePercentage,
      completedZones: completedZones,
      missingZones: missingZones,
      isFullyCovered: isFullyCovered,
      activeAreaName: activeAreaName,
      nextInstruction: nextInstruction,
    );
  }

  void _notifyState() {
    if (!_stateController.isClosed) {
      _stateController.add(getCurrentState());
    }
  }

  void dispose() {
    _dwellTimer?.cancel();
    _stateController.close();
  }
}
