import 'package:contact_app/interfaces/addContacts.dart';
import 'package:contact_app/interfaces/editContact.dart';
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
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Container(
          height: 82,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.person,
                      color: Theme.of(context).primaryColor, size: 28),
                  SizedBox(
                    width: 6,
                  ),
                  Text(
                    contact['name'],
                    style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w600),
                  )
                ],
              ),
              Row(
                children: [
                  Icon(Icons.phone_iphone,
                      color: Theme.of(context).primaryColor, size: 20),
                  SizedBox(
                    width: 6,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    contact['number'],
                    style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).hintColor,
                        fontWeight: FontWeight.w600),
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
                  GestureDetector(
                    onTap: () {
                      _showDeleteDialog(contact: contact);
                    },
                    child: SingleChildScrollView(
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
                  )
                ],
              ),
            ],
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
            content: Text('Are you sure you want to delete this Contact?'),
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
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "My Contacts",
              style: TextStyle(color: Colors.white, fontSize: 18.0),
            ),
            SizedBox(
              height: 2,
            ),
            Text(
              "Contacts Showing for the current Account",
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
            // return TextField(
            //   controller: searchController,
            //   decoration: InputDecoration(
            //     labelText: 'Search Contact',
            //   ),
            // );
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
    if (type == 'Work') {
      color = Colors.blue;
    }
    if (type == 'Family') {
      color = Colors.teal;
    }
    if (type == 'Friends') {
      color = Colors.blueGrey;
    }
    return color;
  }
}
