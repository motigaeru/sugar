import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'food_provider.dart';
import 'package:pie_chart/pie_chart.dart';

final imbalanceProvider = Provider<String>((ref) {
  final foodList = ref.watch(foodProvider);
  final Map<int, int> categoryCounts = {};
  for (var food in foodList) {
    categoryCounts[food.category] = (categoryCounts[food.category] ?? 0) + 1;
  }

  if (categoryCounts.isEmpty) {
    return 'データがありません。';
  }

  final int maxCount = categoryCounts.values.reduce((a, b) => a > b ? a : b);
  final int minCount = categoryCounts.values.reduce((a, b) => a < b ? a : b);

  if (maxCount > minCount + 5) {
    return '特定のカテゴリーが他のカテゴリーより多くなっています。';
  } else {
    return '食生活のバランスは正常です。';
  }
});

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imbalanceMessage = ref.watch(imbalanceProvider);
    final foodList = ref.watch(foodProvider);

    final Map<String, double> dataMap = {};
    for (var food in foodList) {
      final categoryString = _categoryToString(food.category);
      dataMap[categoryString] = (dataMap[categoryString] ?? 0) + 1;
    }

    return Scaffold(
      appBar: AppBar(
       title: Align(
          alignment: Alignment.centerLeft,
          child: const Text('プロフィール'),
        ),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              alignment: Alignment.center,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    imbalanceMessage,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Colors.red,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  if (dataMap.isNotEmpty)
                    PieChart(
                      dataMap: dataMap,
                      animationDuration: const Duration(milliseconds: 800),
                      chartLegendSpacing: 32,
                      chartRadius: MediaQuery.of(context).size.width / 2,
                      colorList: const [Colors.teal, Colors.red, Colors.blue, Colors.yellow],
                      initialAngleInDegree: 0,
                      chartType: ChartType.ring,
                      ringStrokeWidth: 32,
                      legendOptions: const LegendOptions(
                        showLegendsInRow: false,
                        legendPosition: LegendPosition.right,
                        showLegends: true,
                        legendShape: BoxShape.circle,
                        legendTextStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      chartValuesOptions: const ChartValuesOptions(
                        showChartValueBackground: true,
                        showChartValues: true,
                        showChartValuesInPercentage: true,
                        showChartValuesOutside: false,
                        decimalPlaces: 1,
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: foodList.length,
                itemBuilder: (context, index) {
                  final food = foodList[index];
                  return ListTile(
                    leading: SizedBox(
                      width: 50,
                      height: 50,
                      child: food.image.isNotEmpty && File(food.image).existsSync()
                          ? Image.file(File(food.image), fit: BoxFit.cover)
                          : const Icon(Icons.image, size: 50, color: Colors.grey),
                    ),
                    title: Text(
                      food.name,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    subtitle: Text(
                      _categoryToString(food.category),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    onLongPress: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('削除の確認', style: Theme.of(context).textTheme.bodyLarge),
                          content: Text('${food.name} を削除しますか？', style: Theme.of(context).textTheme.bodyLarge),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('キャンセル', style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.teal)),
                            ),
                            TextButton(
                              onPressed: () {
                                ref.read(foodProvider.notifier).removeFood(index);
                                Navigator.of(context).pop();
                              },
                              child: Text('削除', style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.red)),
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
