import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class AppointmentService {
  final BuildContext context;
  // ignore: deprecated_member_use
  final DatabaseReference databaseReference = FirebaseDatabase.instance.reference();
  
  AppointmentService(this.context);

  Future<void> saveToFirebaseAndShowPopup({
    required String date,
    required String time,
    required String firstName,
    required String lastName,
  }) async {
    CollectionReference appointments = FirebaseFirestore.instance.collection('appointments');

    // Saving to Firebase
    DocumentReference docRef = await appointments.add({
      'date': date,
      'time': time,
      'first_name': firstName,
      'last_name': lastName,
    });

    // Fetching the saved data (for assurance)
    DocumentSnapshot savedData = await docRef.get();

    // Displaying the saved data in a popup
    // ignore: use_build_context_synchronously
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      title: 'ยืนยันการนัดหมาย',
      desc: 'คุณ ${savedData['first_name']} ${savedData['last_name']}\n วันที่: ${savedData['date']} \n เวลา: ${savedData['time']} ',
      btnOkOnPress: () {},
    ).show();
  }


}