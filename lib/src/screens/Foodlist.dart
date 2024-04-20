import 'package:flutter/material.dart';
import 'Food Entry.dart'; // FoodEntry クラスが定義されているファイルのインポートを追加

class FoodlistScreen extends StatelessWidget {
  const FoodlistScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('食べた食品一覧'),
        backgroundColor: Colors.green, // 上の帯の色を緑色に設定
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // プラスボタンが押されたときの処理
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FoodEntry()), // FoodEntry 画面に遷移
              );
            },
          ),
        ],
      ),
      body: const Center(child: Text('食べた食品一覧', style: TextStyle(fontSize: 32.0))),
    );
  }
}
