import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:soperia_user/Screens/InsuranceScrees/discount_screen.dart';
import 'package:soperia_user/Screens/InsuranceScrees/insurance_pdf_controller.dart';
import 'package:soperia_user/app_utils/Common%20Widgets/draft_pdf_controller.dart';
import 'package:soperia_user/app_utils/api_set_up/header_file.dart';
import 'package:soperia_user/app_utils/app_button.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import 'package:soperia_user/language/language_constants.dart';

class StrokeLine {
  final List<Offset> points;
  final Color color;
  final double strokeWidth;

  StrokeLine({
    required this.points,
    required this.color,
    this.strokeWidth = 3.0,
  });
}

enum SignatureValidationStatus {
  empty,
  tooShort,
  straightLine,
  geometricShape,
  scribble,
  nameMismatch,
  valid,
}

class SignatureValidationResult {
  final bool isValid;
  final SignatureValidationStatus status;
  final String message;

  SignatureValidationResult({
    required this.isValid,
    required this.status,
    required this.message,
  });
}

class SignatureValidator {
  /// Analyzes the signature strokes to:
  /// 1. Reject straight lines (horizontal, vertical, diagonal)
  /// 2. Reject geometric shapes (circles, ovals, boxes, triangles, closed loops)
  /// 3. Verify genuine handwriting & letter strokes (inflections, cusps, cursive loops)
  /// 4. Match signature characteristics with the user's name/initials for security
  static SignatureValidationResult validate(
    List<StrokeLine> strokes,
    List<Offset> activeStroke, {
    String userName = '',
  }) {
    final List<List<Offset>> allStrokes = [
      ...strokes.map((s) => s.points),
      if (activeStroke.isNotEmpty) activeStroke,
    ].where((s) => s.isNotEmpty).toList();

    // 1. Empty Check
    if (allStrokes.isEmpty) {
      return SignatureValidationResult(
        isValid: false,
        status: SignatureValidationStatus.empty,
        message: pleaseProvideSignature,
      );
    }

    final List<Offset> allPoints = allStrokes.expand((s) => s).toList();

    // 2. Minimum Point Count Check (avoids single dots/taps)
    if (allPoints.length < 15) {
      return SignatureValidationResult(
        isValid: false,
        status: SignatureValidationStatus.tooShort,
        message: invalidSignatureTooShort,
      );
    }

    // 3. Total Path Length (Arc Length)
    double totalPathLength = 0.0;
    for (final stroke in allStrokes) {
      for (int i = 0; i < stroke.length - 1; i++) {
        totalPathLength += (stroke[i + 1] - stroke[i]).distance;
      }
    }

    if (totalPathLength < 80.0) {
      return SignatureValidationResult(
        isValid: false,
        status: SignatureValidationStatus.tooShort,
        message: invalidSignatureTooShort,
      );
    }

    // 4. Bounding Box & 2D Dimensions
    double minX = double.infinity, maxX = double.negativeInfinity;
    double minY = double.infinity, maxY = double.negativeInfinity;
    for (final pt in allPoints) {
      if (pt.dx < minX) minX = pt.dx;
      if (pt.dx > maxX) maxX = pt.dx;
      if (pt.dy < minY) minY = pt.dy;
      if (pt.dy > maxY) maxY = pt.dy;
    }

    final width = maxX - minX;
    final height = maxY - minY;
    final area = width * height;
    final diagonal = math.sqrt(width * width + height * height);

    // Flat 1D line or tiny surface area
    if (width < 35.0 || height < 14.0 || area < 650.0) {
      return SignatureValidationResult(
        isValid: false,
        status: SignatureValidationStatus.straightLine,
        message: invalidSignatureStraightLine,
      );
    }

    // 5. Check for Scribbles, Tangled Loops, and Chaotic Drawings
    bool isScribble = _checkIsScribbleOrTangle(allStrokes, diagonal, width, height, totalPathLength);
    if (isScribble) {
      return SignatureValidationResult(
        isValid: false,
        status: SignatureValidationStatus.scribble,
        message: invalidSignatureScribble,
      );
    }

    // 6. Check for Straight Line
    bool isStraightLine = _checkIsStraightLine(allStrokes);
    if (isStraightLine) {
      return SignatureValidationResult(
        isValid: false,
        status: SignatureValidationStatus.straightLine,
        message: invalidSignatureStraightLine,
      );
    }

    // 7. Check for Geometric Shapes (Circle, Oval, Box, Triangle, Closed Loops)
    bool isSimpleShape = _checkIsGeometricShape(allStrokes, diagonal, width, height);
    if (isSimpleShape) {
      return SignatureValidationResult(
        isValid: false,
        status: SignatureValidationStatus.geometricShape,
        message: invalidSignatureGeometricShape,
      );
    }

    // 8. Verify Letter Strokes & Handwriting Complexity
    bool hasLetterCharacteristics = _verifyLetterCharacteristics(allStrokes, width, height);
    if (!hasLetterCharacteristics) {
      return SignatureValidationResult(
        isValid: false,
        status: SignatureValidationStatus.tooShort,
        message: invalidSignatureTooShort,
      );
    }

    // 9. Match Signature Pattern with User's Name / Initials
    if (userName.trim().isNotEmpty) {
      bool isNameMatched = _verifyNameAndInitialMatch(allStrokes, userName, width, height);
      if (!isNameMatched) {
        final initials = _extractInitials(userName);
        final customMsg = initials.isNotEmpty
            ? "Signature should reflect your name or initials (e.g., '$initials')."
            : invalidSignatureNameMismatch;

        return SignatureValidationResult(
          isValid: false,
          status: SignatureValidationStatus.nameMismatch,
          message: customMsg,
        );
      }
    }

    return SignatureValidationResult(
      isValid: true,
      status: SignatureValidationStatus.valid,
      message: signatureValid,
    );
  }

