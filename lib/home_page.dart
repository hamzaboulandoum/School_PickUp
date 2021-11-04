import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:flutter/services.dart';

// ignore: use_key_in_widget_constructors
class HomePage extends StatefulWidget {
  // here we create a snapshot of the collection users
  final Function(User?) onSignOut;
  // ignore: use_key_in_widget_constructors
  const HomePage({required this.onSignOut});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // This is how we add the data to the Database
  final Stream<QuerySnapshot> users =
      FirebaseFirestore.instance.collection('users').snapshots();

// Future Logout
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    widget.onSignOut(null);
  }

  Widget buildLogOutBtn() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25),
      width: 100,
      child: ElevatedButton(
        onPressed: () {
          logout();
        },
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
          padding:
              MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(15)),
          elevation: MaterialStateProperty.all<double>(10),
          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
          overlayColor: MaterialStateProperty.resolveWith(
            (states) {
              return states.contains(MaterialState.pressed)
                  ? Colors.black12
                  : null;
            },
          ),
        ),

        child: const Text(
          'Log Out',
          style: TextStyle(
            color: Color(0xff5ac18e),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        // ignore: prefer_const_constructors
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(
          Icons.menu_rounded,
          size: 50,
        ),
        backgroundColor: const Color(0x665ac18e),
        title: const Text(
          'MapsPluginPage',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
      ),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0x665ac18e),
                      Color(0x995ac18e),
                      Color(0xcc5ac18e),
                      Color(0xff5ac18e),
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    buildLogOutBtn(),
                  ],
                ),
                /* child: Container(
                  alignment: Alignment.center,
                  padding:
                      const EdgeInsets.symmetric(vertical: 50, horizontal: 10),
                  color: Colors.black,

                  child: MapSample(),
                ), */

                //We Add The LogoutButton
                /* child: Column(
                  // voila so we have built the column at the end
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    buildLogOutBtn(),
                  ],
                ), */
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* class MyCustomForm extends StatefulWidget {
  const MyCustomForm({Key? key}) : super(key: key);

  @override
  _MyCustomFormState createState() => _MyCustomFormState();
}

class _MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();

  var name = '';
  var age = 0;

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            decoration: const InputDecoration(
              icon: Icon(Icons.person),
              hintText: 'What\'s Your Name?',
              labelText: 'Name', //This label text again is interesting
            ),
            onChanged: (value) {
              name = value;
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some Text';
              }
              return null;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(
              icon: Icon(Icons.date_range),
              hintText: 'What\'s Your Age?',
              labelText: 'Age', //This label text again is interesting
            ),
            onChanged: (value) {
              age = int.parse(value); // cast in dart
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some Text';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          Center(
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Sending Data to Cloud Firestore'),
                    ),
                  );
                  users
                      .add({'name': name, 'Age': age})
                      // ignore: avoid_print
                      .then((value) => print('User Added'))
                      .catchError(
                        // ignore: avoid_print
                        (error) => print('Failed to Add Users $error'),
                      );
                }
              },
              child: const Text('Submit'),
            ),
          )
        ],
      ),
    );
  }
}
 */
// I am actually very proud of you , you are becoming very fast flutter dev
// This is how we get user data from firebase
/*Container(
  height: 250,
  padding: const EdgeInsets.symmetric(vertical: 20),
  child: StreamBuilder<QuerySnapshot>( // This is how you do read the firebase Data
    stream: users,
    builder: (BuildContext context,
        AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.hasError) {
        return const Text('Something Went Wrong');
      }
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Text("Loading");
      }
      final data = snapshot.requireData;
      return ListView.builder(
        itemCount: data.size,
        itemBuilder: (context, index) {
          return Text(
            'My name is ${data.docs[index]['name']} and I am ${data.docs[index]['Age']}',
          );
        },
      );
    },
  ),
),*/
