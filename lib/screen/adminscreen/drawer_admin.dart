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
        padding: EdgeInsets.zero, // Remove any padding from the ListView.
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
                      colors: [Colors.red[300]!, Colors.red[400]!],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(
                          FontAwesomeIcons.userCog,
                          size: 24,
                          color: Colors.red[300],
                        ),
                      ),
                      SizedBox(width: 16),
                      Text(
                        '${data?['firstName'] ?? ''} ${data?['lastName'] ?? ''}',
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
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
              color: Colors.red,
            ),
            title: Text(
              'ออกจากระบบ',
              style: GoogleFonts.prompt(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            onTap: () async {
              try {
                await _auth.signOut();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to sign out!')),
                );
              }
            },
          )
        ],
      ),
    );
  }
}
