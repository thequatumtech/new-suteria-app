import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import '../models/inspection_zone.dart';
import '../models/vehicle_profile.dart';

class Vehicle360RadarWidget extends StatelessWidget {
  final List<InspectionZone> zones;
  final double currentAngle; // 0.0 - 360.0
  final InspectionZone? activeZone;
  final VehicleProfile? vehicleProfile;
  final double size;
  final bool showCarIcon;
  final bool showPointer;

  const Vehicle360RadarWidget({
    super.key,
    required this.zones,
    required this.currentAngle,
    this.activeZone,
    this.vehicleProfile,
    this.size = 220,
    this.showCarIcon = true,
    this.showPointer = true,
  });

  @override
  Widget build(BuildContext context) {
    final displayIcon = vehicleProfile?.icon ?? Icons.directions_car_rounded;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: _RadarArcPainter(
              zones: zones,
              currentAngle: currentAngle,
              activeZone: activeZone,
              showPointer: showPointer,
            ),
          ),
          if (showCarIcon)
            Container(
              width: size * 0.38,
              height: size * 0.38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primaryWhite,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      displayIcon,
                      size: size * 0.18,
                      color: darkBlue1,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${currentAngle.toStringAsFixed(0)}°',
                      style: TextStyle(
                        fontSize: size * 0.055,
                        fontWeight: FontWeight.bold,
                        color: darkBlue2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _RadarArcPainter extends CustomPainter {
  final List<InspectionZone> zones;
  final double currentAngle;
  final InspectionZone? activeZone;
  final bool showPointer;

  _RadarArcPainter({
    required this.zones,
    required this.currentAngle,
    required this.activeZone,
    required this.showPointer,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = size.width / 2 - 8;
    final innerRadius = size.width * 0.28;
    final strokeWidth = outerRadius - innerRadius;

    // Draw background track ring
    final bgPaint = Paint()
      ..color = primaryGreyShade1.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, (outerRadius + innerRadius) / 2, bgPaint);

    // Draw 12 Zone Arcs
    for (var zone in zones) {
      final isCurrentActive = activeZone?.id == zone.id;

      Color arcColor;
      switch (zone.status) {
        case ZoneCaptureStatus.captured:
          arcColor = const Color(0xff00BD79); // Green
          break;
        case ZoneCaptureStatus.recording:
          arcColor = const Color(0xffF4C211); // Yellow
          break;
        case ZoneCaptureStatus.missing:
          arcColor = const Color(0xffFF3B30); // Red
          break;
        case ZoneCaptureStatus.notCaptured:
          arcColor = isCurrentActive ? const Color(0xffFDD86A) : const Color(0xffD9D9D9);
          break;
      }

      final arcPaint = Paint()
        ..color = arcColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth - 2
        ..strokeCap = StrokeCap.round;

      // In Flutter canvas: 0 rad is at 3 o'clock (East).
      // We want 0° (Front) to be at 12 o'clock (North, -90° in canvas coords).
      double startRad = _degToRad(zone.startAngle - 90);
      double endRad = _degToRad(zone.endAngle - 90);

      double sweepRad = endRad - startRad;
      if (sweepRad <= 0) sweepRad += 2 * math.pi;

      // Add a slight margin between sectors
      const gapRad = 0.05;
      double adjustedStart = startRad + (gapRad / 2);
      double adjustedSweep = sweepRad - gapRad;

      if (adjustedSweep > 0) {
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: (outerRadius + innerRadius) / 2),
          adjustedStart,
          adjustedSweep,
          false,
          arcPaint,
        );
      }
    }

    // Draw Heading Indicator Pointer
    if (showPointer) {
      final pointerAngleRad = _degToRad(currentAngle - 90);
      final pointerOuter = Offset(
        center.dx + (outerRadius + 4) * math.cos(pointerAngleRad),
        center.dy + (outerRadius + 4) * math.sin(pointerAngleRad),
      );
      final pointerInner = Offset(
        center.dx + (innerRadius - 4) * math.cos(pointerAngleRad),
        center.dy + (innerRadius - 4) * math.sin(pointerAngleRad),
      );

      final pointerPaint = Paint()
        ..color = darkBlue2
        ..strokeWidth = 3.5
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(pointerInner, pointerOuter, pointerPaint);

      // Draw active tip dot
      final dotPaint = Paint()
        ..color = buttonColorApp
        ..style = PaintingStyle.fill;
      canvas.drawCircle(pointerOuter, 4.5, dotPaint);
    }
  }

  double _degToRad(double deg) => (deg * math.pi) / 180.0;

  @override
  bool shouldRepaint(covariant _RadarArcPainter oldDelegate) {
    return oldDelegate.currentAngle != currentAngle ||
        oldDelegate.zones != zones ||
        oldDelegate.activeZone != activeZone;
  }
}
