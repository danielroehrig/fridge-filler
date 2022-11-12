import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'list_model.g.dart';

@HiveType(typeId: 1)
class ListEntry extends HiveObject {
  @HiveField(0)
  late String id;
  @HiveField(1)
  String name;
  @HiveField(3)
  int? position;
  @HiveField(2)
  late List<ItemEntry> entries;

  ListEntry({required this.name, required this.position}) {
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
  @HiveField(2)
  late String id;

  ItemEntry({required this.name, this.amount}) {
    id = UniqueKey().toString();
  }
}
