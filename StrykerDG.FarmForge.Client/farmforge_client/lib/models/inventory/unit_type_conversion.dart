import 'package:farmforge_client/models/inventory/unit_type.dart';

class UnitTypeConversion {
  int unitTypeConversionId;
  int fromUnitId;
  UnitType fromUnit;
  int toUnitId;
  UnitType toUnit;
  int fromQuantity;
  int toQuantity;

  UnitTypeConversion({
    this.unitTypeConversionId = 0,
    this.fromUnitId,
    this.fromUnit,
    this.toUnitId,
    this.toUnit,
    this.fromQuantity,
    this.toQuantity
  });

  factory UnitTypeConversion.fromMap(Map<String, dynamic> data) {
    UnitType fromUnit = data['FromUnit'] != null
      ? UnitType.fromMap(data['FromUnit'])
      : null;

    UnitType toUnit = data['ToUnit'] != null
      ? UnitType.fromMap(data['ToUnit'])
      : null;

    return UnitTypeConversion(
      unitTypeConversionId: data['UnitTypeConversionId'],
      fromUnitId: data['FromUnitId'],
      fromUnit: fromUnit,
      toUnitId: data['ToUnitId'],
      toUnit: toUnit,
      fromQuantity: data['FromQuantity'],
      toQuantity: data['ToQuantity']
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> fromUnit = this.fromUnit?.toMap();
    Map<String, dynamic> toUnit = this.toUnit?.toMap();

    return {
      'UnitTypeConversionId': this.unitTypeConversionId,
      'FromUnitId': this.fromUnitId,
      'FromUnit': fromUnit,
      'ToUnitId': this.toUnitId,
      'ToUnit': toUnit,
      'FromQuantity': this.fromQuantity,
      'ToQuantity': this.toQuantity
    };
  }
}