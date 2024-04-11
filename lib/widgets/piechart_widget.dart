import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class PieChartWidget extends StatelessWidget {
  final Map<String, int> dataMap;
  final String chartTitle;
  const PieChartWidget(
      {super.key, required this.dataMap, required this.chartTitle});

  @override
  Widget build(BuildContext context) {
    if (dataMap.isEmpty) {
      return Container();
    }
    Map<String, double> resMap =
        dataMap.map((key, value) => MapEntry(key, value.toDouble()));

    /// pie chart
    return PieChart(
      dataMap: resMap,
      animationDuration: Duration(milliseconds: 800),
      chartLegendSpacing: 32,
      chartRadius: MediaQuery.of(context).size.width / 2.5,
      colorList: [
        Colors.green.shade500,
        Colors.red.shade400,
        Colors.orange.shade400,
        Colors.indigoAccent.shade400,
        Colors.blueGrey.shade400,
        Colors.teal.shade400,
        Colors.brown.shade400,
        Colors.cyan.shade400,
        Colors.deepPurple.shade400,
      ],
      initialAngleInDegree: 0,
      chartType: ChartType.ring,
      ringStrokeWidth: 35,
      centerText: chartTitle,
      legendOptions: LegendOptions(
        showLegendsInRow: false,
        legendPosition: LegendPosition.right,
        showLegends: true,
        legendShape: BoxShape.circle,
        legendTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      chartValuesOptions: ChartValuesOptions(
        showChartValueBackground: true,
        showChartValues: true,
        showChartValuesInPercentage: false,
        showChartValuesOutside: true,
        decimalPlaces: 0,
      ),
    );
  }
}
