import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
  AppLocalizations? _appLocalization;
  final _newListFormKey = GlobalKey<FormState>();
  final _newListNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    _databaseProvider = DatabaseProvider.of(context);
    _appLocalization = AppLocalizations.of(context)!;
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
      title: Text(_appLocalization!.confirm),
      content: Text(_appLocalization!.confirmDeleteList(list.name)),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(buildContext, false);
          },
          child: Text(_appLocalization!.cancel),
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
          child: Text(_appLocalization!.delete),
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
                    autofocus: true,
                    decoration:
                        InputDecoration(labelText: _appLocalization!.name),
                    controller: _newListNameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'A name is needed'; //Will never be shown
                      }
                      return null;
                    },
                  ),
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                          minWidth: double.infinity, minHeight: 30),
                      child: ElevatedButton(
                          child: Text(_appLocalization!.addNewList),
                          onPressed: () {
                            if (_newListFormKey.currentState!.validate()) {
                              _databaseProvider!
                                  .addList(_newListNameController.text)
                                  .then((v) => setState(() {}));
                            }
                            Navigator.pop(buildContext);
                          }),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).then((value) => _newListFormKey.currentState!.reset());
  }
}
