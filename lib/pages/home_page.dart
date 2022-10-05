import 'package:flutter/material.dart';
import 'package:multi_shop_list/models/list_model.dart';
import 'package:multi_shop_list/pages/list_page.dart';
import 'package:multi_shop_list/provider/database_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DatabaseProvider? _databaseProvider;
  @override
  Widget build(BuildContext context) {
    _databaseProvider = DatabaseProvider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Multi Shop List"),
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
    return FutureBuilder<List<ListEntry>>(
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return const Text('Error');
          } else if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return _listEntryItem(snapshot, index, context);
                });
          } else {
            return const Text('Empty data');
          }
        } else {
          return Text('State: ${snapshot.connectionState}');
        }
      },
      future: _databaseProvider!.getLists(),
    );
  }

  Dismissible _listEntryItem(AsyncSnapshot<List<ListEntry>> snapshot, int index,
      BuildContext context) {
    ListEntry listEntry = snapshot.data![index];
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
              //TODO use the listEntry directly
              return _deleteConfirmDialog(buildContext, snapshot, index);
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

  AlertDialog _deleteConfirmDialog(BuildContext buildContext,
      AsyncSnapshot<List<ListEntry>> snapshot, int index) {
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
            //TODO deleteList might not be necessary as a simple delete() might suffice
            _databaseProvider!.deleteList(snapshot.data![index].id);
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
    showDialog(
        context: context,
        builder: (BuildContext buildContext) {
          return AlertDialog(
            icon: const Icon(Icons.list),
            title: const Text('Add new list'),
            content: TextField(
              onSubmitted: (listName) {
                if (listName != "") {
                  _databaseProvider!
                      .addList(listName)
                      .then((v) => setState(() {}));
                }
                Navigator.pop(buildContext);
              },
            ),
          );
        });
  }
}
