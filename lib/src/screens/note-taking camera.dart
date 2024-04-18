import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('カメラ'),
      ),
      body:
          const Center(child: Text('カメラ画面', style: TextStyle(fontSize: 32.0))),
    );
  }
}