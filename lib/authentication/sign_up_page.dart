import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'dart:ui';

import 'id_school_user.dart';

// This is actually the Sign Up page i have made a whole page
// for it and we will animate between the both pages to see
// how does that work on flutter maan
class SignUpPage extends StatefulWidget {
  // Dynamic Functions Used
  final Function(bool) loginchanged;
  final Function(String) schoolId;
  final Function(User?) onSignUp;
  //Constructor
  const SignUpPage(
      {required this.loginchanged,
      required this.onSignUp,
      required this.schoolId,
      Key? key})
      : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // here is how we access the collections to write into the database
  final Stream<QuerySnapshot> userData =
      FirebaseFirestore.instance.collection('userData').snapshots();

  // here are some variables that we would need later
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();
  final TextEditingController _schoolName = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _schoolPassword = TextEditingController();
  final TextEditingController _controllerConfirmPassword =
      TextEditingController();

  // here we do add logical Variables
  bool visibility = true;
  bool visibilitySchoolData = false;
  String error = "";
  String firstName = "";
  String lastName = "";
  String emailAdress = "";
  String password = "";
  String confirmPassword = "";
  String schoolName = "";
  String schoolPassword = "";
  String phoneNumber = "";
  GeoPoint location = const GeoPoint(0, 0);
  String address = "";
  bool havegotlocation = false;

