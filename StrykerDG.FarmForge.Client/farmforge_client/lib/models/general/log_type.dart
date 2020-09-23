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
      logTypeId: data['logTypeId'],
      entityType: data['entityType'],
      name: data['name'],
      label: data['label'],
      description: data['description']
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