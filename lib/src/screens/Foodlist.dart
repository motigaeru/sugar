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

    // Filtered list based on selected category
    final filteredFoodList = foodList.where((food) {
      if (selectedCategory == 4) return true; // 4 means "Show all"
      return food.category == selectedCategory;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('食べた食品一覧'),
        backgroundColor: Colors.teal,
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
                  color: _categoryColor(food.category),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    leading: _buildLeadingImage(food.image),
                    title: Text(
                      food.name,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      _categoryToString(food.category),
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
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

  Color _categoryColor(int category) {
    switch (category) {
      case 0:
        return Colors.green[100]!;
      case 1:
        return Colors.red[100]!;
      case 2:
        return Colors.blue[100]!;
      case 3:
        return Colors.grey[200]!;
      default:
        return Colors.white;
    }
  }

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

final categoryFilterProvider = StateProvider<int>((ref) => 4); // Default to showing all items
