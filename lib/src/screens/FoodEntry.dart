import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FoodEntry extends StatefulWidget {
  const FoodEntry({Key? key}) : super(key: key);

  @override
  _FoodEntryState createState() => _FoodEntryState();
}

class _FoodEntryState extends State<FoodEntry> {
  String _foodName = '';
  String _imageUrl = '';
  int _selectedCategory = 0;  // Default category

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imageUrl = image.path;
      });
    }
  }

  List<DropdownMenuItem<int>> get _dropdownItems {
    return [
      const DropdownMenuItem(value: 0, child: Text('野菜')),
      const DropdownMenuItem(value: 1, child: Text('肉')),
      const DropdownMenuItem(value: 2, child: Text('魚')),
      const DropdownMenuItem(value: 3, child: Text('その他')),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerLeft,
          child: const Text('食品入力'),
        ),
        backgroundColor: const Color.fromARGB(208, 9, 84, 3),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: IconButton(
              onPressed: () {
                if (_foodName.isNotEmpty) {
                  Navigator.pop(context, {
                    'name': _foodName,
                    'image': _imageUrl,
                    'category': _selectedCategory
                  });
                }
              },
              icon: const Icon(Icons.add),
              iconSize: 32.0,
              color: Colors.yellowAccent, // Brighter color
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildSectionTitle('食品名'),
            TextField(
              onChanged: (value) {
                setState(() {
                  _foodName = value;
                });
              },
              decoration: const InputDecoration(
                hintText: '食品名を入力してください',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20.0),
            _buildSectionTitle('写真'),
            _buildImagePicker(),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _pickImage,
              style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 255, 255, 255)),
              child: const Text('写真を選択'),
            ),
            const SizedBox(height: 20.0),
            _buildSectionTitle('カテゴリ'),
            DropdownButton<int>(
              value: _selectedCategory,
              items: _dropdownItems,
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildImagePicker() {
    return Container(
      height: 150,
      color: Colors.grey[300],
      alignment: Alignment.center,
      child: _imageUrl.isNotEmpty
          ? Image.file(File(_imageUrl))
          : const Icon(Icons.image, size: 50, color: Colors.grey),
    );
  }
}
