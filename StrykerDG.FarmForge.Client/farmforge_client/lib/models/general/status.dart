class Status {
  int statusId;
  String entityType;
  String name;
  String label;

  Status({
    this.statusId,
    this.entityType,
    this.name,
    this.label
  });

  factory Status.fromMap(Map<String, dynamic> data) {
    return Status(
      statusId: data['statusId'],
      entityType: data['entityType'],
      name: data['name'],
      label: data['label']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'StatusId': this.statusId,
      'EntityType': this.entityType,
      'Name': this.name,
      'Label': this.label
    };
  }
}