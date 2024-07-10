import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class  HomeScreen extends StatefulWidget {
 const  HomeScreen({Key? key}) : super(key: key);
 @override
 _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State {
 File? image;
 final picker = ImagePicker();

 Future getImage() async {
   final XFile? _image = await picker.pickImage(source: ImageSource.gallery);

   setState(() {
     if (_image != null) {
       image = File(_image.path);
     }
   });
 }

 @override
 Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: const Text('アルバムから画像を読み込む'),
     ),
     body: Center(
       child: image == null ?
         const Text('画像がありません') 
         : Image.file(image!, fit: BoxFit.cover),
     ),
     floatingActionButton: FloatingActionButton(
       onPressed: () async{
         getImage();
       },
       child: const Icon(Icons.photo),
     ),
   );
 }
}