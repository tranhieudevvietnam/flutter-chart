import 'package:flutter/material.dart';
import 'package:flutter_chart/pie_chart/pie_chart_data.dart';
import 'dart:math' as math;

import 'utils.dart';

class PieChartPaint extends CustomPainter {
  final double centerSpaceRadius;
  final List<PieChartData> sections;
  final double startDegreeOffset;
  final double sectionsSpace;

  late Paint _sectionPaint;
  late Paint _sectionStrokePaint;
  BuildContext context;
  final Function(PieChartData? pieSelected, int index) callBackTouch;

  late Size viewSize;

  PieChartPaint({
    required this.context,
    required this.sections,
    required this.callBackTouch,
    this.centerSpaceRadius = double.infinity,
    this.startDegreeOffset = 0,
    this.sectionsSpace = 0,
  }) {
    _sectionPaint = Paint()..style = PaintingStyle.stroke;
    _sectionStrokePaint = Paint()..style = PaintingStyle.stroke;
  }

  @override
  void paint(Canvas canvas, Size size) {
    viewSize = size;
    final sectionsAngle = calculateSectionsAngle(sumValue);
    final centerRadius = calculateCenterRadius(size);

    drawSections(canvas, sectionsAngle, centerRadius, size);
    drawTexts(context, canvas, centerRadius, size);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  handleTouch(
    Offset localPosition,
  ) {
    debugPrint('localPosition: $localPosition');

    final sectionsAngle = calculateSectionsAngle(sumValue);

    final center = Offset(viewSize.width / 2, viewSize.height / 2);
    debugPrint('center: $center');

    final touchedPoint2 = localPosition - center;

    final touchX = touchedPoint2.dx;
    final touchY = touchedPoint2.dy;
    debugPrint('touchX: $touchX');
    debugPrint('touchY: $touchY');

    // final touchR = math.sqrt(math.pow(touchX, 2) + math.pow(touchY, 2));
    final touchR = math.sqrt(math.pow(touchX, 2) + math.pow(touchY, 2));

    var touchAngle = Utils().degrees(math.atan2(touchY, touchX));
    touchAngle = touchAngle < 0 ? (180 - touchAngle.abs()) + 180 : touchAngle;

    debugPrint('touchR: $touchR');
    debugPrint('touchAngle: $touchAngle');

    PieChartData? foundSectionData;
    var foundSectionDataPosition = -1;

    /// Find the nearest section base on the touch spot
    final relativeTouchAngle = (touchAngle - startDegreeOffset) % 360;
    var tempAngle = 0.0;
    for (var i = 0; i < sections.length; i++) {
      final section = sections[i];
      var sectionAngle = sectionsAngle[i];

      tempAngle %= 360;
      if (sections.length == 1) {
        sectionAngle = 360;
      } else {
        sectionAngle %= 360;
      }

      /// degree criteria
      final space = sectionsSpace / 2;
      final fromDegree = tempAngle + space;
      final toDegree = sectionAngle + tempAngle - space;
      final isInDegree =
          relativeTouchAngle >= fromDegree && relativeTouchAngle <= toDegree;

      /// radius criteria
      final centerRadius = calculateCenterRadius(viewSize);
      final sectionRadius = centerRadius + section.radius;
      final isInRadius = touchR > centerRadius && touchR <= sectionRadius;
      debugPrint(
          "fromDegree - ${sections[i].title}: $fromDegree  -  toDegree: $toDegree");
      debugPrint(
          "sectionRadius - ${sections[i].title}: $sectionRadius - centerRadius: $centerRadius");

      if (isInDegree && isInRadius) {
        foundSectionData = section;
        foundSectionDataPosition = i;
        break;
      }

      tempAngle += sectionAngle;
    }
    callBackTouch.call(foundSectionData, foundSectionDataPosition);

    // return PieTouchedSection(
    //   foundSectionData,
    //   foundSectionDataPosition,
    //   touchAngle,
    //   touchR,
    // );
  }

  void drawTexts(
      BuildContext context, Canvas canvas, double centerRadius, Size viewSize) {
    final center = Offset(viewSize.width / 2, viewSize.height / 2);

    var tempAngle = startDegreeOffset;

    for (var i = 0; i < sections.length; i++) {
      final section = sections[i];
      final startAngle = tempAngle;
      final sweepAngle = 360 * (section.value / sumValue);
      final sectionCenterAngle = startAngle + (sweepAngle / 2);

      Offset sectionCenter(double percentageOffset) =>
          center +
          Offset(
            math.cos(Utils().radians(sectionCenterAngle)) *
                (centerRadius + (section.radius * percentageOffset)),
            math.sin(Utils().radians(sectionCenterAngle)) *
                (centerRadius + (section.radius * percentageOffset)),
          );

      final sectionCenterOffsetTitle =
          sectionCenter(section.titlePositionPercentageOffset);

      if (section.title?.isNotEmpty == true) {
        final span = TextSpan(
          style: Utils().getThemeAwareTextStyle(context, section.titleStyle),
          text: section.title,
        );
        final tp = TextPainter(
          text: span,
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
        )..layout();

        tp.paint(
          canvas,
          sectionCenterOffsetTitle - Offset(tp.width / 2, tp.height / 2),
        );
      }

      tempAngle += sweepAngle;
    }
  }

  void drawSections(
    Canvas canvas,
    List<double> sectionsAngle,
    double centerRadius,
    Size viewSize,
  ) {
    final center = Offset(viewSize.width / 2, viewSize.height / 2);

    var tempAngle = startDegreeOffset;

    for (var i = 0; i < sections.length; i++) {
      final section = sections[i];
      final sectionDegree = sectionsAngle[i];

      if (sectionDegree == 360) {
        _sectionPaint
          ..color = section.color
          ..strokeWidth = section.radius
          ..style = PaintingStyle.stroke;
        canvas.drawCircle(
          center,
          centerRadius + section.radius / 2,
          _sectionPaint,
        );
        if (section.borderSide.width != 0.0 &&
            section.borderSide.color.opacity != 0.0) {
          _sectionStrokePaint
            ..strokeWidth = section.borderSide.width
            ..color = section.borderSide.color;
          // Outer
          canvas
            ..drawCircle(
              center,
              centerRadius + section.radius - (section.borderSide.width / 2),
              _sectionStrokePaint,
            )

            // Inner
            ..drawCircle(
              center,
              centerRadius + (section.borderSide.width / 2),
              _sectionStrokePaint,
            );
        }
        return;
      }

      final sectionPath = generateSectionPath(
        section,
        sectionsSpace,
        tempAngle,
        sectionDegree,
        center,
        centerRadius,
      );

      drawSection(section, sectionPath, canvas);
      drawSectionStroke(section, sectionPath, canvas, viewSize);
      tempAngle += sectionDegree;
    }
  }

  void drawSection(
    PieChartData section,
    Path sectionPath,
    Canvas canvas,
  ) {
    _sectionPaint
      ..color = section.color
      ..style = PaintingStyle.fill;
    canvas.drawPath(sectionPath, _sectionPaint);
  }

  void drawSectionStroke(
    PieChartData section,
    Path sectionPath,
    Canvas canvas,
    Size viewSize,
  ) {
    if (section.borderSide.width != 0.0 &&
        section.borderSide.color.opacity != 0.0) {
      canvas
        ..saveLayer(
          Rect.fromLTWH(0, 0, viewSize.width, viewSize.height),
          Paint(),
        )
        ..clipPath(sectionPath);

      _sectionStrokePaint
        ..strokeWidth = section.borderSide.width * 2
        ..color = section.borderSide.color;
      canvas
        ..drawPath(
          sectionPath,
          _sectionStrokePaint,
        )
        ..restore();
    }
  }

  Path generateSectionPath(
    PieChartData section,
    double sectionSpace,
    double tempAngle,
    double sectionDegree,
    Offset center,
    double centerRadius,
  ) {
    final sectionRadiusRect = Rect.fromCircle(
      center: center,
      radius: centerRadius + section.radius,
    );

    final centerRadiusRect = Rect.fromCircle(
      center: center,
      radius: centerRadius,
    );

    final startRadians = Utils().radians(tempAngle);
    final sweepRadians = Utils().radians(sectionDegree);
    final endRadians = startRadians + sweepRadians;

    final startLineDirection =
        Offset(math.cos(startRadians), math.sin(startRadians));

    final startLineFrom = center + startLineDirection * centerRadius;
    final startLineTo = startLineFrom + startLineDirection * section.radius;
    final startLine = Line(startLineFrom, startLineTo);

    final endLineDirection = Offset(math.cos(endRadians), math.sin(endRadians));

    final endLineFrom = center + endLineDirection * centerRadius;
    final endLineTo = endLineFrom + endLineDirection * section.radius;
    final endLine = Line(endLineFrom, endLineTo);

    var sectionPath = Path()
      ..moveTo(startLine.from.dx, startLine.from.dy)
      ..lineTo(startLine.to.dx, startLine.to.dy)
      ..arcTo(sectionRadiusRect, startRadians, sweepRadians, false)
      ..lineTo(endLine.from.dx, endLine.from.dy)
      ..arcTo(centerRadiusRect, endRadians, -sweepRadians, false)
      ..moveTo(startLine.from.dx, startLine.from.dy)
      ..close();

    // debugPrint("value: ${section.value}");
    // debugPrint("startLine.from.dx: ${startLine.from.dx}");
    // debugPrint("startLine.from.dy: ${startLine.from.dy}");
    // debugPrint("startLine.to.dx: ${startLine.to.dx}");
    // debugPrint("startLine.to.dy: ${startLine.to.dy}");
    // debugPrint("endLine.from.dx: ${endLine.from.dx}");
    // debugPrint("endLine.from.dy: ${endLine.from.dy}");
    // debugPrint("endLine.to.dx: ${endLine.to.dx}");
    // debugPrint("endLine.to.dy: ${endLine.to.dy}");

    /// Subtract section space from the sectionPath
    if (sectionSpace != 0) {
      final startLineSeparatorPath = createRectPathAroundLine(
        Line(startLineFrom, startLineTo),
        sectionSpace,
      );
      sectionPath = Path.combine(
        PathOperation.difference,
        sectionPath,
        startLineSeparatorPath,
      );

      final endLineSeparatorPath =
          createRectPathAroundLine(Line(endLineFrom, endLineTo), sectionSpace);
      sectionPath = Path.combine(
        PathOperation.difference,
        sectionPath,
        endLineSeparatorPath,
      );
    }

    return sectionPath;
  }

  Path createRectPathAroundLine(Line line, double width) {
    width = width / 2;
    final normalized = line.normalize();

    final verticalAngle = line.direction() + (math.pi / 2);
    final verticalDirection =
        Offset(math.cos(verticalAngle), math.sin(verticalAngle));

    final startPoint1 = Offset(
      line.from.dx -
          (normalized * (width / 2)).dx -
          (verticalDirection * width).dx,
      line.from.dy -
          (normalized * (width / 2)).dy -
          (verticalDirection * width).dy,
    );

    final startPoint2 = Offset(
      line.to.dx +
          (normalized * (width / 2)).dx -
          (verticalDirection * width).dx,
      line.to.dy +
          (normalized * (width / 2)).dy -
          (verticalDirection * width).dy,
    );

    final startPoint3 = Offset(
      startPoint2.dx + (verticalDirection * (width * 2)).dx,
      startPoint2.dy + (verticalDirection * (width * 2)).dy,
    );

    final startPoint4 = Offset(
      startPoint1.dx + (verticalDirection * (width * 2)).dx,
      startPoint1.dy + (verticalDirection * (width * 2)).dy,
    );

    return Path()
      ..moveTo(startPoint1.dx, startPoint1.dy)
      ..lineTo(startPoint2.dx, startPoint2.dy)
      ..lineTo(startPoint3.dx, startPoint3.dy)
      ..lineTo(startPoint4.dx, startPoint4.dy)
      ..lineTo(startPoint1.dx, startPoint1.dy);
  }

  double get sumValue => sections
      .map((data) => data.value)
      .reduce((first, second) => first + second);

  List<double> calculateSectionsAngle(
    double sumValue,
  ) {
    return sections.map((section) {
      return 360 * (section.value / sumValue);
    }).toList();
  }

  double calculateCenterRadius(
    Size viewSize,
  ) {
    if (centerSpaceRadius.isFinite) {
      return centerSpaceRadius;
    }
    final maxRadius =
        sections.reduce((a, b) => a.radius > b.radius ? a : b).radius;
    return (viewSize.shortestSide - (maxRadius * 2)) / 2;
  }
}
