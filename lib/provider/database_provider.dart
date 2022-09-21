import 'package:flutter/material.dart';

class DatabaseProvider extends InheritedWidget {
  final Widget child;
  const DatabaseProvider({required this.child}) : super(child: child);

  @override
  bool updateShouldNotify(covariant DatabaseProvider oldWidget) {
    return oldWidget != this;
  }
}
