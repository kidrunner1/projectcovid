// ignore_for_file: use_build_context_synchronously

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

      // Update the document with the id
      await docRef.update({'id': docRef.id});

      DocumentSnapshot savedData = await docRef.get();

      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.SCALE,
        headerAnimationLoop: false,
        title: 'ยืนยันการนัดหมาย',
        desc: '',
        btnCancelOnPress: resetForm,
        btnCancelText: 'ปิด',
        btnCancelIcon: Icons.close,
        btnOkText: 'แสดงรายละเอียด',
        btnOkIcon: Icons.check_circle,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            children: [
              Text('วันที่: ${savedData['date']}',
                  style: GoogleFonts.prompt(fontSize: 18)),
              SizedBox(height: 10),
              Text('เวลา: ${savedData['time']}',
                  style: GoogleFonts.prompt(fontSize: 18)),
              SizedBox(height: 10),
              Text('สถานที่: ${savedData['hospital']}',
                  style: GoogleFonts.prompt(fontSize: 18)),
              SizedBox(height: 10),
              Text('ชื่อ: $firstName $lastName',
                  style: GoogleFonts.prompt(fontSize: 18)),
              SizedBox(height: 10),
              Text('เบอร์โทร: $phoneNumber',
                  style: GoogleFonts.prompt(fontSize: 18)),
            ],
          ),
        ),
        btnOkOnPress: () {
          navigateToShowDetails({
            'date': savedData['date'],
            'time': savedData['time'],
            'hospital': savedData['hospital'],
            'firstName': firstName,
            'lastName': lastName,
            'phoneNumber': phoneNumber,
            'userID': userId,
            'id': docRef.id,
          });
        },
      ).show();
    } catch (e) {
      print('Error: $e');
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.SCALE,
        title: 'Error',
        desc: 'There was an error saving the appointment: $e',
        btnOkText: 'ปิด',
        btnOkIcon: Icons.close,
        headerAnimationLoop: false,
        isDense: true,
      ).show();
    }
  }
}
