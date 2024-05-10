import 'package:flutter/material.dart';

class FoodEntry extends StatefulWidget {
  const FoodEntry({Key? key}) : super(key: key);

  @override
  _FoodEntryState createState() => _FoodEntryState();
}

class _FoodEntryState extends State<FoodEntry> {
  String _foodName = '';
  String _imageUrl = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('食品入力'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0), // ボタンの周囲に余白を追加
            child: IconButton(
              onPressed: () {
                // ここで入力された食品名を追加する
                if (_foodName.isNotEmpty) {
                  // 入力された食品名が空でない場合のみ追加する
                  Navigator.pop(context, _foodName); // 入力画面を閉じる
                }
              },
              icon: const Icon(Icons.add), // アイコンをプラスアイコンに変更
              iconSize: 32.0, // アイコンのサイズを大きくする
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0), // 上下左右に20の余白を追加
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '食品名',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        _foodName = value;
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: '食品名を入力してください',
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0), // スペースを追加
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '写真',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  // 灰色の長方形を表示する
                  Container(
                    height: 150, // 画像の高さに応じて調整してください
                    color: Colors.grey[300],
                    alignment: Alignment.center,
                    child: _imageUrl.isNotEmpty
                        ? Image.network(_imageUrl)
                        : Icon(Icons.image, size: 50, color: Colors.grey),
                  ),
                  SizedBox(height: 10), // スペースを追加
                  ElevatedButton(
                    onPressed: () {
                      // ここで画像の選択を処理する
                      // 例えば、画像を選択して _imageUrl を更新する処理を実装することができます
                    },
                    child: Text('写真を選択'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom), // キーボードの高さ分のスペースを追加
          ],
        ),
      ),
    );
  }
}
