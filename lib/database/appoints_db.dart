// ignore_for_file: use_build_context_synchronously
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Appoints_DB {
  final BuildContext context;
  final Function(Map<String, dynamic>) navigateToShowDetails;
  final VoidCallback resetForm;
  final FirebaseFirestore firestore;

  Appoints_DB(this.context, this.navigateToShowDetails, this.resetForm,
      {required this.firestore});

  Future<void> saveToFirebaseAndShowPopup({
    required String date,
    required String time,
    required String hospital
  }) async {
    CollectionReference getdata =
        FirebaseFirestore.instance.collection('appointments');
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      throw Exception("User ID is null");
    }
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
   final data = userDoc.data() as Map<String, dynamic>?;
final username = data?['username'] ;


    try {
      DocumentReference docRef = await getdata.add({
        'date': date,
        'time': time,
        'userID': FirebaseAuth.instance.currentUser?.uid,
        'username': username,
        'hospital': hospital,
      });

      DocumentSnapshot savedData = await docRef.get();

      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        title:
            'ยืนยันการนัดหมาย',
        desc: ' วันที่: ${savedData['date']} \n เวลา: ${savedData['time']} \n สถานที่: ${savedData['hospital']}',
        btnCancelOnPress: resetForm,
        btnCancelText: 'ปิด',
        btnOkText: 'แสดงรายละเอียด',
        btnOkOnPress: () {
          navigateToShowDetails({
            'date': savedData['date'],
            'time': savedData['time'],
            'hospital': savedData['hospital']
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