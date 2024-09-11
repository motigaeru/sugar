import 'package:flutter/material.dart';
import 'food_provider.dart'; // Adjust import as needed

class warningScreen extends StatelessWidget {
  const warningScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Dummy data for example
    final List<String> warnings = [
      '特定のカテゴリーの食品が多くなっています。',
      '食品の画像が存在しません。',
      '食品名が入力されていません。',
    ];

    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerLeft,
          child: const Text('警告'),
        ),
        backgroundColor: Colors.red, // Changed color to indicate warnings
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '以下の警告があります:',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: warnings.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    color: Colors.red[50],
                    child: ListTile(
                      leading: const Icon(Icons.warning, color: Colors.red),
                      title: Text(
                        warnings[index],
                        style: const TextStyle(fontSize: 16.0),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16.0),
            
          ],
        ),
      ),
    );
  }
}