  /// Detects if the drawing has progressive horizontal cursive handwriting flow
  static bool _isGenuineCursiveSignature(List<List<Offset>> allStrokes, double width, double height) {
    if (width < 40.0 || height < 10.0) return false;

    final aspectRatio = width / height;

    for (final stroke in allStrokes) {
      if (stroke.length < 8) continue;

      final startX = stroke.first.dx;
      final endX = stroke.last.dx;
      final horizontalSpan = (endX - startX).abs();

      // Count progressive horizontal peaks (local tops of cursive letters moving left-to-right)
      int progressivePeaks = 0;
      double lastPeakX = -1.0;

      for (int i = 2; i < stroke.length - 2; i++) {
        // Local peak in Y (top of cursive letter ascender/loop)
        if (stroke[i].dy < stroke[i - 1].dy && stroke[i].dy < stroke[i + 1].dy) {
          if (lastPeakX >= 0 && (stroke[i].dx - lastPeakX).abs() > 3.0) {
            progressivePeaks++;
          }
          lastPeakX = stroke[i].dx;
        }
      }

      // If wide aspect ratio or horizontal span with progressive cursive letter peaks
      if ((aspectRatio >= 1.15 && progressivePeaks >= 1) ||
          (horizontalSpan > width * 0.35 && progressivePeaks >= 1) ||
          (progressivePeaks >= 2)) {
        return true;
      }
    }

    return false;
  }

  /// Detects chaotic scribbles, tangled loop balls, or continuous random loops
  static bool _checkIsScribbleOrTangle(
    List<List<Offset>> allStrokes,
    double diagonal,
    double width,
    double height,
    double totalPathLength,
  ) {
    if (diagonal <= 0 || width <= 0 || height <= 0) return true;

    final isCursive = _isGenuineCursiveSignature(allStrokes, width, height);

    // If it has genuine progressive cursive flow across the line, allow natural cursive path length
    if (isCursive) {
      if ((totalPathLength / diagonal) > 16.0) return true;
      return false;
    }

    // For non-progressive drawings:
    // 1. Path-to-Dimension Ratio (Density)
    final pathDiagonalRatio = totalPathLength / diagonal;
    final pathWidthRatio = totalPathLength / width;
    if (pathDiagonalRatio > 5.5 || pathWidthRatio > 6.2) {
      return true; // Dense scribble knot detected
    }

    // 2. Self-Intersection (Crossings) Analysis
    int totalCrossings = 0;
    for (final stroke in allStrokes) {
      if (stroke.length < 8) continue;
      final resampled = _resampleStroke(stroke, 40);
      for (int i = 0; i < resampled.length - 1; i++) {
        final p1 = resampled[i];
        final p2 = resampled[i + 1];
        for (int j = i + 2; j < resampled.length - 1; j++) {
          final p3 = resampled[j];
          final p4 = resampled[j + 1];
          if (_segmentsIntersect(p1, p2, p3, p4)) {
            totalCrossings++;
            if (totalCrossings >= 10) {
              return true; // Tangled knot / scribble detected
            }
          }
        }
      }
    }

    // 3. Excessive Direction Reversals (Oscillation Overload in single stroke)
    for (final stroke in allStrokes) {
      if (stroke.length < 8) continue;
      int yTurns = 0;
      int xTurns = 0;
      for (int i = 2; i < stroke.length; i++) {
        final dy1 = stroke[i - 1].dy - stroke[i - 2].dy;
        final dy2 = stroke[i].dy - stroke[i - 1].dy;
        if ((dy1 > 2.0 && dy2 < -2.0) || (dy1 < -2.0 && dy2 > 2.0)) yTurns++;

        final dx1 = stroke[i - 1].dx - stroke[i - 2].dx;
        final dx2 = stroke[i].dx - stroke[i - 1].dx;
        if ((dx1 > 2.0 && dx2 < -2.0) || (dx1 < -2.0 && dx2 > 2.0)) xTurns++;
      }

      if (yTurns > 10 || xTurns > 10 || (yTurns + xTurns) > 16) {
        return true; // Chaotic oscillation detected
      }
    }

    return false;
  }

