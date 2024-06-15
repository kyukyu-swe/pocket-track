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
      chartLegendSpacing: 30,
      chartRadius: MediaQuery.of(context).size.width / 3.5,
      colorList: [
        const Color.fromARGB(255, 115, 231, 119),
        Color.fromARGB(255, 232, 120, 118),
        const Color.fromARGB(255, 224, 166, 79),
        const Color.fromARGB(255, 92, 112, 226),
        Colors.blueGrey.shade400,
        Colors.teal.shade400,
        Colors.brown.shade400,
        const Color.fromARGB(255, 77, 182, 196),
        const Color.fromARGB(255, 152, 117, 212),
      ],
      initialAngleInDegree: 0,
      chartType: ChartType.ring,
      ringStrokeWidth: 25,
      centerText: chartTitle,
      legendOptions: LegendOptions(
        showLegendsInRow: false,
        legendPosition: LegendPosition.bottom,
        showLegends: true,
        legendShape: BoxShape.circle,
        legendTextStyle: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
      chartValuesOptions: ChartValuesOptions(
        showChartValueBackground: true,
        showChartValues: true,
        showChartValuesInPercentage: true,
        showChartValuesOutside: true,
        decimalPlaces: 0,
      ),
    );
  }
}
