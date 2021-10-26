import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:e_shcool_bus/authentication/decision_tree.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

// ignore: use_key_in_widget_constructors
class MyApp extends StatelessWidget {
  //what this does is that it only initializes the firebase app
  final Future<FirebaseApp> _fbApp = Firebase.initializeApp();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FlutterApp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
        // We do also need to configure this splash screen to really be useful
        future: _fbApp,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            // ignore: avoid_print
            print('You have an error !${snapshot.error.toString()}');
            return const Text('Something went wrong');
          } else if (snapshot.hasData) {
            return const DecisionTree();
            //so nothing has changed everything is smooth
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}


/* import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const FireStoreApp());
}

class FireStoreApp extends StatefulWidget {
  const FireStoreApp({Key? key}) : super(key: key);

  @override
  _FireStoreAppState createState() => _FireStoreAppState();
}

class _FireStoreAppState extends State<FireStoreApp> {
  final textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    CollectionReference groceries =
        FirebaseFirestore.instance.collection('groceries');

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: TextField(
            // pay attention to the constant keywords that you add
            controller: textController,
          ),
        ),
        body: Center(
          child: StreamBuilder(
            stream: groceries.orderBy('name').snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: Text("Loading"),
                );
              }
              return ListView(
                // shows items in order as a list
                children: snapshot.data!.docs.map((grocery) {
                  return Center(
                    child: ListTile(
                      title: Text(grocery['name']),
                      onLongPress: () {
                        grocery.reference.delete();
                      },
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.save),
          onPressed: () {
            groceries.add({
              //This is how we add Variables into a Map in Flutter
              'name': textController.text,
            });
            textController.clear();
          },
        ),
      ),
    );
  }
} */
// this is how you code without chrome