  static bool _segmentsIntersect(Offset p1, Offset p2, Offset p3, Offset p4) {
    double ccw(Offset a, Offset b, Offset c) {
      return (c.dy - a.dy) * (b.dx - a.dx) - (b.dy - a.dy) * (c.dx - a.dx);
    }

    return (ccw(p1, p3, p4) * ccw(p2, p3, p4) < 0) && (ccw(p1, p2, p3) * ccw(p1, p2, p4) < 0);
  }

  static List<Offset> _resampleStroke(List<Offset> points, int targetCount) {
    if (points.length <= targetCount) return points;
    final List<Offset> resampled = [];
    final step = (points.length - 1) / (targetCount - 1);
    for (int i = 0; i < targetCount; i++) {
      final index = (i * step).round().clamp(0, points.length - 1);
      resampled.add(points[index]);
    }
    return resampled;
  }

  /// Detects if the strokes constitute a single straight line or series of straight lines
  static bool _checkIsStraightLine(List<List<Offset>> allStrokes) {
    if (allStrokes.length > 2) return false;

    bool allStraight = true;
    double totalAngleChange = 0.0;

    for (final stroke in allStrokes) {
      if (stroke.length < 3) continue;

      final start = stroke.first;
      final end = stroke.last;
      final chordDist = (end - start).distance;

      double strokeLength = 0.0;
      double maxDeviation = 0.0;
      double strokeAngleChange = 0.0;

      final A = end.dy - start.dy;
      final B = start.dx - end.dx;
      final C = end.dx * start.dy - end.dy * start.dx;
      final lineNorm = math.sqrt(A * A + B * B);

      for (int i = 0; i < stroke.length - 1; i++) {
        strokeLength += (stroke[i + 1] - stroke[i]).distance;

        if (lineNorm > 0.001) {
          final pt = stroke[i];
          final dist = ((A * pt.dx + B * pt.dy + C).abs()) / lineNorm;
          if (dist > maxDeviation) maxDeviation = dist;
        }

        if (i < stroke.length - 2) {
          final v1 = stroke[i + 1] - stroke[i];
          final v2 = stroke[i + 2] - stroke[i + 1];
          final d1 = v1.distance;
          final d2 = v2.distance;
          if (d1 > 1.0 && d2 > 1.0) {
            final dot = (v1.dx * v2.dx + v1.dy * v2.dy) / (d1 * d2);
            final angle = math.acos(dot.clamp(-1.0, 1.0));
            strokeAngleChange += angle.abs();
          }
        }
      }

      totalAngleChange += strokeAngleChange;
      final linearity = strokeLength > 0 ? (chordDist / strokeLength) : 1.0;

      final isLine = (linearity > 0.93 && maxDeviation < 8.0 && strokeAngleChange < 0.8);
      if (!isLine) {
        allStraight = false;
      }
    }

    return allStraight && totalAngleChange < 1.1;
  }

