import 'package:contact_app/interfaces/contacts.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  TextEditingController searchController = new TextEditingController();
  final Future<FirebaseApp> _fbApp = Firebase.initializeApp();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Contact Keeper",
        theme: ThemeData(
          primaryColor: Colors.blueGrey,
          accentColor: Colors.teal,
        ),
        home: FutureBuilder(
            future: _fbApp,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                print("You have an Error ! ${snapshot.error.toString()}");
                return Text('Something Went Wrong !');
              } else if (snapshot.hasData) {
                return Contacts();
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }));
  }
}
