import 'package:farmforge_client/models/general/log_type.dart';
import 'package:farmforge_client/utilities/date_time_utility.dart';

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
    LogType type = data['LogType'] != null
      ? LogType.fromMap(data['LogType'])
      : null;

    DateTime created = data['Created'] != null
      ? DateTime.parse(data['Created'])
      : null;

    return CropLog(
      cropLogId: data['CropLogId'],
      cropId: data['CropId'],
      logTypeId: data['LogTypeId'],
      logType: type,
      notes: data['Notes'],
      created: created
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> logType = this.logType?.toMap();

    String created = this.created != null
      ? DateTimeUtility.formatDateTime(this.created)
      : null;

    return {
      'CropLogId': this.cropLogId,
      'CropId': this.cropId,
      'LogTypeId': this.logTypeId,
      'LogType': logType,
      'Notes': this.notes,
      'Created': created
    };
  }
}