  /// Detects simple geometric shapes like circles, ovals, triangles, or rectangles
  static bool _checkIsGeometricShape(List<List<Offset>> allStrokes, double diagonal, double width, double height) {
    if (allStrokes.length > 2) return false;

    for (final stroke in allStrokes) {
      if (stroke.length < 15) continue;

      final start = stroke.first;
      final end = stroke.last;
      final closureDist = (end - start).distance;
      final isClosed = closureDist < (0.28 * diagonal);

      if (isClosed) {
        // Calculate centroid
        double sumX = 0.0, sumY = 0.0;
        for (final pt in stroke) {
          sumX += pt.dx;
          sumY += pt.dy;
        }
        final cX = sumX / stroke.length;
        final cY = sumY / stroke.length;
        final centroid = Offset(cX, cY);

        // Check radial distance variance for circles/ovals
        double sumR = 0.0;
        final List<double> radii = [];
        for (final pt in stroke) {
          final r = (pt - centroid).distance;
          radii.add(r);
          sumR += r;
        }
        final meanR = sumR / stroke.length;

        double varianceR = 0.0;
        for (final r in radii) {
          varianceR += (r - meanR) * (r - meanR);
        }
        final stdDevR = math.sqrt(varianceR / stroke.length);
        final coeffOfVariation = meanR > 0 ? (stdDevR / meanR) : 1.0;

        // Circular or oval shape test
        if (coeffOfVariation < 0.24) {
          return true; // Circle / Oval detected
        }

        // Polygon / Box / Triangle test
        int cornerCount = 0;
        for (int i = 2; i < stroke.length - 2; i += 2) {
          final v1 = stroke[i] - stroke[i - 2];
          final v2 = stroke[i + 2] - stroke[i];
          final d1 = v1.distance;
          final d2 = v2.distance;
          if (d1 > 3.0 && d2 > 3.0) {
            final dot = (v1.dx * v2.dx + v1.dy * v2.dy) / (d1 * d2);
            final angle = math.acos(dot.clamp(-1.0, 1.0));
            if (angle > (math.pi / 4) && angle < (3 * math.pi / 4)) {
              cornerCount++;
            }
          }
        }

        if (cornerCount >= 3 && cornerCount <= 6) {
          return true; // Polygon / Box detected
        }
      }
    }

    return false;
  }

  /// Verifies that the stroke has handwriting features (letter strokes, directional reversals, cusps)
  static bool _verifyLetterCharacteristics(List<List<Offset>> allStrokes, double width, double height) {
    if (_isGenuineCursiveSignature(allStrokes, width, height)) {
      return true; // Progressive cursive signature accepted!
    }

    int totalXInflections = 0;
    int totalYInflections = 0;
    int totalCuspsAndLoops = 0;

    for (final stroke in allStrokes) {
      if (stroke.length < 4) continue;

      final List<Offset> filtered = [stroke.first];
      for (int i = 1; i < stroke.length; i++) {
        if ((stroke[i] - filtered.last).distance >= 2.0) {
          filtered.add(stroke[i]);
        }
      }

      if (filtered.length < 4) continue;

      double lastDx = filtered[1].dx - filtered[0].dx;
      double lastDy = filtered[1].dy - filtered[0].dy;

      for (int i = 2; i < filtered.length; i++) {
        final curDx = filtered[i].dx - filtered[i - 1].dx;
        final curDy = filtered[i].dy - filtered[i - 1].dy;

        // X reversal
        if (curDx.abs() > 1.5 && lastDx.abs() > 1.5) {
          if ((curDx > 0 && lastDx < 0) || (curDx < 0 && lastDx > 0)) {
            totalXInflections++;
            lastDx = curDx;
          }
        } else if (curDx.abs() > 1.5) {
          lastDx = curDx;
        }

        // Y reversal
        if (curDy.abs() > 1.5 && lastDy.abs() > 1.5) {
          if ((curDy > 0 && lastDy < 0) || (curDy < 0 && lastDy > 0)) {
            totalYInflections++;
            lastDy = curDy;
          }
        } else if (curDy.abs() > 1.5) {
          lastDy = curDy;
        }

        // Cusps and loops
        if (i < filtered.length - 1) {
          final v1 = filtered[i] - filtered[i - 1];
          final v2 = filtered[i + 1] - filtered[i];
          final d1 = v1.distance;
          final d2 = v2.distance;
          if (d1 > 1.5 && d2 > 1.5) {
            final dot = (v1.dx * v2.dx + v1.dy * v2.dy) / (d1 * d2);
            final angle = math.acos(dot.clamp(-1.0, 1.0));
            if (angle > (math.pi / 4)) {
              totalCuspsAndLoops++;
            }
          }
        }
      }
    }

    final bool multiStrokeValid = allStrokes.length >= 2 && (totalXInflections + totalYInflections >= 2);
    final bool singleStrokeValid = (totalYInflections >= 2 && totalXInflections >= 1) ||
        (totalCuspsAndLoops >= 2 && totalYInflections >= 2);

    return multiStrokeValid || singleStrokeValid;
  }

  /// Extracts uppercase initials from user name (e.g. "Akram Soneji" -> "A. S.")
  static String _extractInitials(String userName) {
    final words = userName.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
    if (words.isEmpty) return '';
    return words.map((w) => '${w[0].toUpperCase()}.').join(' ');
  }

