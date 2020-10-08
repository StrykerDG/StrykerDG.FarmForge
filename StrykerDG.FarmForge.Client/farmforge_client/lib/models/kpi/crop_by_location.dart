import 'package:farmforge_client/models/kpi/kpi_model.dart';

class CropByLocation extends KpiModel {
  String measure;
  int value;

  CropByLocation(this.measure, this.value);
}