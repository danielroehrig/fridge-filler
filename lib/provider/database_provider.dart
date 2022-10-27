import 'package:flutter/material.dart';
import 'package:fridge_filler/models/list_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// A provider for accessing the hive key value store aka the database
class DatabaseProvider extends InheritedWidget {
  final Box<ListEntry> box;

  const DatabaseProvider({required super.child, required this.box}) : super();

  static DatabaseProvider? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<DatabaseProvider>();

  /// Adds a new list add the bottom of the list of lists
  Future<void> addList(String listName) {
    ListEntry listEntry = ListEntry(name: listName);
    return box.put(listEntry.id.toString(), listEntry);
  }

  /// Gets all lists in the order they were saved
  List<ListEntry> getLists() {
    return box.values.toList();
  }

  @override
  bool updateShouldNotify(covariant DatabaseProvider oldWidget) {
    return oldWidget != this;
  }
}
