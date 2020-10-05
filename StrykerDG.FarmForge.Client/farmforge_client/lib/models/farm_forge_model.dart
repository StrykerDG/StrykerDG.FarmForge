import 'package:farmforge_client/models/crops/crop.dart';

abstract class FarmForgeModel {
  Map<String, dynamic> toMap();

  static final _constructors = {
    Crop:(Map<String, dynamic> data) => Crop.fromMap(data)
  };

  static FarmForgeModel create(Type type, Map<String, dynamic> data) {
    return _constructors[type](data);
  }
}