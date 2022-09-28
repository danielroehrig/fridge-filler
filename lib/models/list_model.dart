import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'list_model.g.dart';

@HiveType(typeId: 1)
class ListEntry extends HiveObject {
  @HiveField(0)
  late String id;
  @HiveField(1)
  String name;
  @HiveField(2)
  late List<ItemEntry> entries;

  ListEntry({required this.name}) {
    id = UniqueKey().toString();
    entries = <ItemEntry>[];
  }
}

@HiveType(typeId: 2)
class ItemEntry extends HiveObject {
  @HiveField(0)
  String name;
  @HiveField(1)
  String? amount;

  ItemEntry({required this.name, this.amount});
}
