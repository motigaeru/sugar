import 'package:flutter/material.dart';
import 'Food Entry.dart'; 
import 'package:flutter_riverpod/flutter_riverpod.dart';

final foodword = StateProvider((ref) {
  return 'リンゴ';
});
class FoodlistScreen extends StatefulWidget {
  const FoodlistScreen({Key? key}) : super(key: key);

  @override
  _FoodlistScreenState createState() => _FoodlistScreenState();
}

class riverpodcl extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String value = ref.watch(foodword);

    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text(value),
        ),
      ),
    );
  }
}

class _FoodlistScreenState extends State<FoodlistScreen> {
  
  var food = [];

  @override
  Widget build(BuildContext context, ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('食べた食品一覧'),
        backgroundColor: Colors.green, // 上の帯の色を緑色に設定
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              // プラスボタンが押されたときの処理
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FoodEntry()), // FoodEntry 画面に遷移
              );

              if (result != null) {
                // 追加された食品名がある場合のみリストに追加する
                setState(() {
                  food.add(result);
                });
              }
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: food.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(food[index]),
            // 長押ししたときの処理を追加
            onLongPress: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('削除の確認'),
                  content: Text('${food[index]} を削除しますか？'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        // ダイアログを閉じる
                        Navigator.of(context).pop();
                      },
                      child: Text('キャンセル'),
                    ),
                    TextButton(
                      onPressed: () {
                        // リストから要素を削除
                        setState(() {
                          food.removeAt(index);
                        });
                        // ダイアログを閉じる
                        Navigator.of(context).pop();
                      },
                      child: Text('削除'),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}



