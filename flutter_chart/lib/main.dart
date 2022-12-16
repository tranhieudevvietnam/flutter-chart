import 'dart:math';

import 'package:flutter/material.dart';

import 'line_chart/chart_line.dart';
import 'pie_chart_example.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    List<List<ChartModel>> listData = [];
    listData = [
      [
        ChartModel(
            time: "T1",
            value: Random().nextInt(100000000),
            color: Colors.blue.shade300),
        ChartModel(time: "T2", value: Random().nextInt(100000000)),
        ChartModel(time: "T3", value: Random().nextInt(100000000)),
        ChartModel(time: "T4", value: Random().nextInt(100000000)),
        ChartModel(time: "T5", value: Random().nextInt(100000000)),
        ChartModel(time: "T6", value: Random().nextInt(100000000)),
        ChartModel(time: "T7", value: Random().nextInt(100000000)),
        ChartModel(time: "T8", value: Random().nextInt(100000000)),
        ChartModel(time: "T9", value: Random().nextInt(100000000)),
        ChartModel(time: "T10", value: Random().nextInt(100000000)),
        ChartModel(time: "T11", value: Random().nextInt(100000000)),
        ChartModel(time: "T12", value: Random().nextInt(100000000)),
      ],
      // [
      //   ChartModel(
      //       time: "T1",
      //       value: Random().nextInt(100000000),
      //       color: Colors.red.shade300),
      //   ChartModel(time: "T2", value: Random().nextInt(100000000)),
      //   ChartModel(time: "T3", value: Random().nextInt(100000000)),
      //   ChartModel(time: "T4", value: Random().nextInt(100000000)),
      //   ChartModel(time: "T5", value: Random().nextInt(100000000)),
      //   ChartModel(time: "T6", value: Random().nextInt(100000000)),
      //   ChartModel(time: "T7", value: Random().nextInt(100000000)),
      //   ChartModel(time: "T8", value: Random().nextInt(100000000)),
      //   ChartModel(time: "T9", value: Random().nextInt(100000000)),
      //   ChartModel(time: "T10", value: Random().nextInt(100000000)),
      //   ChartModel(time: "T11", value: Random().nextInt(100000000)),
      //   ChartModel(time: "T12", value: Random().nextInt(100000000)),
      // ],
    ];
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const PieChartExample(),
            ChartsLine(
              height: 300,
              colorSelect: Colors.yellow,
              onTap: (index) {
                // todayMoney = listData[1][index].value;
                // tomorrowMoney = listData[0][index].value;
                // _streamController.sink.add(null);
              },
              style: const TextStyle(fontSize: 10),
              listData: listData,
            ),
          ],
        ),
      ),
    );
  }
}
