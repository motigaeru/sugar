import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import 'chat_message.dart';

class DataBaseConnection extends AsyncNotifier<List<Map>> {
  late String path;
  late Database database;
  List<Map> listMap = [];

  @override
  Future<List<Map>> build() async {
    // getDatabasesPath()：デフォルトのデータベース保存用フォルダのパスを取得
    var databasesPath = await getDatabasesPath();
    // 取得したパスから本アプリ用にて生成するDB名を指定
    path = '$databasesPath/test.db';
    // データベースを開く（pathに存在しなければ新規作成）
    database = await openDatabase(
        path,
        version: 1,
        // DBがpathに存在しなかった場合にonCreateが呼び出される
        onCreate: (Database db, int version) async {
          await db.execute(
              'CREATE TABLE Test (id TEXT PRIMARY KEY, name TEXT, message TEXT)'
          );
        });
    return [];
  }
  void dbInsert(String id, String name, String message) async {
    final chatMessage = ref.watch(chatMessageProvider.notifier);
    // INSERT
    await database.insert(
      'Test',
      {'id': id, 'name': name, 'message': message},
    );
    // SELECT
    listMap = await database.rawQuery('SELECT * FROM Test');
    // 状態更新
    chatMessage.update(listMap);
  }
  void dbUpdate(String id, String name, String message) async {
    final chatMessage = ref.watch(chatMessageProvider.notifier);
    // idをキーとしてUPDATE
    await database.update(
        'Test',
        {'name': name, 'message': message},
        where: 'id = ?',
        whereArgs: [id]
    );
    // SELECT
    listMap = await database.rawQuery('SELECT * FROM Test');
    // 状態更新
    chatMessage.update(listMap);
  }
  void dbDelete(String id) async {
    final chatMessage = ref.watch(chatMessageProvider.notifier);
    // idをキーとしてDELETE
    await database.delete(
        'Test',
        where: 'id = ?',
        whereArgs: [id]
    );
    // SELECT
    listMap = await database.rawQuery('SELECT * FROM Test');
    // 状態更新
    chatMessage.update(listMap);
  }
}

final dataBaseConnectionProvider = AsyncNotifierProvider<DataBaseConnection, List<Map>>(() {
  return DataBaseConnection();
});