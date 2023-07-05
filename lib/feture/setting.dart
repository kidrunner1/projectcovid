import 'package:flutter/material.dart';

import 'package:flutter/src/widgets/framework.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: const [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'ก า ร ตั้ ง ค่ า',
                style: TextStyle(fontSize: 24),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
