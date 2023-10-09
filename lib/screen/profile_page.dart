import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tracker_covid_v1/screen/profile_edit_page.dart';

class ProfileScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50], // Lighter background
      body: Center(
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(_auth.currentUser?.uid)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text("Something went wrong");
            }
            if (snapshot.connectionState == ConnectionState.active) {
              Map<String, dynamic>? data =
                  snapshot.data?.data() as Map<String, dynamic>?;
              return ProfileBox(data: data);
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}

class ProfileBox extends StatefulWidget {
  final Map<String, dynamic>? data;

  ProfileBox({this.data});

  @override
  _ProfileBoxState createState() => _ProfileBoxState();
}

class _ProfileBoxState extends State<ProfileBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(begin: Offset(0, -0.1), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String? photoURL = widget.data?['photoURL'];
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.85,
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, Colors.white],
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage:
                      (photoURL != null) ? NetworkImage(photoURL) : null,
                  child: (photoURL == null)
                      ? Icon(Icons.person, size: 70, color: Colors.grey[400])
                      : null,
                ),
                const SizedBox(height: 20),
                Text(
                  "${widget.data?['firstName']} ${widget.data?['lastName']}",
                  style: GoogleFonts.prompt(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                    shadows: [
                      Shadow(
                        blurRadius: 2,
                        color: Colors.grey,
                        offset: Offset(1, 1),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "รายละเอียดข้อมูล",
                  style: GoogleFonts.prompt(
                      fontWeight: FontWeight.w300, color: Colors.grey),
                ),
                const SizedBox(height: 20),
                infoRow(FontAwesomeIcons.envelope, widget.data?['email']),
                const SizedBox(height: 20),
                infoRow(FontAwesomeIcons.phone, widget.data?['phoneNumber']),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditProfileScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    backgroundColor: Colors.red[300],
                  ),
                  child: Text(
                    'แก้ไขข้อมูล',
                    style: GoogleFonts.prompt(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      shadows: [
                        const Shadow(
                          blurRadius: 2,
                          color: Colors.grey,
                          offset: Offset(1, 1),
                        )
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

  Widget infoRow(IconData icon, String? info) {
    return Row(
      children: [
        Icon(icon, color: Colors.red[300], size: 24),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            "${info ?? 'ไม่มีข้อมูล'}",
            style: GoogleFonts.prompt(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: Colors.grey[600],
              shadows: [
                Shadow(
                  blurRadius: 2,
                  color: Colors.grey,
                  offset: Offset(1, 1),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
