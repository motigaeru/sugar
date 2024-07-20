import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'FoodEntry.dart';
import 'food_provider.dart';

class FoodlistScreen extends ConsumerWidget {
  const FoodlistScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final foodList = ref.watch(foodProvider);

    void _showImbalanceAlert() {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('カテゴリーの偏り'),
          content: Text('特定のカテゴリーの項目が他よりも多くなっています。'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }

    ref.listen<List<Food>>(foodProvider, (_, state) {
      final Map<int, int> categoryCounts = {};
      for (var food in state) {
        categoryCounts[food.category] = (categoryCounts[food.category] ?? 0) + 1;
      }

      final int maxCount = categoryCounts.values.reduce((a, b) => a > b ? a : b);
      final int minCount = categoryCounts.values.reduce((a, b) => a < b ? a : b);

      if (maxCount > minCount + 5) {  // 偏りの閾値を 5 としていますが、必要に応じて調整可能
        _showImbalanceAlert();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('食べた食品一覧'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FoodEntry()),
              );

              if (result != null && result is Map<String, dynamic>) {
                final newFood = Food(
                  result['name'],
                  result['image'],
                  result['category'],
                );
                ref.read(foodProvider.notifier).addFood(newFood);
              }
            },
          ),
        ],
      ),
      body: ListView.builder(
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