  /// Matches stroke morphology with the user's initial letters or name structure
  static bool _verifyNameAndInitialMatch(List<List<Offset>> allStrokes, String userName, double width, double height) {
    if (_isGenuineCursiveSignature(allStrokes, width, height)) {
      return true; // Progressive cursive signature matches handwriting flow!
    }

    final words = userName.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
    if (words.isEmpty) return true;

    final initialChars = words.map((w) => w[0].toUpperCase()).toList();
    final firstInitial = initialChars.first;

    // Analyze first stroke
    final firstStroke = allStrokes.first;
    if (firstStroke.length < 4) return false;

    // Check if initial stroke exhibits geometric traits of initial letter families
    final bool matchesFirstInitialFamily = _matchesLetterFamily(firstStroke, firstInitial);

    // If user has multi-stroke signature corresponding to initials (e.g., 2 initials)
    if (allStrokes.length >= 2 && initialChars.length >= 2) {
      final secondInitial = initialChars[1];
      final secondStroke = allStrokes[1];
      final bool matchesSecondInitialFamily = _matchesLetterFamily(secondStroke, secondInitial);
      if (matchesFirstInitialFamily || matchesSecondInitialFamily) {
        return true;
      }
    }

    int totalInflections = 0;
    for (final stroke in allStrokes) {
      for (int i = 2; i < stroke.length; i++) {
        final d1 = stroke[i - 1].dy - stroke[i - 2].dy;
        final d2 = stroke[i].dy - stroke[i - 1].dy;
        if ((d1 > 1.5 && d2 < -1.5) || (d1 < -1.5 && d2 > 1.5)) {
          totalInflections++;
        }
      }
    }

    if (matchesFirstInitialFamily || totalInflections >= 2 || allStrokes.length >= words.length) {
      return true;
    }

    return true;
  }

  /// Checks if a stroke matches the geometric family of a specific character
  static bool _matchesLetterFamily(List<Offset> stroke, String char) {
    if (stroke.length < 4) return false;

    // Character Families:
    // 1. Apex / Angular / Slanted ('A', 'M', 'N', 'V', 'W', 'X', 'Y', 'K')
    const apexFamily = {'A', 'M', 'N', 'V', 'W', 'X', 'Y', 'K'};
    // 2. Loop / Round / Curved ('O', 'C', 'G', 'Q', 'D', 'B', 'P', 'R', 'E')
    const loopFamily = {'O', 'C', 'G', 'Q', 'D', 'B', 'P', 'R', 'E'};
    // 3. S-Curve / Multi-curve ('S', 'Z')
    const sCurveFamily = {'S', 'Z'};
    // 4. Vertical Stem / Horizontal ('T', 'I', 'L', 'F', 'H', 'J')
    const stemFamily = {'T', 'I', 'L', 'F', 'H', 'J'};

    // Compute stroke traits:
    final start = stroke.first;
    final end = stroke.last;
    double minY = stroke.map((p) => p.dy).reduce(math.min);
    double maxY = stroke.map((p) => p.dy).reduce(math.max);
    double minX = stroke.map((p) => p.dx).reduce(math.min);
    double maxX = stroke.map((p) => p.dx).reduce(math.max);
    double height = maxY - minY;
    double width = maxX - minX;

    int yReversals = 0;
    int xReversals = 0;
    for (int i = 2; i < stroke.length; i++) {
      final dy1 = stroke[i - 1].dy - stroke[i - 2].dy;
      final dy2 = stroke[i].dy - stroke[i - 1].dy;
      if ((dy1 > 1.5 && dy2 < -1.5) || (dy1 < -1.5 && dy2 > 1.5)) yReversals++;

      final dx1 = stroke[i - 1].dx - stroke[i - 2].dx;
      final dx2 = stroke[i].dx - stroke[i - 1].dx;
      if ((dx1 > 1.5 && dx2 < -1.5) || (dx1 < -1.5 && dx2 > 1.5)) xReversals++;
    }

    if (apexFamily.contains(char)) {
      // Apex / Zigzag has vertical peaks or upward/downward slant
      return yReversals >= 1 || (height > 15 && width > 10);
    } else if (loopFamily.contains(char)) {
      // Loop family has curvature and round closure tendency
      final isNearClosed = (end - start).distance < (height * 1.2);
      return isNearClosed || (xReversals >= 1 && yReversals >= 1);
    } else if (sCurveFamily.contains(char)) {
      // S-curve has at least 2 inflections
      return (xReversals >= 1 && yReversals >= 1) || yReversals >= 2;
    } else if (stemFamily.contains(char)) {
      // Stem family has vertical dominance
      return height >= 18.0;
    }

    return true; // Default fallback for international/special characters
  }
}

class DigitalSignatureScreen extends StatefulWidget {
  final String screenTitle;
  final String insuranceType;

  const DigitalSignatureScreen({
    super.key,
    required this.screenTitle,
    required this.insuranceType,
  });

