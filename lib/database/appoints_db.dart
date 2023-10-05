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
    required String hospital,
  }) async {
    CollectionReference getdata = firestore.collection('appointments');
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        title: 'Error',
        desc: 'User is not logged in.',
      ).show();
      return;
    }

    DocumentSnapshot userDoc =
        await firestore.collection('users').doc(userId).get();
    final data = userDoc.data() as Map<String, dynamic>?;
    final firstName = data?['firstName'];
    final lastName = data?['lastName'];
    final phoneNumber = data?['phoneNumber'];

    try {
      DocumentReference docRef = await getdata.add({
        'date': date,
        'time': time,
        'userID': userId,
        'hospital': hospital,
      });

      DocumentSnapshot savedData = await docRef.get();

      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        title: 'ยืนยันการนัดหมาย',
        desc:
            ' วันที่: ${savedData['date']} \n เวลา: ${savedData['time']} \n สถานที่: ${savedData['hospital']} \n ชื่อ: $firstName $lastName \n เบอร์โทร: $phoneNumber',
        btnCancelOnPress: resetForm,
        btnCancelText: 'ปิด',
        btnOkText: 'แสดงรายละเอียด',
        btnOkOnPress: () {
          navigateToShowDetails({
            'date': savedData['date'],
            'time': savedData['time'],
            'hospital': savedData['hospital'],
            'firstName': firstName,
            'lastName': lastName,
            'phoneNumber': phoneNumber,
            'userID': userId, // ensure this line is there
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
