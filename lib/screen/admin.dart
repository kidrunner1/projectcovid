import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tracker_covid_v1/model/users.dart';

class AdminScreen extends StatefulWidget {
  final Users user;
  AdminScreen({super.key, required this.user});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  @override
  Users user = Users();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = widget.user;
    // getUSer();
  }

  void getUSer() async {
    final auth = FirebaseAuth.instance;
    String uid = auth.currentUser!.uid;
    Users? tempData = await Users.getUser(uid);
    if (tempData != null) {
      setState(() {
        user = tempData;
      });
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin"),
      ),
      body: Center(
        child: Text("${user.firstName} ${user.lastName}"),
      ),
    );
  }
}