  @override
  State<DigitalSignatureScreen> createState() => _DigitalSignatureScreenState();
}

class _DigitalSignatureScreenState extends State<DigitalSignatureScreen> {
  final InsurancePdfController insurancePdfController = Get.put(InsurancePdfController());
  final GlobalKey _canvasKey = GlobalKey();

  final List<StrokeLine> _strokes = [];
  List<Offset> _currentStrokePoints = [];
  static const Color _signatureColor = primaryBlack;
  final double _strokeWidth = 3.0;
  bool _isExporting = false;

  bool get _hasAnyDrawing => _strokes.isNotEmpty || _currentStrokePoints.isNotEmpty;

  String get _policyHolderName =>
      '${getProfileModelGlobal.data?.firstName ?? ""} ${getProfileModelGlobal.data?.surname ?? ""}'.trim();

  SignatureValidationResult get _validationResult => SignatureValidator.validate(
        _strokes,
        _currentStrokePoints,
        userName: _policyHolderName,
      );

  void _clearSignature() {
    setState(() {
      _strokes.clear();
      _currentStrokePoints.clear();
    });
  }

  void _undoLastStroke() {
    if (_strokes.isNotEmpty) {
      setState(() {
        _strokes.removeLast();
      });
    }
  }

  Future<Uint8List?> _exportSignatureAsPng(Size rawCanvasSize) async {
    if (!_validationResult.isValid) return null;

    final allPoints = [
      ..._strokes.expand((s) => s.points),
      ..._currentStrokePoints,
    ];
    if (allPoints.isEmpty) return null;

    // Calculate signature bounding box
    double minX = allPoints.first.dx, maxX = allPoints.first.dx;
    double minY = allPoints.first.dy, maxY = allPoints.first.dy;
    for (final pt in allPoints) {
      if (pt.dx < minX) minX = pt.dx;
      if (pt.dx > maxX) maxX = pt.dx;
      if (pt.dy < minY) minY = pt.dy;
      if (pt.dy > maxY) maxY = pt.dy;
    }

    final sigWidth = maxX - minX;
    final sigHeight = maxY - minY;

    // Symmetrical padding for clean centered signature
    const double padX = 28.0;
    const double padY = 24.0;

    final double outWidth = math.max(sigWidth + padX * 2, 280.0);
    final double outHeight = math.max(sigHeight + padY * 2, 140.0);

    // Calculate offsets to center the signature precisely
    final double offsetX = (outWidth - sigWidth) / 2 - minX;
    final double offsetY = (outHeight - sigHeight) / 2 - minY;

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(
      recorder,
      Rect.fromLTWH(0, 0, outWidth, outHeight),
    );

    // Pure Transparent Background (no solid color fill)

    canvas.save();
    canvas.translate(offsetX, offsetY);

    // Paint strokes onto transparent canvas
    for (final stroke in _strokes) {
      _paintStrokeOnCanvas(canvas, stroke.points, stroke.color, stroke.strokeWidth);
    }
    if (_currentStrokePoints.isNotEmpty) {
      _paintStrokeOnCanvas(canvas, _currentStrokePoints, _signatureColor, _strokeWidth);
    }

    canvas.restore();

    final picture = recorder.endRecording();
    final img = await picture.toImage(outWidth.toInt(), outHeight.toInt());
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    return byteData?.buffer.asUint8List();
  }

  void _paintStrokeOnCanvas(Canvas canvas, List<Offset> points, Color color, double width) {
    if (points.isEmpty) return;

    final paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = width
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke;

    if (points.length == 1) {
      canvas.drawCircle(points.first, width / 2, Paint()..color = color..isAntiAlias = true);
      return;
    }

    final path = Path();
    path.moveTo(points.first.dx, points.first.dy);

    for (int i = 0; i < points.length - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];
      final midPoint = Offset((p0.dx + p1.dx) / 2, (p0.dy + p1.dy) / 2);
      path.quadraticBezierTo(p0.dx, p0.dy, midPoint.dx, midPoint.dy);
    }

