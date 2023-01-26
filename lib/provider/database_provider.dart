import 'package:flutter/material.dart';
import 'package:fridge_filler/models/list_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A provider for accessing the hive key value store aka the database
class DatabaseProvider extends InheritedWidget {
  final Box<ListEntry> box;
  final SharedPreferences prefs;
  final String _lastViewedListKey = 'last_list';

  const DatabaseProvider({required super.child, required this.box, required this.prefs}) : super();

  static DatabaseProvider? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<DatabaseProvider>();

  /// Adds a new list add the bottom of the list of lists
  Future<void> addList(String listName, String? description) {
    ListEntry listEntry = ListEntry(
        name: listName, position: box.length, description: description);
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

  /// Retrieves one specific list
  ListEntry? getList(String id){
    return box.get(id);
  }

  /// Get the last visited list
  ListEntry? getLastList() {
    String? lastList = prefs.getString(_lastViewedListKey);
    if(lastList?.isNotEmpty??false){
      return box.get(lastList);
    }
    return null;
  }

  /// Sets a list as last visited
  void setLastList(String lastList){
    prefs.setString(_lastViewedListKey, lastList);
  }

  /// Removes the last visited list information
  void resetLastList(){
    prefs.remove(_lastViewedListKey);
  }

  @override
  bool updateShouldNotify(covariant DatabaseProvider oldWidget) {
    return oldWidget != this;
  }
}
