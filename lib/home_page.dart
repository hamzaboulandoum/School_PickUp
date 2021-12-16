import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shcool_bus/Screens/chat_page.dart';
import 'package:e_shcool_bus/Screens/notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:flutter/services.dart';

import 'google_maps/polyline.dart';

// ignore: use_key_in_widget_constructors
class HomePage extends StatefulWidget {
  // here we create a snapshot of the collection users
  final Function(User?) onSignOut;
  final String schoolID;
  //easily do as login and add a login variable in order to go back to previous STATE
  // ignore: use_key_in_widget_constructors
  const HomePage({required this.onSignOut, required this.schoolID, Key? key})
      : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // loop variables
  String firstName = "firstName";
  String lastName = "lastName";
  String adress = "adress";
  String phoneNumber = "phoneNumber";
  String schoolName = "SchoolName";
  String email = "email";
  bool breakOfLoop = false;
  bool visibility = false;
  bool once = true;
  //getting the current firebase user id
  User? currentUser = FirebaseAuth.instance.currentUser;
  late String currentUserId = currentUser!.uid;
  String schoolIdFinal = " ";
  String schoolId = " ";

  //Pages Variables
  final screens = [
    const Notifications(),
    MapScreen(),
    //const MapTemporary(),
    const Chat_Page(),
  ];

  //UI Variables
  int currentIndex = 0;

  // This is how get the data of the user from the database.
  final Stream<QuerySnapshot> users =
      FirebaseFirestore.instance.collection('users').snapshots();

  // Future Logout
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    widget.onSignOut(null);
  }

//Fetching Data From Database
  // getting The School Id
  Future<void> getSchoolId() async {
    await FirebaseFirestore.instance.collection('Schools').get().then((value) {
      for (var element in value.docs) {
        FirebaseFirestore.instance
            .collection('Schools')
            .doc(element.id)
            .collection('Parents')
            .get()
            .then((valeur) {
          schoolId = element.id;
          for (var element in valeur.docs) {
            if (element.id == currentUserId) {
              schoolIdFinal = schoolId;
              break;
            }
          }
        });
      }
    });
  }

  // getting The User Data
  Widget getUserData(String title, String subtitle, IconData icon) {
    //getting current user
    User? currentUser = FirebaseAuth.instance.currentUser;
    late String currentUserId = currentUser!.uid;

    //Getting Collection Reference
    CollectionReference parent = FirebaseFirestore.instance
        .collection('Schools')
        .doc(schoolIdFinal) //only thing left is to replace this
        .collection("Parents");

    //returning The Future Builder
    return FutureBuilder<DocumentSnapshot>(
      future: parent.doc(currentUserId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Encoutred an error");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Document Does Not Exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;

          return _tile(title, data[subtitle], icon);
        }
        return const Text("Loading");
      },
    );
  }

  // getting the listtile
  ListTile _tile(String title, String subtitle, IconData icon) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 15,
        ),
      ),
      leading: Icon(
        icon,
        color: Colors.white70,
      ),
    );
  }
// Finished Fetching Data

  //widgets that we will be using
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

  /*Widget buildTestBtn() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25),
      width: 100,
      child: ElevatedButton(
        onPressed: () {
          print(schoolIdFinal);
          /*setState(() {
            visibility = true;
          });*/
          //print(schoolId);
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
          'GetId',
          style: TextStyle(
            color: Color(0xff5ac18e),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        // ignore: prefer_const_constructors
      ),
    );
  }*/

  //the side Bar Structure
  Widget sideBar() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Visibility(
            visible: visibility,
            child: getUserData("Nom :", lastName, Icons.person_add),
          ),
          Visibility(
            visible: visibility,
            child: getUserData("Prenom:", firstName, Icons.person_add),
          ),
          Visibility(
            visible: visibility,
            child: getUserData("Email :", email, Icons.email),
          ),
          Visibility(
            visible: visibility,
            child: getUserData("Adress :", adress, Icons.email),
          ),
          Visibility(
            visible: visibility,
            child: getUserData("School :", schoolName, Icons.school),
          ),
          Visibility(
            visible: visibility,
            child: getUserData("Phone Number :", phoneNumber, Icons.phone),
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
          ),
        ],
      ),
    );
  }

  //Navigation Drawer Widget
  Widget navigationdrawerwidget() {
    getSchoolId();
    return SafeArea(
      child: Drawer(
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: GestureDetector(
            onTap: () {
              if (once) {
                setState(() {
                  visibility = true;
                  once = false;
                });
              }
            },
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

  //build Method
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: navigationdrawerwidget(),
      appBar: AppBar(
        backgroundColor: const Color(0x665ac18e),
        title: const Text(
          'E School Bus',
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
