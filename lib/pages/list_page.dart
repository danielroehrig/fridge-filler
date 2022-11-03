import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fridge_filler/models/list_model.dart';

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
  @override
  Widget build(BuildContext context) {
    _listEntry = widget.listEntry;
    _appLocalization = AppLocalizations.of(context)!;
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
            subtitle: Text(entry.amount ?? ""),
          ),
        );
      },
      itemCount: _listEntry.entries.length,
    );
  }

  void _addItem() {
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
                    decoration:
                        InputDecoration(labelText: _appLocalization.name),
                    controller: _newEntryNameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'A name is needed'; //Will never be shown
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    autofocus: true,
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
                          child: Text(_appLocalization.addItemToList),
                          onPressed: () {
                            _listEntry.entries.add(ItemEntry(
                                name: _newEntryNameController.text,
                                amount:
                                    _newEntryAmountController.text.isNotEmpty
                                        ? _newEntryAmountController.text
                                        : null));
                            _listEntry.save().then((v) {
                              setState(() {});
                              Navigator.pop(buildContext);
                            });
                          }),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).then((value) => _newEntryFormKey.currentState!.reset());
  }
}
