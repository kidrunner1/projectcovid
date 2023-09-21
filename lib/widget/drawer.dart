import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tracker_covid_v1/screen/profile_page.dart';
import 'package:tracker_covid_v1/feture/setting.dart';
import 'package:tracker_covid_v1/screen/login_screen.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class AppUser {
  final String uid;
  final String firstName;
  final String lastName;
  final String? profileImageUrl;

  AppUser(
      {required this.uid,
      required this.firstName,
      required this.lastName,
      this.profileImageUrl});
}

Future<AppUser?> fetchUserData(String uid) async {
  try {
    DocumentSnapshot doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (doc.exists) {
      var data = doc.data() as Map<String, dynamic>;
      return AppUser(
          uid: uid,
          firstName: data['firstName'] ?? '',
          lastName: data['lastName'] ?? '',
          profileImageUrl: data['profileImageUrl']);
    }
  } catch (error) {
    print('Error fetching user data: $error');
  }
  return null;
}

class NavigatorScreen extends StatefulWidget {
  const NavigatorScreen({Key? key}) : super(key: key);

  @override
  _NavigatorScreenState createState() => _NavigatorScreenState();
}

class _NavigatorScreenState extends State<NavigatorScreen> {
  late Future<AppUser?> fetchUserFuture;

  @override
  void initState() {
    super.initState();
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      fetchUserFuture = fetchUserData(currentUser.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.red[200]!, Colors.red[400]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Text(
                'เมนู',
                style: GoogleFonts.prompt(
                  fontSize: 45,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    const Shadow(
                      blurRadius: 10.0,
                      color: Colors.black26,
                      offset: Offset(2.0, 2.0),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(_auth.currentUser?.uid)
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError) {
                return const ListTile(title: Text("Something went wrong"));
              }

              if (snapshot.connectionState == ConnectionState.active &&
                  snapshot.hasData) {
                Map<String, dynamic>? data =
                    snapshot.data?.data() as Map<String, dynamic>?;

                String? photoURL = data?['photoURL'];

                return Column(
                  children: [
                    if (photoURL != null)
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(photoURL),
                      )
                    else
                      CircleAvatar(
                        radius: 50,
                        child: Icon(Icons.person,
                            size: 70, color: Colors.grey[400]),
                      ),
                    const SizedBox(height: 20),
                    Text(
                      '${data?['firstName'] ?? ''} ${data?['lastName'] ?? ''}',
                      style: GoogleFonts.prompt(
                          fontSize: 20, color: Colors.red[300]),
                    ),
                    const SizedBox(height: 20),
                  ],
                );
              }

              return const Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              );
            },
          ),
          buildMenuItems(context),
        ],
      ),
    );
  }
}

Widget buildMenuItems(BuildContext context) => Container(
    padding: const EdgeInsets.all(24),
    child: Wrap(runSpacing: 16, children: [
      ListTile(
        leading: const Icon(
          FontAwesomeIcons.person,
          color: Colors.black,
        ),
        title: Text('ข้อมูลส่วนตัว', style: GoogleFonts.prompt()),
        onTap: (() {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ProfileScreen(),
          ));
        }),
      ),
      ListTile(
        leading: const Icon(
          FontAwesomeIcons.gear,
          color: Colors.black,
        ),
        title: Text(
          'การตั้งค่า',
          style: GoogleFonts.prompt(),
        ),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => SettingsScreen(),
          ));
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
                  MaterialPageRoute(builder: (context) => const LoginScreen()));
            } catch (e) {
              // Show an error message to the user
            }
          })
    ]));
