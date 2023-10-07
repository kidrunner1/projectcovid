import 'package:flutter/material.dart';

class Vaccine_page extends StatelessWidget {
  final UserData userData;

  const Vaccine_page({required this.userData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vaccine Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'User Information:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Name: ${userData.name}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'ID Card: ${userData.idCard}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Phone Number: ${userData.phoneNumber}',
              style: TextStyle(fontSize: 16),
            ),
            // You can add more widgets to display additional information here.
          ],
        ),
      ),
    );
  }
}

class UserData {
  final String name;
  final String idCard;
  final String phoneNumber;

  UserData({
    required this.name,
    required this.idCard,
    required this.phoneNumber,
  });
}
