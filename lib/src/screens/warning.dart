import 'package:flutter/material.dart';

class warningScreen extends StatelessWidget {
  const warningScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green, 
        title: const Text('警告'),
      ),
      body: const Center(
          child: Text('警告画面', style: TextStyle(fontSize: 32.0))),
    );
  }
}