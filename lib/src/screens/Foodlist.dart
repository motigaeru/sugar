import 'package:flutter/material.dart';
import 'Food Entry.dart'; // FoodEntry クラスが定義されているファイルのインポートを追加

class FoodlistScreen extends StatelessWidget {
  const FoodlistScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 仮の食品リスト
    List<String> foods = [
      'りんご',
      'バナナ',
      'オレンジ',
      'いちご',
      'ブルーベリー',
    ];

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
      body: ListView.builder(
        itemCount: foods.length * 2 - 1, // アイテムと境界線の数を計算
        itemBuilder: (context, index) {
          if (index.isOdd) {
            // 奇数番目の場合は境界線を返す
            return Divider(
              color: Colors.grey, // 境界線の色を設定
              height: 1, // 境界線の高さを設定
            );
          } else {
            // 偶数番目の場合はリストアイテムを返す
            final itemIndex = index ~/ 2; // リストアイテムのインデックスを計算
            return ListTile(
              title: Text(foods[itemIndex]),
              // タップしたときの処理を追加する場合はここに追記
            );
          }
        },
      ),
    );
  }
}
