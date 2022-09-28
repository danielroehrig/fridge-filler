import 'package:flutter/material.dart';
import 'package:multi_shop_list/models/list_model.dart';

class ListPage extends StatefulWidget {
  late ListEntry _listEntry;
  ListPage({Key? key, required ListEntry listEntry}) : super(key: key) {
    _listEntry = listEntry;
  }

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget._listEntry.name)),
    );
  }
}
