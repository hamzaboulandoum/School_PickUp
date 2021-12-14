import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shcool_bus/Screens/chat_page.dart';
import 'package:e_shcool_bus/Screens/map_page.dart';
import 'package:e_shcool_bus/Screens/notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:flutter/services.dart';

// ignore: use_key_in_widget_constructors
class HomePage extends StatefulWidget {
  // here we create a snapshot of the collection users
  final Function(User?) onSignOut;
  // ignore: use_key_in_widget_constructors
  const HomePage({required this.onSignOut, Key? key}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //getting the current firebase user id
  User? currentUser = FirebaseAuth.instance.currentUser;
  late String currentUserId = currentUser!.uid;

  //Pages Variables
  final screens = [
    const Notifications(),
    //MapScreen(),
    const MapTemporary(),
    const Chat_Page(),
  ];

  //UI Variables
  int currentIndex = 0;

  // This is how get the data of the user from the database.
  final Stream<QuerySnapshot> users =
      FirebaseFirestore.instance.collection('users').snapshots();

  // Here We Do our tests we must understand clearly the firebase console

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

  Widget navigationdrawerwidget() {
    return SafeArea(
      child: Drawer(
        child: AnnotatedRegion<SystemUiOverlayStyle>(
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
                  child: sideBar(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget sideBar() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 60),
          Row(
            children: [
              const Expanded(
                child: Text(
                  "Nom:",
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  currentUserId,
                  style: const TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                child: buildLogOutBtn(),
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: navigationdrawerwidget(),
      appBar: AppBar(
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
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Colors.green,
        iconSize: 25,
        showUnselectedLabels: false,
        onTap: (index) => setState(
          () {
            //it informs all the tree that the index was updated
            currentIndex = index;
          },
        ),
        currentIndex: currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label:
                'Notifications', // it is necessary to add a label inside this widget
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.maps_home_work),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
        ],
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
