import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:multi_shop_list/models/list_model.dart';

/// A provider for accessing the hive key value store aka the database
class DatabaseProvider extends InheritedWidget {
  DatabaseProvider({required super.child}) : super();
  final Future<Box<ListEntry>> _box = Hive.openBox<ListEntry>('box');

  static DatabaseProvider? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<DatabaseProvider>();

  /// Adds a new list add the bottom of the list of lists
  Future<void> addList(String listName) {
    return _box.then((box) {
      ListEntry listEntry = ListEntry(name: listName);
      box.put(listEntry.id.toString(), listEntry);
    });
  }

  /// Gets all lists in the order they were saved
  Future<List<ListEntry>> getLists() {
    return _box.then((box) {
      return box.values.toList();
    });
  }

  @override
  bool updateShouldNotify(covariant DatabaseProvider oldWidget) {
    return oldWidget != this;
  }
}
