class Location {
  int locationId;
  int parentLocationId;
  String name;
  String label;

  Location({
    this.locationId,
    this.parentLocationId,
    this.name,
    this.label
  });

  factory Location.fromMap(Map<String, dynamic> data) {
    return Location(
      locationId: data['locationId'],
      parentLocationId: data['parentLocationId'],
      name: data['name'],
      label: data['label']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'LocationId': this.locationId,
      'ParentLocationId': this.parentLocationId,
      'Name': this.name,
      'Label': this.label
    };
  }
}