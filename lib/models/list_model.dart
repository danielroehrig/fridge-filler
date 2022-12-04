import 'package:flutter/material.dart';
import 'package:fridge_filler/models/reorderable.dart';
import 'package:hive/hive.dart';

part 'list_model.g.dart';

@HiveType(typeId: 1)
class ListEntry extends HiveObject implements Reorderable {
  @HiveField(0)
  late String id;
  @HiveField(1)
  String name;
  @HiveField(3)
  int? position;
  @HiveField(2)
  late List<ItemEntry> entries;
  @HiveField(4)
  String? description;

  ListEntry({required this.name, required this.position}) {
    id = UniqueKey().toString();
    entries = <ItemEntry>[];
  }

  @override
  int getPosition() {
    return position ?? 0;
  }

  @override
  void setPosition(int position) {
    this.position = position;
  }
}

@HiveType(typeId: 2)
class ItemEntry extends HiveObject implements Reorderable {
  @HiveField(0)
  String name;
  @HiveField(1)
  String? amount;
  @HiveField(2)
  late String id;
  @HiveField(3)
  int? position;
  @HiveField(4)
  String? description;
  @HiveField(5, defaultValue: false)
  late bool done;

  ItemEntry({required this.name, this.amount, required this.done}) {
    id = UniqueKey().toString();
  }
  @override
  int getPosition() {
    return position ?? 0;
  }

  @override
  void setPosition(int position) {
    this.position = position;
  }

  @override
  Future<void> save() {
    return Future.value();
  }
}
