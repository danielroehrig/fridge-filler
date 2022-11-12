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
    ListEntry listEntry = ListEntry(name: listName, position: box.length);
    return box.put(listEntry.id.toString(), listEntry);
  }

  /// Gets all lists in the order they were saved
  List<ListEntry> getLists() {
    var list = box.values.toList();
    list.sort((a, b) {
      if (a.position == null && b.position == null) {
        return 0;
      } else if (a.position == null) {
        return 1;
      } else if (b.position == null) {
        return -1;
      } else {
        return a.position!.compareTo(b.position!);
      }
    });
    return list;
  }

  @override
  bool updateShouldNotify(covariant DatabaseProvider oldWidget) {
    return oldWidget != this;
  }
}
