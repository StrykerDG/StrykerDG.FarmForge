import 'package:farmforge_client/models/kpi/kpi_model.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import 'package:farmforge_client/utilities/constants.dart';

class KpiChart<T extends KpiModel> extends StatelessWidget {
  final double width;
  final double height;
  final String title;
  final List<T> data;

  KpiChart({
    @required this.width,
    @required this.height,
    @required this.title,
    @required this.data
  });

  List<charts.Series<T, String>> generateData() {
    return [
      new charts.Series<T, String>(
        id: title, 
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (T object, _) => object.measure,
        measureFn: (T object, _) => object.value,
        data: data, 
      )
    ];
  }

  @override
  Widget build(BuildContext context) {

    List<charts.Series<T, String>> chartData = generateData();

    return Container(
      width: width,
      height: height,
      child: Card(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(kSmallPadding),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            Expanded(
              child: Center(
                child: charts.BarChart(
                  chartData,
                  animate: false,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}