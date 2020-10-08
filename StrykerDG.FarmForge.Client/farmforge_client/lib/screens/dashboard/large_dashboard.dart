import 'package:flutter/material.dart';

import 'package:farmforge_client/models/crops/crop.dart';
import 'package:farmforge_client/models/general/crop_log.dart';
import 'package:farmforge_client/models/kpi/crop_by_location.dart';

import 'package:farmforge_client/widgets/dashboard/kpi_card.dart';
import 'package:farmforge_client/widgets/dashboard/kpi_chart.dart';

import 'package:farmforge_client/utilities/constants.dart';

class LargeDashboard extends StatelessWidget {

  final List<Crop> crops;
  final List<CropLog> logs;

  LargeDashboard({this.crops, this.logs});

  List<CropByLocation> calculateCropsByLocation() {
    List<CropByLocation> results = List<CropByLocation>();

    Map<String, int> separatedCrops = Map<String, int>();
    if(crops != null && crops.length > 0) {
      crops.forEach((c) { 
        String location = c.location.label;
        if(separatedCrops.containsKey(location))
          separatedCrops[location]++;
        else
          separatedCrops.putIfAbsent(location, () => 1);
      });

      separatedCrops.forEach((key, value) {
        results.add(
          CropByLocation(key, value)
        );
      });
    }

    return results;
  }

  @override
  Widget build(BuildContext context) {
    List<CropByLocation> cropsByLocation = calculateCropsByLocation();

    return Center(
      child: Wrap(
        direction: Axis.horizontal,
        alignment: WrapAlignment.spaceAround,
        spacing: kMediumPadding,
        runSpacing: kMediumPadding,
        children: [
          KpiCard(
            width: kMediumCardWidth,
            height: kMediumCardHeight,
            title: 'Crops Planted',
            kpi: crops?.length?.toString() ?? "",
          ),
          KpiChart(
            width: kLargeCardHeight,
            height: kLargeCardHeight,
            title: 'Crops By Location',
            data: cropsByLocation,
          ),
          KpiCard(
            width: kMediumCardWidth,
            height: kMediumCardHeight,
            title: 'Total Harvests',
            kpi: logs?.length?.toString() ?? "",
          ),

        ],
      ),
    );
  }
}