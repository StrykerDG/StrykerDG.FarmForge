import 'package:farmforge_client/models/general/log_type.dart';

class CropLog {
  int cropLogId;
  int cropId;
  int logTypeId;
  LogType logType;
  String notes;
  DateTime created;

  CropLog({
    this.cropLogId,
    this.cropId,
    this.logTypeId,
    this.logType,
    this.notes,
    this.created
  });

  factory CropLog.fromMap(Map<String, dynamic> data) {
    LogType type = data['logType'] != null
      ? LogType.fromMap(data['logType'])
      : null;

    DateTime created = data['created'] != null
      ? DateTime.parse(data['created'])
      : null;

    return CropLog(
      cropLogId: data['cropLogId'],
      cropId: data['cropId'],
      logTypeId: data['logTypeId'],
      logType: type,
      notes: data['notes'],
      created: created
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'CropLogId': this.cropLogId,
      'CropId': this.cropId,
      'LogTypeId': this.logTypeId,
      'Notes': this.notes,
      'Created': this.created
    };
  }
}