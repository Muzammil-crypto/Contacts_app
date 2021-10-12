import 'package:contact_app/interfaces/AddNotes.dart';
import 'package:contact_app/interfaces/EditNotes.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class Contacts extends StatefulWidget {
  @override
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  TextEditingController searchController = new TextEditingController();
  Query _ref;
  DatabaseReference reference =
      FirebaseDatabase.instance.reference().child('Contacts');
  @override
  void initState() {
    super.initState();
    _ref = FirebaseDatabase.instance
        .reference()
        .child('Contacts')
        .orderByChild('name');
  }

  Widget _buildContectItem(Map contact) {
    Color typeColor = getTypeColor(contact['type']);
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8.0, top: 8),
      child: SingleChildScrollView(
        child: Container(
          height: 200,
          child: Card(
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            color: Colors.white,
            elevation: 10,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(Icons.title_outlined,
                          color: Theme.of(context).primaryColor, size: 28),
                      SizedBox(
                        width: 6,
                      ),
                      Text(
                        contact['name'],
                        style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(Icons.description_rounded,
                          color: Theme.of(context).primaryColor, size: 20),
                      SizedBox(
                        width: 6,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Flexible(
                        child: Text(
                          contact['number'],
                          style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).hintColor,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Icon(Icons.group, color: typeColor),
                      SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        contact['type'],
                        style: TextStyle(
                            fontSize: 16,
                            color: typeColor,
                            fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditContacts(
                                contactKey: contact['key'],
                              ),
                            ));
                      },
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 15.0, top: 18),
                          child: Row(
                            children: [
                              Icon(
                                Icons.edit,
                                color: Theme.of(context).primaryColor,
                              ),
                              SizedBox(
                                width: 6,
                              ),
                              Text(
                                'Edit',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Theme.of(context).hintColor,
                                    fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                width: 6,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _showDeleteDialog(contact: contact);
                      },
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 18.0, top: 15),
                          child: Row(
                            children: [
                              Icon(
                                Icons.delete,
                                color: Theme.of(context).primaryColor,
                              ),
                              SizedBox(
                                width: 6,
                              ),
                              Text(
                                'Delete',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Theme.of(context).hintColor,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _showDeleteDialog({Map contact}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Delete ${contact['name']}'),
            content: Text('Are you sure?'),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancel"),
              ),
              FlatButton(
                onPressed: () {
                  reference
                      .child(contact['key'])
                      .remove()
                      .whenComplete(() => Navigator.pop(context));
                },
                child: Text("Delete"),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "My Notes",
              style: TextStyle(color: Colors.white, fontSize: 20.0),
            ),
            SizedBox(
              height: 2,
            ),
            Text(
              "Social Notes Card",
              style: TextStyle(color: Colors.white, fontSize: 12.0),
            )
          ],
        ),
      ),
      body: Container(
        height: double.infinity,
        child: FirebaseAnimatedList(
          query: _ref,
          itemBuilder: (BuildContext context, DataSnapshot snapshot,
              Animation<double> animation, int index) {
            Map contact = snapshot.value;
            contact['key'] = snapshot.key;
            return _buildContectItem(contact);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) {
                return AddContacts();
              },
            ),
          );
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  Color getTypeColor(String type) {
    Color color = Theme.of(context).primaryColor;
    if (type == 'Event') {
      color = Colors.blueGrey;
    }
    if (type == 'Family') {
      color = Colors.blueGrey;
    }
    if (type == 'Friends') {
      color = Colors.blueGrey;
    }
    return color;
  }
}
