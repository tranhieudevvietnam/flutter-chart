import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class Utils {
  static const double _degrees2Radians = math.pi / 180.0;

  /// Converts degrees to radians
  double radians(double degrees) => degrees * _degrees2Radians;

  static const double _radians2Degrees = 180.0 / math.pi;

  /// Converts radians to degrees
  double degrees(double radians) => radians * _radians2Degrees;

  /// Returns a TextStyle based on provided [context], if [providedStyle] provided we try to merge it.
  TextStyle getThemeAwareTextStyle(
    BuildContext context,
    TextStyle? providedStyle,
  ) {
    final defaultTextStyle = DefaultTextStyle.of(context);
    var effectiveTextStyle = providedStyle;
    if (providedStyle == null || providedStyle.inherit) {
      effectiveTextStyle = defaultTextStyle.style.merge(providedStyle);
    }
    if (MediaQuery.boldTextOverride(context)) {
      effectiveTextStyle = effectiveTextStyle!
          .merge(const TextStyle(fontWeight: FontWeight.bold));
    }
    return effectiveTextStyle!;
  }
}

/// Describes a line model (contains [from], and end [to])
class Line {
  Line(this.from, this.to);

  /// Start of the line
  final Offset from;

  /// End of the line
  final Offset to;

  /// Returns the length of line
  double magnitude() {
    final diff = to - from;
    final dx = diff.dx;
    final dy = diff.dy;
    return math.sqrt(dx * dx + dy * dy);
  }

  /// Returns angle of the line in radians
  double direction() {
    final diff = to - from;
    return math.atan(diff.dy / diff.dx);
  }

  /// Returns the line in magnitude of 1.0
  Offset normalize() {
    final diffOffset = to - from;
    return diffOffset * (1.0 / magnitude());
  }
}
