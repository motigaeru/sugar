import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

final strProvider = Provider((ref) {
  return 'Hello';
});

class RiverpodSample extends ConsumerWidget {
  const RiverpodSample({Key? key}) : super(key: key);
@override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(strProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green, 
        title: const Text('ホーム'),
      ),
      body: Center(
        child: Text(
          value,
          style: const TextStyle(
              fontSize: 24
          ),
        ),
      ),
    );
  }
}