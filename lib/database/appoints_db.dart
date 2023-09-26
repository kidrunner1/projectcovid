
// import 'package:awesome_dialog/awesome_dialog.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';

// class AppointmentService {
//   final BuildContext context;
//   final Function(Map<String, dynamic>) navigateToShowDetails;
//   final VoidCallback resetForm;

//   AppointmentService(
//       this.context, this.navigateToShowDetails, this.resetForm);

//   final DatabaseReference databaseReference =
//       FirebaseDatabase.instance.reference();

//   Future<void> saveToFirebaseAndShowPopup({
//     required String date,
//     required String time,
//     required String firstName,
//     required String lastName,
//   }) async {
//     CollectionReference appointments =
//         FirebaseFirestore.instance.collection('appointments');

//     DocumentReference docRef = await appointments.add({
//       'date': date,
//       'time': time,
//       'first_name': firstName,
//       'last_name': lastName,
//     });

//     DocumentSnapshot savedData = await docRef.get();

//     AwesomeDialog(
//       context: context,
//       dialogType: DialogType.success,
//       title: 'ยืนยันการนัดหมาย',
//       desc: 'คุณ ${savedData['first_name']} ${savedData['last_name']}\n วันที่: ${savedData['date']} \n เวลา: ${savedData['time']} ',
//       btnCancelOnPress: resetForm,
//       btnCancelText: 'ปิด',
//       btnOkText: 'แสดงรายละเอียด',
//       btnOkOnPress: () {
//         navigateToShowDetails({
//       'date': savedData['date'],
//       'time': savedData['time'],
//       'first_name': savedData['first_name'],
//       'last_name': savedData['last_name'],
//     });
//       },
//     ).show();
//   }
// }





// ignore_for_file: use_build_context_synchronously

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Appoints_DB{
  final BuildContext context;
  final Function(Map<String, dynamic>) navigateToShowDetails;
  final VoidCallback resetForm;
  final FirebaseFirestore firestore;

 Appoints_DB(this.context, this.navigateToShowDetails, this.resetForm, {required this.firestore});


  Future<void> saveToFirebaseAndShowPopup({
    required String date,
    required String time,
    required String firstName,
    required String lastName, 
  }
  ) async {
    CollectionReference appointments =
        FirebaseFirestore.instance.collection('appointments');

    try {
      DocumentReference docRef = await appointments.add({
        'date': date,
        'time': time,
        'first_name': firstName,
        'last_name': lastName,
      });

      DocumentSnapshot savedData = await docRef.get();

      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        title: 'ยืนยันการนัดหมาย',
        desc: 'คุณ ${savedData['first_name']} ${savedData['last_name']}\n วันที่: ${savedData['date']} \n เวลา: ${savedData['time']} ',
        btnCancelOnPress: resetForm,
        btnCancelText: 'ปิด',
        btnOkText: 'แสดงรายละเอียด',
        btnOkOnPress: () {
          navigateToShowDetails({
            'date': savedData['date'],
            'time': savedData['time'],
            'first_name': savedData['first_name'],
            'last_name': savedData['last_name'],
          });
        },
      ).show();

    } catch (e) {
      print('Error: $e');
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        title: 'Error',
        desc: 'There was an error saving the appointment: $e',
      ).show();
    }
  }

}

