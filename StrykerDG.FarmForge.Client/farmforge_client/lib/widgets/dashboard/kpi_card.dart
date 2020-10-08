import 'package:farmforge_client/utilities/constants.dart';
import 'package:flutter/material.dart';

class KpiCard extends StatelessWidget {
  final double width;
  final double height;
  final String title;
  final String kpi;

  KpiCard({
    @required this.width, 
    @required this.height,
    @required this.title,
    @required this.kpi
  });

  @override
  Widget build(BuildContext context) {
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
                child: Text(
                  kpi,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline1,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}