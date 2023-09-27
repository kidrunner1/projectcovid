import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tracker_covid_v1/screen/login_screen.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class NavigationAdmin extends StatefulWidget {
  NavigationAdmin({super.key});

  @override
  State<NavigationAdmin> createState() => _NavigatorScreenState();
}

class _NavigatorScreenState extends State<NavigationAdmin> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(_auth.currentUser?.uid)
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError) {
                return ListTile(title: Text("Something went wrong"));
              }

              if (snapshot.connectionState == ConnectionState.active &&
                  snapshot.hasData) {
                Map<String, dynamic>? data =
                    snapshot.data?.data() as Map<String, dynamic>?;

                return DrawerHeader(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.red[200]!, Colors.red[400]!],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Text(
                    '${data?['firstName'] ?? ''} ${data?['lastName'] ?? ''}',
                    style:
                        GoogleFonts.prompt(fontSize: 20, color: Colors.white),
                  ),
                );
              }

              return const Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              );
            },
          ),
          ListTile(
            leading: const Icon(
              FontAwesomeIcons.signOut,
              color: Colors.black,
            ),
            title: Text(
              'ออกจากระบบ',
              style: GoogleFonts.prompt(),
            ),
            onTap: () async {
              try {
                await _auth.signOut();
                // ignore: use_build_context_synchronously
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              } catch (e) {
                // Show an error message to the user
              }
            },
          )
        ],
      ),
    );
  }
}
