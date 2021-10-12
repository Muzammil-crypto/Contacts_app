import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class EditContacts extends StatefulWidget {
  String contactKey;
  EditContacts({this.contactKey});
  @override
  _EditContactsState createState() => _EditContactsState();
}

class _EditContactsState extends State<EditContacts> {
  TextEditingController _nameController, _numberController;
  String _typeSelected = '';
  DatabaseReference _ref;
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _numberController = TextEditingController();
    _ref = FirebaseDatabase.instance.reference().child('Contacts');
    getContactDetails();
  }

  Widget _buildContactType(String title) {
    return InkWell(
      child: Container(
        height: 40,
        width: 90,
        decoration: BoxDecoration(
            color: _typeSelected == title
                ? Colors.blueGrey
                : Theme.of(context).accentColor,
            borderRadius: BorderRadius.circular(15)),
        child: Center(
          child: Text(
            title,
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ),
      onTap: () {
        setState(() {
          _typeSelected = title;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Note"),
      ),
      body: Container(
        margin: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: "Enter Title: ",
                prefixIcon: Icon(
                  Icons.title_outlined,
                  size: 30,
                  color: Colors.blueGrey,
                ),
                fillColor: Colors.white,
                filled: true,
                contentPadding: EdgeInsets.all(15),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: _numberController,
              decoration: InputDecoration(
                hintText: "Enter Description: ",
                prefixIcon: Icon(
                  Icons.description_rounded,
                  size: 30,
                  color: Colors.blueGrey,
                ),
                fillColor: Colors.white,
                filled: true,
                contentPadding: EdgeInsets.all(15),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              height: 40,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildContactType('Event'),
                    SizedBox(width: 3),
                    _buildContactType('Family'),
                    SizedBox(width: 3),
                    _buildContactType('Friends'),
                    SizedBox(width: 3),
                    _buildContactType('Others'),
                    SizedBox(width: 3),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: RaisedButton(
                child: Text(
                  "Save Changes",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
                onPressed: () {
                  saveContact();
                },
                color: Theme.of(context).primaryColor,
              ),
            )
          ],
        ),
      ),
    );
  }

  getContactDetails() async {
    DataSnapshot snapshot = await _ref.child(widget.contactKey).once();
    Map contact = snapshot.value;
    _nameController.text = contact['name'];
    _numberController.text = contact['number'];
    setState(() {
      _typeSelected = contact['type'];
    });
  }

  void saveContact() {
    String name = _nameController.text;
    String number = _numberController.text;
    Map<String, String> contact = {
      'name': name,
      'number': number,
      'type': _typeSelected,
    };
    _ref.child(widget.contactKey).update(contact).then((value) {
      Navigator.pop(context);
    });
  }
}
