import 'package:flutter/material.dart';
import 'package:flutter_chart/pie_chart/pie_chart_paint.dart';

import 'pie_chart/pie_chart_data.dart';

class PieChartExample extends StatefulWidget {
  const PieChartExample({super.key});

  @override
  State<PieChartExample> createState() => _PieChartExampleState();
}

class _PieChartExampleState extends State<PieChartExample> {
  int touchedIndex = -1;
  Offset? position;

  @override
  Widget build(BuildContext context) {
    final customPaint = PieChartPaint(
      context: context,
      callBackTouch: (pieSelected, index) {
        // if (pieSelected == null) {
        //   touchedIndex = -1;
        //   return;
        // }
        setState(() {
          touchedIndex = index;
        });
      },
      sections: showingSections(),
      sectionsSpace: 0,
      centerSpaceRadius: 40,
    );
    return Listener(
      onPointerDown: (event) {
        customPaint.handleTouch(
          event.position,
        );
      },
      child: CustomPaint(
        size: const Size(300, 300),
        painter: customPaint,
      ),
    );
  }

  List<PieChartData> showingSections() {
    return List.generate(4, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      switch (i) {
        case 0:
          return PieChartData(
            color: const Color(0xff0293ee),
            value: 40,
            title: '40%',
            radius: radius,
            borderSide: const BorderSide(width: 1, color: Colors.white),
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
            ),
          );
        case 1:
          return PieChartData(
            color: const Color(0xfff8b250),
            value: 30,
            title: '30%',
            radius: radius,
            borderSide: const BorderSide(width: 1, color: Colors.white),
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
            ),
          );
        case 2:
          return PieChartData(
            color: const Color(0xff845bef),
            value: 15,
            title: '15%',
            radius: radius,
            borderSide: const BorderSide(width: 1, color: Colors.white),
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
            ),
          );
        case 3:
          return PieChartData(
            color: const Color(0xff13d38e),
            value: 15,
            title: '15%',
            radius: radius,
            borderSide: const BorderSide(width: 1, color: Colors.white),
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
            ),
          );
        default:
          throw Error();
      }
    });
  }
}
