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
    final selectedCategory = ref.watch(categoryFilterProvider);

    void _showImbalanceAlert() {
      if (ModalRoute.of(context)!.isCurrent) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('カテゴリーの偏り', style: TextStyle(fontWeight: FontWeight.bold)),
            content: const Text('特定のカテゴリーの項目が他よりも多くなっています。'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK', style: TextStyle(color: Colors.teal)),
              ),
            ],
          ),
        );
      }
    }

    ref.listen<List<Food>>(foodProvider, (_, state) {
      final Map<int, int> categoryCounts = {};
      for (var food in state) {
        categoryCounts[food.category] = (categoryCounts[food.category] ?? 0) + 1;
      }

      if (categoryCounts.isNotEmpty) {
        final int maxCount = categoryCounts.values.reduce((a, b) => a > b ? a : b);
        final int minCount = categoryCounts.values.reduce((a, b) => a < b ? a : b);

        if (maxCount > minCount + 5) {
          _showImbalanceAlert();
        }
      }
    });

    // カテゴリーフィルターに基づいてリストをフィルタリング
    final filteredFoodList = foodList.where((food) {
      if (selectedCategory == 4) return true; // 4 は「すべて表示」
      return food.category == selectedCategory;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('食べた食品一覧'),
        backgroundColor: const Color.fromRGBO(188, 84, 24, 1),
        actions: [
          PopupMenuButton<int>(
            onSelected: (value) {
              ref.read(categoryFilterProvider.notifier).state = value;
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 0, child: Text('野菜のみ')),
              const PopupMenuItem(value: 1, child: Text('肉のみ')),
              const PopupMenuItem(value: 2, child: Text('魚のみ')),
              const PopupMenuItem(value: 3, child: Text('その他のみ')),
              const PopupMenuItem(value: 4, child: Text('すべて表示')),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FoodEntry()),
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
      body: filteredFoodList.isEmpty
          ? const Center(
              child: Text(
                '食品リストは空です',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: filteredFoodList.length,
              itemBuilder: (context, index) {
                final food = filteredFoodList[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  color: _getCategoryColor(food.category), // 色分けを修正
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    leading: _buildLeadingImage(food.image),
                    title: Text(
                      food.name,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white), // テキスト色も変更
                    ),
                    subtitle: Text(
                      _categoryToString(food.category),
                      style: TextStyle(fontSize: 14, color: Colors.white70), // サブテキストも色を変更
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.white), // アイコン色も変更
                      onPressed: () {
                        _showDeleteConfirmation(context, ref, food, index);
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }

  // ホーム画面と同じカテゴリーに基づく色分けを適用
  Color _getCategoryColor(int category) {
    switch (category) {
      case 0:
        return Colors.green; // 野菜
      case 1:
        return Colors.red;   // 肉
      case 2:
        return Colors.blue;  // 魚
      case 3:
        return Colors.orange; // その他
      default:
        return Colors.grey;  // 不明なカテゴリー
    }
  }

  // リストのサムネイルを表示
  Widget _buildLeadingImage(String imagePath) {
    if (imagePath.isNotEmpty && File(imagePath).existsSync()) {
      return SizedBox(
        width: 50,
        height: 50,
        child: Image.file(
          File(imagePath),
          fit: BoxFit.cover,
        ),
      );
    } else {
      return Container(
        width: 50,
        height: 50,
        color: Colors.grey[300],
        child: const Icon(Icons.fastfood, color: Colors.white),
      );
    }
  }

  // 削除確認ダイアログの表示
  void _showDeleteConfirmation(BuildContext context, WidgetRef ref, Food food, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('削除の確認', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text('${food.name} を削除しますか？'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('キャンセル', style: TextStyle(color: Colors.teal)),
          ),
          TextButton(
            onPressed: () {
              ref.read(foodProvider.notifier).removeFood(index);
              Navigator.of(context).pop();
            },
            child: const Text('削除', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // カテゴリーIDからカテゴリー名に変換
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

final categoryFilterProvider = StateProvider<int>((ref) => 4); // デフォルトは「すべて表示」
