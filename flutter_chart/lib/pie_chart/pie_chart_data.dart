import 'package:flutter/material.dart';

class PieChartData {
  final double value;
  String? title;
  final TextStyle titleStyle;
  final Color color;
  final double radius;
  BorderSide borderSide;
  final double titlePositionPercentageOffset;
  PieChartData(
      {required this.value,
      this.title,
      required this.titleStyle,
      required this.color,
      required this.radius,
      this.borderSide = const BorderSide(width: 0),
      this.titlePositionPercentageOffset = 0.5});
}
