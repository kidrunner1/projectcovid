import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:form_field_validator/form_field_validator.dart';

import 'package:tracker_covid_v1/screen/home.dart';
import 'package:tracker_covid_v1/screen/login.dart';
import 'package:tracker_covid_v1/screen/map.dart';
import 'package:tracker_covid_v1/theme/colors.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseAuth_auth = FirebaseAuth.instance;

// ignore: must_be_immutable
class WelcomeScreen extends StatelessWidget {
  // ignore: non_constant_identifier_names
  String _email = '';
  WelcomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ยินดีต้อนรับ'),
      ),
    );
  }
}
