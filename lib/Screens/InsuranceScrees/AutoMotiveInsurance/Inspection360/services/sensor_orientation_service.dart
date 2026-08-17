import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:sensors_plus/sensors_plus.dart';

class DeviceSensorReading {
  final double headingDegrees; // Vehicle-relative angle: 0.0 = Front
  final double angularVelocity; // degrees/sec
  final double pitch; // vertical tilt up/down
  final double roll; // sideways tilt left/right
  final bool isSteady;
  final bool isMovingTooFast;

  DeviceSensorReading({
    required this.headingDegrees,
    required this.angularVelocity,
    required this.pitch,
    required this.roll,
    required this.isSteady,
    required this.isMovingTooFast,
  });
}

class SensorOrientationService {
  StreamSubscription? _gyroSub;
  StreamSubscription? _magSub;
  StreamSubscription? _accelSub;

  final _readingController = StreamController<DeviceSensorReading>.broadcast();
  Stream<DeviceSensorReading> get sensorStream => _readingController.stream;

  double _relativeHeading = 0.0;
  double _filteredHeading = 0.0;
  double _angularVelocity = 0.0;
  double _pitch = 0.0;
  double _roll = 0.0;

  double? _initialReferenceHeading;
  DateTime _lastTimestamp = DateTime.now();

  // Smoothing constant for low-pass filter (0.0 to 1.0)
  final double _filterAlpha = 0.35;
  final double _maxSafeAngularVelocity = 90.0; // degrees per second

  bool _isAvailable = false;
  bool get isAvailable => _isAvailable;
  double get currentHeading => _filteredHeading;
  double get angularVelocity => _angularVelocity;

  void startListening() {
    _lastTimestamp = DateTime.now();

    // 1. Gyroscope stream for relative yaw rotation rate
    try {
      _gyroSub = gyroscopeEventStream().listen(
        (GyroscopeEvent event) {
          _isAvailable = true;
          final now = DateTime.now();
          final dt = now.difference(_lastTimestamp).inMicroseconds / 1000000.0;
          _lastTimestamp = now;

          if (dt > 0 && dt < 1.0) {
            // Gyroscope z-axis: rotation around screen normal / vertical axis
            // Convert to degrees per second
            double degPerSec = event.z * (180.0 / math.pi);
            _angularVelocity = degPerSec.abs();

            // Integrate delta rotation (vehicle-relative)
            double deltaAngle = degPerSec * dt;
            _relativeHeading = (_relativeHeading + deltaAngle) % 360.0;
            if (_relativeHeading < 0) _relativeHeading += 360.0;

            _applyFilterAndEmit();
          }
        },
        onError: (err) {
          debugPrint('Gyroscope stream error: $err');
          _isAvailable = false;
        },
        cancelOnError: false,
      );
    } catch (e) {
      debugPrint('Gyroscope stream exception: $e');
    }

    // 2. Magnetometer used solely to initialize relative heading reference (0° = user start position)
    try {
      _magSub = magnetometerEventStream().listen(
        (MagnetometerEvent event) {
          double rawHeadingRad = math.atan2(event.y, event.x);
          double rawHeadingDeg = (rawHeadingRad * (180.0 / math.pi) + 360.0) % 360.0;

          if (_initialReferenceHeading == null) {
            _initialReferenceHeading = rawHeadingDeg;
            _relativeHeading = 0.0;
            _filteredHeading = 0.0;
          }
        },
        onError: (err) {},
        cancelOnError: false,
      );
    } catch (e) {}

    // 3. Accelerometer for vertical phone pose validation (pitch & roll)
    try {
      _accelSub = accelerometerEventStream().listen(
        (AccelerometerEvent event) {
          _pitch = math.atan2(event.y, math.sqrt(event.x * event.x + event.z * event.z)) * (180.0 / math.pi);
          _roll = math.atan2(-event.x, event.z) * (180.0 / math.pi);
        },
        onError: (err) {},
        cancelOnError: false,
      );
    } catch (e) {}
  }

  /// Calibrate current device orientation as Vehicle Front (0° relative heading)
  void calibrateOrigin() {
    _relativeHeading = 0.0;
    _filteredHeading = 0.0;
    _initialReferenceHeading = null;
  }

  void setHeadingManually(double headingDeg) {
    _relativeHeading = (headingDeg % 360.0 + 360.0) % 360.0;
    _filteredHeading = _relativeHeading;
    _applyFilterAndEmit();
  }

  void _applyFilterAndEmit() {
    // Smooth relative angle with circular wraparound handling (359° <-> 0°)
    _filteredHeading = _smoothAngleInterpolate(_filteredHeading, _relativeHeading, _filterAlpha);

    bool isMovingTooFast = _angularVelocity > _maxSafeAngularVelocity;
    // Normal phone holding in vertical portrait mode has pitch between -35° and +35°
    bool isSteady = _angularVelocity < 30.0 && _pitch.abs() < 50.0 && _roll.abs() < 50.0;

    if (!_readingController.isClosed) {
      _readingController.add(
        DeviceSensorReading(
          headingDegrees: _filteredHeading,
          angularVelocity: _angularVelocity,
          pitch: _pitch,
          roll: _roll,
          isSteady: isSteady,
          isMovingTooFast: isMovingTooFast,
        ),
      );
    }
  }

  /// Circular interpolation between two angles in degrees (0..360)
  double _smoothAngleInterpolate(double from, double to, double alpha) {
    double diff = (to - from) % 360.0;
    if (diff < -180.0) diff += 360.0;
    if (diff > 180.0) diff -= 360.0;

    double result = (from + diff * alpha) % 360.0;
    if (result < 0) result += 360.0;
    return result;
  }

  void dispose() {
    _gyroSub?.cancel();
    _magSub?.cancel();
    _accelSub?.cancel();
    _readingController.close();
  }
}
