import 'package:hive/hive.dart';

part 'protocol_model.g.dart';

@HiveType(typeId: 0)
class ProtocolModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  int fastingHours;

  @HiveField(3)
  int eatingHours;

  @HiveField(4)
  bool isCustom;

  ProtocolModel({
    required this.id,
    required this.name,
    required this.fastingHours,
    required this.eatingHours,
    this.isCustom = false,
  });
}
