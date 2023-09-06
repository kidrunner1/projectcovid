import 'package:flutter/material.dart';

class SyringePage extends StatefulWidget {
  const SyringePage({super.key});

  @override
  State<SyringePage> createState() => _SyringePageState();
}

class _SyringePageState extends State<SyringePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('นั ด ฉี ด วั ค ซี น'),
      ),
    );
  }
}
