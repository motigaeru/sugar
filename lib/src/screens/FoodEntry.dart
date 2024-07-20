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
      DropdownMenuItem(value: 0, child: Text('野菜')),
      DropdownMenuItem(value: 1, child: Text('肉')),
      DropdownMenuItem(value: 2, child: Text('魚')),
      DropdownMenuItem(value: 3, child: Text('その他')),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('食品入力'),
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
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
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
            SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '写真',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    height: 150,
                    color: Colors.grey[300],
                    alignment: Alignment.center,
                    child: _imageUrl.isNotEmpty
                        ? Image.file(File(_imageUrl))
                        : Icon(Icons.image, size: 50, color: Colors.grey),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: Text('写真を選択'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'カテゴリ',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
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
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
          ],
        ),
      ),
    );
  }
}
