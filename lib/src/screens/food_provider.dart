import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

enum FoodCategory { vegetable, meat, fish, others }

class Food {
  final String name;
  final String image;
  final int category;

  Food(this.name, this.image, this.category);

  Map<String, dynamic> toJson() => {
        'name': name,
        'image': image,
        'category': category,
      };

  static Food fromJson(Map<String, dynamic> json) {
    return Food(
      json['name'] as String,
      json['image'] as String,
      json['category'] as int,
    );
  }
}

class FoodNotifier extends StateNotifier<List<Food>> {
  FoodNotifier() : super([]) {
    _loadFoodList();
  }

  Future<void> _loadFoodList() async {
    final prefs = await SharedPreferences.getInstance();
    final String? foodListString = prefs.getString('food_list');

    if (foodListString != null) {
      final List<dynamic> jsonList = json.decode(foodListString);
      final List<Food> loadedFoodList = jsonList.map((jsonItem) => Food.fromJson(jsonItem)).toList();
      state = loadedFoodList;
    }
  }

  Future<void> _saveFoodList() async {
    final prefs = await SharedPreferences.getInstance();
    final String jsonList = json.encode(state.map((food) => food.toJson()).toList());
    await prefs.setString('food_list', jsonList);
  }

  void addFood(Food food) {
    state = [...state, food];
    _saveFoodList();
    _checkCategoryImbalance();
  }

  void removeFood(int index) {
    state = [...state]..removeAt(index);
    _saveFoodList();
    _checkCategoryImbalance();
  }

  void _checkCategoryImbalance() {
    final Map<int, int> categoryCounts = {};
    for (var food in state) {
      categoryCounts[food.category] = (categoryCounts[food.category] ?? 0) + 1;
    }

    final int maxCount = categoryCounts.values.reduce((a, b) => a > b ? a : b);
    final int minCount = categoryCounts.values.reduce((a, b) => a < b ? a : b);

    if (maxCount > minCount + 5) {  // 偏りの閾値を 5 としていますが、必要に応じて調整可能
      print('カテゴリの偏りが検出されました！');
      // アラートダイアログや通知を表示するロジックを追加
    }
  }
}

final foodProvider = StateNotifierProvider<FoodNotifier, List<Food>>((ref) {
  return FoodNotifier();
});