  //Create User Future
  Future<void> createUser() async {
    try {
      //we add the user to the authentification
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _controllerEmail.text, password: _controllerPassword.text);

      // ignore: avoid_print
      print(userCredential.user);
      // now we can sign up directly broski
      setState(() {
        visibility = false;
        visibilitySchoolData = true;
        error = "";
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        error = e.message!; // voila this is because of the null safety
      });
    }
  }

  //Adding User To Database
  Future<void> addUserToDB() async {
    //Searching For School with current Password on DB
    var result = await FirebaseFirestore.instance
        .collection("Schools")
        .where("SchoolPassword", isEqualTo: schoolPassword)
        .get();
    if (result.docs.isEmpty) {
      setState(() {
        error = "Mot de passe ou non d'école incorrect";
      });
    } else {
      //Getting The Firebase User
      User? currentUser = FirebaseAuth.instance.currentUser;
      late String currentUserId = currentUser!.uid;
      //here we add our user data to the database
      CollectionReference school =
          FirebaseFirestore.instance.collection('Schools');
      school
          .doc(result.docs.first.id)
          .collection("Parents")
          .doc(currentUserId)
          .set({
            'SchoolName': schoolName,
            'SchoolPassword': schoolPassword,
            'adress': address,
            'email': emailAdress,
            'firstName': firstName,
            'lastName': lastName,
            'location': location,
            'password': password,
            'phoneNumber': phoneNumber
          })
          // ignore: avoid_print
          .then((value) => print("Content Added to database"))
          // ignore: avoid_print
          .catchError((error) => print('Failed to Add UserData $error'));

      //We Go To The Next Page
      widget.schoolId(result.docs.first.id);
      widget.onSignUp(currentUser);
      widget.loginchanged(true);
    }
  }

  //getiing location and adress functions
  getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    //we got our location here
    location = GeoPoint(position.latitude, position.longitude);
    getAddresse(position.latitude, position.longitude);
  }

  getAddresse(var a, var b) async {
    List<Placemark> place = await placemarkFromCoordinates(a, b);
    Placemark placeMark = place[0];
    String? name = placeMark.name;
    String? subLocality = placeMark.subLocality;
    String? locality = placeMark.locality;
    String? administrativeArea = placeMark.administrativeArea;
    String? postalCode = placeMark.postalCode;
    String? country = placeMark.country;
    //We got out adress variable here
    address =
        "$name, $subLocality, $locality, $administrativeArea $postalCode, $country";
  }

  // Essentiel Widgets That Were Used
  Widget buildSchoolName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          "Nom de l'école", //firstname
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          // really important widget to learn
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10), // rounded edges
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),

          height: 60,
          child: TextFormField(
            onChanged: (value) {
              schoolName = value; // cast in dart
            },
            controller: _schoolName,
            keyboardType: TextInputType.name,
            style: const TextStyle(color: Colors.black87),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14),
              prefixIcon: Icon(
                Icons.school,
                color: Color(0xff5ac18e),
              ),
              hintText: "Nom de l'école",
              hintStyle: TextStyle(
                color: Colors.black38,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget buildSchoolPassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          "Mot de passe de l'école",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          // really important widget to learn
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10), // rounded edges
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),

          height: 60,
          child: TextFormField(
            onChanged: (value) {
              schoolPassword = value; // cast in dart
            },
            controller: _schoolPassword,
            obscureText: true,
            style: const TextStyle(
              color: Colors.black87,
            ),
            decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14),
                prefixIcon: Icon(
                  Icons.password,
                  color: Color(0xff5ac18e),
                ),
                hintText: "Mot de passe de l'école",
                hintStyle: TextStyle(
                  color: Colors.black38,
                )),
          ),
        )
      ],
    );
  }

  Widget buildFirstName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Prenom', //firstname
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          // really important widget to learn
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10), // rounded edges
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),

          height: 60,
          child: TextFormField(
            onChanged: (value) {
              firstName = value; // cast in dart
            },
            controller: _firstName,
            keyboardType: TextInputType.name,
            style: const TextStyle(color: Colors.black87),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14),
              prefixIcon: Icon(
                Icons.person,
                color: Color(0xff5ac18e),
              ),
              hintText: 'Prenom',
              hintStyle: TextStyle(
                color: Colors.black38,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget buildLastName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Nom',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          // really important widget to learn
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10), // rounded edges
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),

          height: 60,
          child: TextFormField(
            onChanged: (value) {
              lastName = value; // cast in dart
            },

            // we have Set Up the Text Controller Correctly
            controller: _lastName,
            keyboardType: TextInputType.name,
            style: const TextStyle(color: Colors.black87),
            decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14),
                prefixIcon: Icon(
                  Icons.person,
                  color: Color(0xff5ac18e),
                ),
                hintText: 'Nom',
                hintStyle: TextStyle(
                  color: Colors.black38,
                )),
          ),
        )
      ],
    );
  }

  Widget buildEmail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Email',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          // really important widget to learn
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10), // rounded edges
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),

          height: 60,
          child: TextFormField(
            onChanged: (value) {
              emailAdress = value; // cast in dart
            },
            controller: _controllerEmail,
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(color: Colors.black87),
            decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14),
                prefixIcon: Icon(
                  Icons.email,
                  color: Color(0xff5ac18e),
                ),
                hintText: 'Email',
                hintStyle: TextStyle(
                  color: Colors.black38,
                )),
          ),
        )
      ],
    );
  }

  Widget buildphoneNumber() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Phone Number', //firstname
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10), // rounded edges
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          height: 60,
          child: TextFormField(
            onChanged: (value) {
              phoneNumber = value; // cast in dart
            },
            controller: _phoneNumber,
            keyboardType: TextInputType.phone,
            style: const TextStyle(color: Colors.black87),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14),
              prefixIcon: Icon(
                Icons.phone,
                color: Color(0xff5ac18e),
              ),
              hintText: 'Phone Number',
              hintStyle: TextStyle(
                color: Colors.black38,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget buildPassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Mot de passe',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          // really important widget to learn
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10), // rounded edges
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),

          height: 60,
          child: TextFormField(
            onChanged: (value) {
              password = value; // cast in dart
            },
            controller: _controllerPassword,
            obscureText: true,
            style: const TextStyle(
              color: Colors.black87,
            ),
            decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14),
                prefixIcon: Icon(
                  Icons.lock,
                  color: Color(0xff5ac18e),
                ),
                hintText: 'Mot de passe',
                hintStyle: TextStyle(
                  color: Colors.black38,
                )),
          ),
        )
      ],
    );
  }

  Widget buildConfirmPassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Confirmer mot de passe',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          // really important widget to learn
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10), // rounded edges
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          height: 60,
          child: TextFormField(
            onChanged: (value) {
              confirmPassword = value; // cast in dart
            },
            controller: _controllerConfirmPassword,
            obscureText: true,
            style: const TextStyle(color: Colors.black87),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14),
              prefixIcon: Icon(Icons.lock, color: Color(0xff5ac18e)),
              hintText: 'Confirmer mot de passe',
              hintStyle: TextStyle(color: Colors.black38),
            ),
          ),
        )
      ],
    );
  }

  Widget getLocationButton() {
    return Container(
      padding: const EdgeInsets.only(top: 10),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text(
            'Clicker pour prendre votre position',
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 5),
          ElevatedButton(
            onPressed: () {
              havegotlocation = true;
              getCurrentLocation();
            },
            child: const Icon(
              Icons.location_on_outlined,
              color: Color(0xff5ac18e),
            ),
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(10),
              primary: Colors.white, // <-- Button color
              onPrimary: Colors.green, // <-- Splash color
            ),
          )
        ],
      ),
    );
  }

  Widget buildSignUpBtn() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          //D'abord il fallait verifier les conditions
          if (lastName == "") {
            setState(() {
              error = "vous n'avez pas saisie votre Nom!";
            });
          } else if (emailAdress == "") {
            setState(() {
              error = "vous n'avez pas saisie votre Email!";
            });
          } else if (phoneNumber == "") {
            setState(() {
              error = "vous n'avez pas saisie votre Numero De Telephone!";
            });
          } else if (password == "") {
            setState(() {
              error = "vous n'avez pas saisie votre mot de passe!";
            });
          } else if (password != confirmPassword) {
            setState(() {
              error = "mot de passe différent!";
            });
          } else if (!havegotlocation) {
            setState(() {
              error = "Click The get position button";
            });
          }
          // we first send the data into the server
          else {
            createUser();
          }
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
          'Créer un compte',
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

  Widget buildConnectToSchool() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          //D'abord il fallait verifier les conditions
          if (schoolName == "") {
            setState(() {
              error = "vous n'avez pas saisie le nom de l'école!";
            });
          } else if (schoolPassword == "") {
            setState(() {
              error = "vous n'avez pas saisie le mot  de passe de l'école!";
            });
          }
          // we add the user now to our database
          else {
            addUserToDB();
          }
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
          'Se Connecter',
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

  // Override and build
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        // now you do show that you have learned something brother
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
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 20,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Visibility(
                          visible: visibilitySchoolData,
                          child: const Text(
                            "Saisir l'école",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Visibility(
                          child: const SizedBox(height: 10),
                          visible: visibilitySchoolData,
                        ),
                        Visibility(
                          child: buildSchoolName(),
                          visible: visibilitySchoolData,
                        ),
                        Visibility(
                          child: const SizedBox(height: 10),
                          visible: visibilitySchoolData,
                        ),
                        Visibility(
                          child: buildSchoolPassword(),
                          visible: visibilitySchoolData,
                        ),
                        Visibility(
                          child: const SizedBox(height: 10),
                          visible: visibilitySchoolData,
                        ),
                        Visibility(
                          child: buildConnectToSchool(),
                          visible: visibilitySchoolData,
                        ),
                        Visibility(
                          visible: visibility,
                          child: const Text(
                            'Créer un Compte',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Visibility(
                          child: const SizedBox(height: 10),
                          visible: visibility,
                        ),
                        Visibility(
                          child: buildFirstName(),
                          visible: visibility,
                        ),
                        Visibility(
                          child: const SizedBox(height: 10),
                          visible: visibility,
                        ),
                        Visibility(
                          child: buildLastName(),
                          visible: visibility,
                        ),
                        Visibility(
                          child: const SizedBox(height: 10),
                          visible: visibility,
                        ),
                        Visibility(
                          child: buildEmail(),
                          visible: visibility,
                        ),
                        Visibility(
                          child: const SizedBox(height: 10),
                          visible: visibility,
                        ),
                        Visibility(
                          child: buildphoneNumber(),
                          visible: visibility,
                        ),
                        Visibility(
                          child: const SizedBox(height: 10),
                          visible: visibility,
                        ),
                        Visibility(
                          child: buildPassword(),
                          visible: visibility,
                        ),
                        Visibility(
                          child: const SizedBox(height: 10),
                          visible: visibility,
                        ),
                        Visibility(
                          child: buildConfirmPassword(),
                          visible: visibility,
                        ),
                        Visibility(
                          child: getLocationButton(),
                          visible: visibility,
                        ),
                        Visibility(
                          child: buildSignUpBtn(),
                          visible: visibility,
                        ),
                        Text(
                          error,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
