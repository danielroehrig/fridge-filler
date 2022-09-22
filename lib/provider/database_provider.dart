import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DatabaseProvider extends InheritedWidget {
  DatabaseProvider({required super.child}) : super();
  final Future<Box<dynamic>> _box = Hive.openBox('box');

  static DatabaseProvider? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<DatabaseProvider>();

  Future<void> addList(String listName) {
    return _box.then((box) {
      var listBox = box.get('name');
      if (listBox is! List<String>) {
        listBox = <String>[];
      }
      listBox.add(listName);
      box.put('name', listBox);
    });
  }

  Future<List<String>> getLists() {
    return _box.then((box) {
      var listBox = box.get('name');
      if (listBox is! List<String>) {
        listBox = <String>[];
      }
      return listBox;
    });
  }

  @override
  bool updateShouldNotify(covariant DatabaseProvider oldWidget) {
    return oldWidget != this;
  }
}