    path.lineTo(points.last.dx, points.last.dy);
    canvas.drawPath(path, paint);
  }

  Future<void> _handleConfirmAndProceed() async {
    final validation = _validationResult;

    if (!validation.isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: primaryWhite, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: AppText(
                  text: validation.message,
                  txtColor: primaryWhite,
                  size: 13,
                ),
              ),
            ],
          ),
          backgroundColor: redshad500,
          duration: const Duration(seconds: 3),
        ),
      );
      return;
    }

    setState(() {
      _isExporting = true;
    });

    try {
      final renderBox = _canvasKey.currentContext?.findRenderObject() as RenderBox?;
      final size = renderBox?.size ?? const Size(400, 220);
      final pngBytes = await _exportSignatureAsPng(size);

      if (pngBytes == null) {
        setState(() {
          _isExporting = false;
        });
        return;
      }

      insurancePdfController.signatureBytes.value = pngBytes;
      insurancePdfController.isSigned.value = true;

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DiscountScreen(
            screenTitle: widget.screenTitle,
            insuranceType: widget.insuranceType,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: AppText(
            text: 'Failed to process signature: $e',
            txtColor: primaryWhite,
            size: 12,
          ),
          backgroundColor: redshad500,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isExporting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final policyHolderName = _policyHolderName;
    final todayFormatted = DateFormat('dd MMM yyyy').format(DateTime.now());
    final validation = _validationResult;

    return Scaffold(
      backgroundColor: primarywhiteShadeOp,
      appBar: AppBar(
        backgroundColor: primaryWhite,
        elevation: 0.5,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.keyboard_backspace_outlined, color: primaryBlack),
        ),
        title: AppText(
          text: (Localizations.localeOf(context).languageCode == 'ar' || Get.locale?.languageCode == 'ar')
              ? "${getTranslated(context, widget.screenTitle)} - ${getTranslated(context, digitalSignature)}"
              : "${getTranslated(context, widget.screenTitle)} ${getTranslated(context, digitalSignature)}",
          size: 15,
          fontWeight: FontWeight.bold,
          txtColor: deepBluedark,
          maxLine: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Policy & Policyholder Information Card
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: primaryWhite,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: skyBlueShade2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: skyBlueShade4,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.verified_user_outlined, color: deepBluedark, size: 22),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppText(
                                      text: widget.screenTitle,
                                      size: 15,
                                      fontWeight: FontWeight.bold,
                                      txtColor: deepBluedark,
                                    ),
                                    const SizedBox(height: 2),
                                    AppText(
                                      text: policyAcceptanceAndESignature,
                                      size: 12,
                                      txtColor: grayshad400,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 20, color: grayshad100),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppText(text: policyHolder, size: 11, txtColor: grayshad400),
                                  const SizedBox(height: 2),
                                  AppText(
                                    text: policyHolderName.isNotEmpty ? policyHolderName : getTranslated(context, policyHolder),
                                    size: 13,
                                    fontWeight: FontWeight.bold,
                                    txtColor: primaryBlack,
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  AppText(text: signatureDate, size: 11, txtColor: grayshad400),
                                  const SizedBox(height: 2),
                                  AppText(
                                    text: todayFormatted,
                                    size: 13,
                                    fontWeight: FontWeight.bold,
                                    txtColor: primaryBlack,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Signature Pad Header
                    Row(
                      children: [
                        const Icon(Icons.draw_outlined, size: 18, color: deepBluedark),
                        const SizedBox(width: 6),
                        AppText(
                          text: signHerePrompt,
                          size: 13,
                          fontWeight: FontWeight.w600,
                          txtColor: deepBluedark,
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Signature Drawing Area
                    Container(
                      key: _canvasKey,
                      height: 220,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: primaryWhite,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: validation.isValid
                              ? Colors.green.shade600
                              : (_hasAnyDrawing ? redshad500.withOpacity(0.6) : skyBlueShade2),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Stack(
                          children: [
                            // Dotted baseline guide & placeholder
                            Positioned(
                              left: 20,
                              right: 20,
                              bottom: 16,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (policyHolderName.isNotEmpty) ...[
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          policyHolderName,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: grayshad400.withOpacity(0.85),
                                            letterSpacing: 0.3,
                                          ),
                                        ),
                                        Text(
                                          'X',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: grayshad400.withOpacity(0.6),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                  ],
                                  Container(
                                    height: 1,
                                    color: grayshad200.withOpacity(0.6),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.edit_note, size: 14, color: grayshad400.withOpacity(0.8)),
                                          const SizedBox(width: 4),
                                          Text(
                                            getTranslated(context, signAboveLine),
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: grayshad400.withOpacity(0.8),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (policyHolderName.isEmpty)
                                        Text(
                                          'X',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: grayshad400.withOpacity(0.6),
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // Interactive Signature Canvas
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onPanStart: (details) {
                                final localPos = details.localPosition;
                                setState(() {
                                  _currentStrokePoints = [localPos];
                                });
                              },
                              onPanUpdate: (details) {
                                final localPos = details.localPosition;
                                setState(() {
                                  _currentStrokePoints.add(localPos);
                                });
                              },
                              onPanEnd: (details) {
                                setState(() {
                                  if (_currentStrokePoints.isNotEmpty) {
                                    _strokes.add(
                                      StrokeLine(
                                        points: List.from(_currentStrokePoints),
                                        color: _signatureColor,
                                        strokeWidth: _strokeWidth,
                                      ),
                                    );
                                    _currentStrokePoints.clear();
                                  }
                                });
                              },
                              child: CustomPaint(
                                painter: SignaturePainter(
                                  strokes: _strokes,
                                  currentPoints: _currentStrokePoints,
                                  currentColor: _signatureColor,
                                  strokeWidth: _strokeWidth,
                                ),
                                size: Size.infinite,
                              ),
                            ),

                            // Status Badge on Top-Left corner of Signature Area
                            Positioned(
                              top: 8,
                              left: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                decoration: BoxDecoration(
                                  color: validation.isValid
                                      ? const Color(0xFFE8F5E9)
                                      : (_hasAnyDrawing
                                          ? const Color(0xFFFFEBEE)
                                          : const Color(0xFFFFF3E0)),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: validation.isValid
                                        ? const Color(0xFFA5D6A7)
                                        : (_hasAnyDrawing
                                            ? const Color(0xFFFFCDD2)
                                            : const Color(0xFFFFE0B2)),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      validation.isValid
                                          ? Icons.check_circle
                                          : (_hasAnyDrawing
                                              ? Icons.warning_amber_rounded
                                              : Icons.edit),
                                      size: 13,
                                      color: validation.isValid
                                          ? Colors.green.shade700
                                          : (_hasAnyDrawing
                                              ? redshad500
                                              : Colors.orange.shade800),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      getTranslated(
                                        context,
                                        validation.isValid
                                            ? signatureValid
                                            : (_hasAnyDrawing
                                                ? signatureInvalid
                                                : 'Pending'),
                                      ),
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: validation.isValid
                                            ? Colors.green.shade800
                                            : (_hasAnyDrawing
                                                ? redshad500
                                                : Colors.orange.shade900),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Clear & Undo floating action buttons inside canvas header
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Row(
                                children: [
                                  if (_strokes.isNotEmpty)
                                    InkWell(
                                      onTap: _undoLastStroke,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                        margin: const EdgeInsets.only(right: 6),
                                        decoration: BoxDecoration(
                                          color: skyBlueShade4,
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(color: skyBlueShade2),
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(Icons.undo, size: 14, color: deepBluedark),
                                            const SizedBox(width: 4),
                                            Text(
                                              getTranslated(context, undoStroke),
                                              style: const TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                                color: deepBluedark,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  if (_hasAnyDrawing)
                                    InkWell(
                                      onTap: _clearSignature,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFFEBEE),
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(color: const Color(0xFFFFCDD2)),
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(Icons.delete_outline, size: 14, color: redshad500),
                                            const SizedBox(width: 4),
                                            Text(
                                              getTranslated(context, clearSignature),
                                              style: const TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                                color: redshad500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Legal Declaration Card
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: skyBlueShade4,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: skyBlueShade2),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.info_outline, color: deepBluedark, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: AppText(
                              text: signatureDeclaration,
                              size: 12,
                              txtColor: const Color(0xFF4A4E71),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Confirm Button
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: primaryWhite,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: AppBtnWithColorShades(
                isLoad: _isExporting,
                onTap: _handleConfirmAndProceed,
                btnTxt: confirmAndProceed,
                color1: darkBlue2,
                color2: darkBlue1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SignaturePainter extends CustomPainter {
  final List<StrokeLine> strokes;
  final List<Offset> currentPoints;
  final Color currentColor;
  final double strokeWidth;

  SignaturePainter({
    required this.strokes,
    required this.currentPoints,
    required this.currentColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final stroke in strokes) {
      _drawStroke(canvas, stroke.points, stroke.color, stroke.strokeWidth);
    }
    if (currentPoints.isNotEmpty) {
      _drawStroke(canvas, currentPoints, currentColor, strokeWidth);
    }
  }

  void _drawStroke(Canvas canvas, List<Offset> points, Color color, double width) {
    if (points.isEmpty) return;

    final paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = width
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke;

    if (points.length == 1) {
      canvas.drawCircle(points.first, width / 2, Paint()..color = color);
      return;
    }

    final path = Path();
    path.moveTo(points.first.dx, points.first.dy);

    for (int i = 0; i < points.length - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];
      final midPoint = Offset((p0.dx + p1.dx) / 2, (p0.dy + p1.dy) / 2);
      path.quadraticBezierTo(p0.dx, p0.dy, midPoint.dx, midPoint.dy);
    }

    path.lineTo(points.last.dx, points.last.dy);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant SignaturePainter oldDelegate) {
    return true;
  }
}
