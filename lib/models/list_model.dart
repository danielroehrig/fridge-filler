import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'list_model.g.dart';

@HiveType(typeId: 1)
class ListEntry {
  @HiveField(0)
  late String id;
  @HiveField(1)
  String name;
  @HiveField(2)
  late List<ItemEntry> entries;

  ListEntry({required this.name}) {
    var uuid = const Uuid();
    id = uuid.v4();
    entries = <ItemEntry>[];
  }
}

@HiveType(typeId: 2)
class ItemEntry {
  @HiveField(0)
  String name;
  @HiveField(1)
  String? amount;

  ItemEntry({required this.name, this.amount});
}
