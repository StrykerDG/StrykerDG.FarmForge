class UnitType {
  int unitTypeId;
  String name;
  String label;
  String description;

  UnitType({
    this.unitTypeId = 0,
    this.name,
    this.label,
    this.description
  });

  factory UnitType.fromMap(Map<String, dynamic> data) {
    return UnitType(
      unitTypeId: data['UnitTypeId'],
      name: data['Name'],
      label: data['Label'],
      description: data['Description']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'UnitTypeId': this.unitTypeId,
      'Name': this.name,
      'Label': this.label,
      'Description': this.description
    };
  }
}