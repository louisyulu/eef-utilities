import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../model/Samples.dart';
import 'uiHelper.dart';
import 'DecompView.dart';

class SamplesPage extends StatelessWidget {
  SamplesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final samples = context.watch<Samples>();
    return ListView(children: <Widget>[
      ExpansionTile(
        title: Text('Data'),
        children: <Widget>[
          ListView(
            children: <Widget>[
              const Text(
                      'Samples generated with: y[0] = rand(),  y[i+1] = y[i] + a * rand()')
                  .bold()
                  .fontSize(18)
                  .padding(left: 80, top: 15),
              Row(
                children: <Widget>[
                  OutlinedButton(
                    child: const Text('Generate').bold(),
                    onPressed: () {
                      samples.generateData();
                    },
                  ).padding(right: 80),
                  TextField(
                    controller: TextEditingController(text: '${samples.a}'),
                    decoration: InputDecoration(
                        labelText: 'a',
                        labelStyle: TextStyle(fontWeight: FontWeight.w900)),
                    keyboardType: TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                    onSubmitted: (value) {
                      samples.setA(double.parse(value));
                    },
                  ).width(100),
                  TextField(
                    controller: TextEditingController(text: '${samples.xMin}'),
                    decoration: InputDecoration(
                        labelText: 'Xmin',
                        labelStyle: TextStyle(fontWeight: FontWeight.w900)),
                    keyboardType: TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                    onSubmitted: (value) {
                      samples.setXMin(double.parse(value));
                    },
                  ).width(100).padding(left: 80),
                  TextField(
                    controller: TextEditingController(text: '${samples.xMax}'),
                    decoration: InputDecoration(
                        labelText: 'Xmax',
                        labelStyle: TextStyle(fontWeight: FontWeight.w900)),
                    keyboardType: TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                    onSubmitted: (value) {
                      samples.setXMax(double.parse(value));
                    },
                  ).width(100).padding(left: 80),
                  TextField(
                    controller:
                        TextEditingController(text: '${samples.intervals}'),
                    decoration: InputDecoration(
                        labelText: 'Intervals',
                        labelStyle: TextStyle(fontWeight: FontWeight.w900)),
                    keyboardType: TextInputType.numberWithOptions(),
                    onSubmitted: (value) {
                      samples.setIntervals(int.parse(value));
                    },
                  ).width(100).padding(left: 80),
                ],
              ).padding(left: 80, top: 10),
              Row(children: <Widget>[]).padding(left: 80, top: 20),
              LineChart(
                LineChartData(
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    lineChartBarData(
                        data2Spots(samples.xs, samples.ys), Colors.blueAccent,
                        showChart: true),
                  ],
                  titlesData: FlTitlesData(
                    bottomTitles: _bottomTitles(samples),
                  ),
                  gridData: FlGridData(
                    drawVerticalLine: true,
                    verticalInterval: (samples.xMax - samples.xMin) / 10,
                    drawHorizontalLine: true,
                    horizontalInterval: samples.a,
                  ),
                  lineTouchData: LineTouchData(enabled: false),
                ),
              ).width(400).height(300).padding(all: 30),
            ],
          ).height(600).alignment(Alignment.topCenter),
        ],
      ),
      DecompView(),
    ]);
  }

  SideTitles _bottomTitles(Samples samples) {
    return SideTitles(
      showTitles: true,
      getTitles: (value) {
        return '$value';
      },
      interval: (samples.xMax - samples.xMin) / 10,
    );
  }
}
