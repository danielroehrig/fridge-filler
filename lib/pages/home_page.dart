import 'package:flutter/material.dart';
import 'package:fridge_filler/models/list_model.dart';
import 'package:fridge_filler/pages/list_page.dart';
import 'package:fridge_filler/provider/database_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DatabaseProvider? _databaseProvider;
  final _newListFormKey = GlobalKey<FormState>();
  final _newListNameController = TextEditingController();
  final _newListAmountController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    _databaseProvider = DatabaseProvider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fridge Filler"),
      ),
      floatingActionButton: _addListButton(),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: _getLists()),
        ],
      ),
    );
  }

  Widget _getLists() {
    var list = _databaseProvider!.getLists();
    return ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          return _listEntryItem(list[index], index, context);
        });
  }

  Dismissible _listEntryItem(
      ListEntry listEntry, int index, BuildContext context) {
    return Dismissible(
      key: Key(listEntry.id),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (DismissDirection direction) {
        return showDialog<bool>(
            context: context,
            builder: (buildContext) {
              return _deleteConfirmDialog(buildContext, listEntry);
            });
      },
      child: ListTile(
        title: Text(listEntry.name),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => ListPage(
                      key: Key(listEntry.id),
                      listEntry: listEntry,
                    )),
          );
        },
      ),
    );
  }

  AlertDialog _deleteConfirmDialog(BuildContext buildContext, ListEntry list) {
    return AlertDialog(
      title: const Text("Confirm"),
      content: const Text("Do you really want to delete the whole list?"),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(buildContext, false);
          },
          child: const Text("CANCEL"),
        ),
        TextButton(
          onPressed: () {
            list.delete();
            setState(() {});
            Navigator.pop(buildContext, true);
          },
          style: TextButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          child: const Text("DELETE"),
        ),
      ],
    );
  }

  FloatingActionButton _addListButton() {
    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () {
        _showCreateListDialog();
      },
    );
  }

  void _showCreateListDialog() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext buildContext) {
          return Padding(
            padding: EdgeInsets.only(
                top: 15,
                left: 15,
                right: 15,
                bottom: MediaQuery.of(buildContext).viewInsets.bottom + 15),
            child: Form(
              key: _newListFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Name'),
                    controller: _newListNameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'A name is needed';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Menge'),
                    controller: _newListAmountController,
                    validator: (value) {
                      return null;
                    },
                  ),
                  ElevatedButton(
                      child: Text("yup"),
                      onPressed: () {
                        if (_newListFormKey.currentState!.validate()) {
                          _databaseProvider!
                              .addList(_newListNameController.text)
                              .then((v) => setState(() {}));
                        }
                        Navigator.pop(buildContext);
                      }),
                ],
              ),
            ),
          );
        });
  }
}
