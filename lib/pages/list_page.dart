import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fridge_filler/models/list_model.dart';
import 'package:fridge_filler/models/reorderable.dart';

class ListPage extends StatefulWidget {
  final ListEntry listEntry;

  const ListPage({Key? key, required this.listEntry}) : super(key: key);

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  late ListEntry _listEntry;
  final _newEntryFormKey = GlobalKey<FormState>();
  late AppLocalizations _appLocalization;
  final _newEntryNameController = TextEditingController();
  final _newEntryAmountController = TextEditingController();
  late double _deviceWidth, _deviceHeight;
  @override
  Widget build(BuildContext context) {
    _listEntry = widget.listEntry;
    _appLocalization = AppLocalizations.of(context)!;
    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(_listEntry.name),
        actions: [
          IconButton(
            onPressed: () {
              _listEntry.entries.removeWhere((item) => item.done);
              _listEntry.save();
              setState(() {});
            },
            icon: const Icon(Icons.delete_sweep),
            tooltip: 'Delete completed items',
          ),
        ],
      ),
      body: _listEntry.entries.length > 0
          ? _showEntries()
          : _showEmptyList(context),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          _addItem();
        },
      ),
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
          Text(_appLocalization.addSomeItems),
        ],
      ),
    );
  }

  Widget _showEntries() {
    return ReorderableListView.builder(
      itemBuilder: (context, index) {
        ItemEntry entry = _listEntry.entries[index];
        return _listItem(index, entry);
      },
      onReorder: (int oldIndex, int newIndex) async {
        if (oldIndex < newIndex) {
          newIndex -= 1;
        }
        final ItemEntry movedList = _listEntry.entries.removeAt(oldIndex);
        _listEntry.entries.insert(newIndex, movedList);
        await updatePositions(_listEntry.entries);
        _listEntry.save();
      },
      itemCount: _listEntry.entries.length,
    );
  }

  Dismissible _listItem(int index, ItemEntry entry) {
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
        setState(() {});
      },
      key: Key(entry.id),
      child: Card(
        child: ListTile(
          onTap: () {
            entry.done = !entry.done;
            _listEntry.save();
            setState(() {});
          },
          title: Text(
            entry.name,
            style: entry.done
                ? const TextStyle(
                    decoration: TextDecoration.lineThrough,
                    color: Colors.grey,
                  )
                : null,
          ),
          leading: ReorderableDragStartListener(
            index: index,
            child:
                Icon(Icons.drag_handle, color: entry.done ? Colors.grey : null),
          ),
          trailing: entry.amount != null
              ? Text(
                  entry.amount!,
                  style: entry.done
                      ? const TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey,
                        )
                      : null,
                )
              : null,
          onLongPress: () => _editItem(index),
        ),
      ),
    );
  }

  void _addItem() {
    _newEntryNameController.clear();
    _newEntryAmountController.clear();
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
              key: _newEntryFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    autofocus: true,
                    textCapitalization: TextCapitalization.sentences,
                    decoration:
                        InputDecoration(labelText: _appLocalization.name),
                    controller: _newEntryNameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return _appLocalization.errorNameNotGiven;
                      }
                      if (_entryAlreadyExists(value)) {
                        return _appLocalization.errorDuplicateEntry;
                      }
                      return null;
                    },
                    onFieldSubmitted: (_) {
                      _validateAndAdd(buildContext);
                    },
                    onChanged: (_) => _newEntryFormKey.currentState!.validate(),
                  ),
                  TextFormField(
                    autofocus: true,
                    textCapitalization: TextCapitalization.sentences,
                    decoration:
                        InputDecoration(labelText: _appLocalization.amount),
                    controller: _newEntryAmountController,
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
                          child: Text(_appLocalization.addItemToList),
                          onPressed: () {
                            _validateAndAdd(buildContext);
                          }),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).then((value) => _newEntryFormKey.currentState!.reset());
  }

  bool _entryAlreadyExists(String value) {
    return _listEntry.entries.any(
        (item) => item.name.toLowerCase().trim() == value.toLowerCase().trim());
  }

  void _editItem(int index) {
    var item = _listEntry.entries.elementAt(index);
    _newEntryNameController.clear();
    _newEntryAmountController.clear();
    _newEntryNameController.text = item.name;
    _newEntryAmountController.text = item.amount ?? "";
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
              key: _newEntryFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    autofocus: true,
                    textCapitalization: TextCapitalization.sentences,
                    decoration:
                        InputDecoration(labelText: _appLocalization.name),
                    controller: _newEntryNameController,
                    onChanged: (_) => _newEntryFormKey.currentState!.validate(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return _appLocalization.errorNameNotGiven;
                      }
                      if (_entryAlreadyExists(value)) {
                        return _appLocalization.errorDuplicateEntry;
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    autofocus: true,
                    textCapitalization: TextCapitalization.sentences,
                    decoration:
                        InputDecoration(labelText: _appLocalization.amount),
                    controller: _newEntryAmountController,
                    validator: (value) {
                      return null;
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
        }).then((value) => _newEntryFormKey.currentState!.reset());
  }

  void _validateAndAdd(buildContext) {
    if (_newEntryFormKey.currentState!.validate()) {
      _listEntry.entries.add(
        ItemEntry(
            name: _newEntryNameController.text,
            amount: _newEntryAmountController.text.isNotEmpty
                ? _newEntryAmountController.text
                : null,
            done: false),
      );
      _listEntry.save().then((v) {
        setState(() {});
      });
    }
    Navigator.pop(buildContext);
  }

  void _validateAndEdit(buildContext, ItemEntry item) {
    if (_newEntryFormKey.currentState!.validate()) {
      item.name = _newEntryNameController.text;
      item.amount = _newEntryAmountController.text.isNotEmpty
          ? _newEntryAmountController.text
          : null;
      _listEntry.save().then((v) {
        setState(() {});
        Navigator.pop(buildContext);
      });
    }
  }
}
