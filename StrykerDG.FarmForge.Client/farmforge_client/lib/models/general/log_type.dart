class LogType {
  int logTypeId;
  String entityType;
  String name; 
  String label;
  String description;

  LogType({
    this.logTypeId,
    this.entityType,
    this.name,
    this.label,
    this.description
  });

  factory LogType.fromMap(Map<String, dynamic> data) {
    return LogType(
      logTypeId: data['LogTypeId'],
      entityType: data['EntityType'],
      name: data['Name'],
      label: data['Label'],
      description: data['Description']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'LogTypeId': this.logTypeId,
      'EntityType': this.entityType,
      'Name': this.name,
      'Label': this.label,
      'Description': this.description
    };
  }
}