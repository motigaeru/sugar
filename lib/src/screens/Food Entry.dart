import 'package:flutter/material.dart';

class FoodEntry extends StatefulWidget {
  const FoodEntry({super.key});

  @override
  _FoodEntryState createState() => _FoodEntryState();
}

class _FoodEntryState extends State<FoodEntry> {
  String _foodName = '';
  String _calories = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('食品入力'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              onChanged: (value) {
                setState(() {
                  _foodName = value;
                });
              },
              decoration: const InputDecoration(
                labelText: '食品名',
              ),
            ),
            const SizedBox(height: 20.0),
            TextField(
              onChanged: (value) {
                setState(() {
                  _calories = value;
                });
              },
              decoration: const InputDecoration(
                labelText: '糖分',
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // ここで入力された食品名とカロリーを処理する
                print('食品名: $_foodName');
                print('糖分: $_calories');
                // 例えば、データベースに保存したり、他の処理を実行したりすることができます
              },
              child: const Text('保存'),
            ),
          ],
        ),
      ),
    );
  }
}
