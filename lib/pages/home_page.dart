import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fridge_filler/models/list_model.dart';
import 'package:fridge_filler/pages/list_page.dart';
import 'package:fridge_filler/provider/database_provider.dart';

import '../models/reorderable.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DatabaseProvider? _databaseProvider;
  late AppLocalizations _appLocalization;
  final _newListFormKey = GlobalKey<FormState>();
  final _newListNameController = TextEditingController();
  final _newListDescriptionController = TextEditingController();
  late List<ListEntry> _lists;
  late double _deviceWidth, _deviceHeight;
  @override
  Widget build(BuildContext context) {
    _databaseProvider = DatabaseProvider.of(context);
    _appLocalization = AppLocalizations.of(context)!;
    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = MediaQuery.of(context).size.height;
    _lists = _databaseProvider!.getLists();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fridge Filler"),
      ),
      floatingActionButton: _addListButton(),
      body: _lists.isNotEmpty ? _showList(_lists) : _showEmptyList(context),
    );
  }

  Column _showList(List<ListEntry> lists) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(child: _getLists(lists)),
      ],
    );
  }

  Center _showEmptyList(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            _appLocalization.emptyList,
            style: Theme.of(context).textTheme.headline3,
          ),
          Icon(
            Icons.edit_note_outlined,
            size: min(_deviceWidth, _deviceHeight) * 0.3,
          ),
          Text(_appLocalization.addLists),
        ],
      ),
    );
  }

  Widget _getLists(List<ListEntry> lists) {
    return ReorderableListView.builder(
      itemCount: lists.length,
      itemBuilder: (context, index) {
        return _listEntryItem(lists[index], index, context);
      },
      onReorder: (int oldIndex, int newIndex) async {
        if (oldIndex < newIndex) {
          newIndex -= 1;
        }
        final ListEntry movedList = lists.removeAt(oldIndex);
        lists.insert(newIndex, movedList);
        await updatePositions(lists);
      },
    );
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
      child: _listCard(listEntry, index),
    );
  }

  Card _listCard(ListEntry listEntry, int index) {
    return Card(
      child: ListTile(
        title: Text(listEntry.name),
        subtitle:
            listEntry.description != null ? Text(listEntry.description!) : null,
        onTap: () {
          Navigator.of(context)
              .push(
                MaterialPageRoute(
                    builder: (context) => ListPage(
                          key: Key(listEntry.id),
                          listEntry: listEntry,
                        )),
              )
              .then((_) => setState(() {}));
        },
        leading: ReorderableDragStartListener(
          index: index,
          child: const Icon(Icons.drag_handle),
        ),
        trailing: Text(
          listEntry.entries.length.toString(),
        ),
        onLongPress: () => _editItem(index),
      ),
    );
  }

  AlertDialog _deleteConfirmDialog(BuildContext buildContext, ListEntry list) {
    return AlertDialog(
      title: Text(_appLocalization.confirm),
      content: Text(_appLocalization.confirmDeleteList(list.name)),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(buildContext, false);
          },
          child: Text(_appLocalization.cancel),
        ),
        TextButton(
          onPressed: () async {
            list.delete();
            var lists = _databaseProvider!.getLists();
            await updatePositions(lists);
            setState(() {});
            Navigator.pop(buildContext, true);
          },
          style: TextButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          child: Text(_appLocalization.delete),
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
    _newListNameController.clear();
    _newListDescriptionController.clear();
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
                    textCapitalization: TextCapitalization.sentences,
                    decoration:
                        InputDecoration(labelText: _appLocalization.name),
                    controller: _newListNameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return _appLocalization.errorNameNotGiven; //Will never be shown
                      }
                      return null;
                    },
                    onFieldSubmitted: (_) {
                      _validateAndAdd(buildContext);
                    },
                  ),
                  TextFormField(
                    autofocus: true,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(labelText: _appLocalization.description),
                    controller: _newListDescriptionController,
                    validator: (value) {
                      return null;
                    },
                    onFieldSubmitted: (_) {
                      _validateAndAdd(buildContext);
                    },
                  ),
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                          minWidth: double.infinity, minHeight: 30),
                      child: ElevatedButton(
                          child: Text(_appLocalization.addNewList),
                          onPressed: () {
                            _validateAndAdd(buildContext);
                          }),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).then((value) {
      _newListFormKey.currentState!.reset();
    });
  }

  void _validateAndAdd(buildContext) {
    if (_newListFormKey.currentState!.validate()) {
      _databaseProvider!
          .addList(
              _newListNameController.text,
              _newListDescriptionController.text.isNotEmpty
                  ? _newListDescriptionController.text
                  : null)
          .then((v) => setState(() {}));
    }
    Navigator.pop(buildContext);
  }

  void _editItem(int index) {
    var item = _lists.elementAt(index);
    _newListNameController.clear();
    _newListDescriptionController.clear();
    _newListNameController.text = item.name;
    _newListDescriptionController.text = item.description ?? "";
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
                    textCapitalization: TextCapitalization.sentences,
                    decoration:
                        InputDecoration(labelText: _appLocalization.name),
                    controller: _newListNameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return _appLocalization.errorNameNotGiven; //Will never be shown
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) {
                      _validateAndEdit(buildContext, item);
                    },
                  ),
                  TextFormField(
                    autofocus: true,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(labelText: _appLocalization.description),
                    controller: _newListDescriptionController,
                    validator: (value) {
                      return null;
                    },
                    onFieldSubmitted: (_) {
                      _validateAndAdd(buildContext);
                    },
                  ),
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                          minWidth: double.infinity, minHeight: 30),
                      child: ElevatedButton(
                          child: Text(_appLocalization.saveChanges),
                          onPressed: () {
                            _validateAndEdit(buildContext, item);
                          }),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).then((value) => _newListFormKey.currentState!.reset());
  }

  void _validateAndEdit(BuildContext buildContext, ListEntry item) {
    if (_newListFormKey.currentState!.validate()) {
      item.name = _newListNameController.text;
      item.description = _newListDescriptionController.text.isNotEmpty
          ? _newListDescriptionController.text
          : null;
      item.save().then((v) {
        setState(() {});
        Navigator.pop(buildContext);
      });
    }
  }
}
