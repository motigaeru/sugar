import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'food_provider.dart';
import 'FoodEntry.dart';

final imbalanceProvider = Provider<String>((ref) {
  final foodList = ref.watch(foodProvider);
  final Map<int, int> categoryCounts = {};
  for (var food in foodList) {
    categoryCounts[food.category] = (categoryCounts[food.category] ?? 0) + 1;
  }

  final int maxCount = categoryCounts.values.reduce((a, b) => a > b ? a : b);
  final int minCount = categoryCounts.values.reduce((a, b) => a < b ? a : b);

  if (maxCount > minCount + 5) {  // Adjust the threshold as needed
    return '特定のカテゴリーが他のカテゴリーより多くなっています。';
  } else {
    return 'カテゴリーのバランスは正常です。';
  }
});

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const RiverpodSample(),
    );
  }
}

class RiverpodSample extends ConsumerWidget {
  const RiverpodSample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imbalanceMessage = ref.watch(imbalanceProvider);
    final foodList = ref.watch(foodProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('ホーム'),
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            alignment: Alignment.center,
            color: Colors.white,
            child: Text(
              imbalanceMessage,
              style: const TextStyle(fontSize: 24, color: Colors.red),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: foodList.length,
              itemBuilder: (context, index) {
                final food = foodList[index];
                return ListTile(
                  leading: food.image.isNotEmpty
                      ? Image.file(File(food.image), width: 50, height: 50, fit: BoxFit.cover)
                      : Icon(Icons.image, size: 50, color: Colors.grey),
                  title: Text(food.name),
                  subtitle: Text(_categoryToString(food.category)),
                  onLongPress: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('削除の確認'),
                        content: Text('${food.name} を削除しますか？'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('キャンセル'),
                          ),
                          TextButton(
                            onPressed: () {
                              ref.read(foodProvider.notifier).removeFood(index);
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
          ),
        ],
      ),
    );
  }

  String _categoryToString(int category) {
    switch (category) {
      case 0:
        return '野菜';
      case 1:
        return '肉';
      case 2:
        return '魚';
      case 3:
        return 'その他';
      default:
        return '不明';
    }
  }
}
