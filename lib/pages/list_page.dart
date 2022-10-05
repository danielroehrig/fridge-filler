import 'package:flutter/material.dart';
import 'package:multi_shop_list/models/list_model.dart';

class ListPage extends StatefulWidget {
  final ListEntry listEntry;

  ListPage({Key? key, required this.listEntry}) : super(key: key);

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  late ListEntry _listEntry;
  @override
  Widget build(BuildContext context) {
    _listEntry = widget.listEntry;
    return Scaffold(
      appBar: AppBar(title: Text(_listEntry.name)),
      body: _showEntries(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          _addItem();
        },
      ),
    );
  }

  Widget _showEntries() {
    return ListView.builder(
      itemBuilder: (context, index) {
        ItemEntry entry = _listEntry.entries[index];
        return Dismissible(
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            child: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          direction: DismissDirection.endToStart,
          onDismissed: (dismissDirection) {
            _listEntry.entries.removeAt(index);
            _listEntry.save();
          },
          key: Key(entry.id),
          child: ListTile(
            title: Text(entry.name),
            subtitle: Text(entry.id ?? ""),
          ),
        );
      },
      itemCount: _listEntry.entries.length,
    );
  }

  void _addItem() {
    showDialog(
        context: context,
        builder: (buildContext) {
          return AlertDialog(
            icon: const Icon(Icons.add),
            title: const Text("Add new Item"),
            content: TextField(
              onSubmitted: (itemName) {
                _listEntry.entries.add(ItemEntry(name: itemName));
                _listEntry.save().then((v) {
                  setState(() {});
                  Navigator.pop(buildContext);
                });
              },
            ),
          );
        });
  }
}
