import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatMessage extends Notifier<List<Map>> {
  @override
  List<Map> build(){
    return [];
  }
  void update(List<Map> chatList) {
    state = chatList;
  }
}

final chatMessageProvider = NotifierProvider<ChatMessage, List<Map>>((){
  return ChatMessage();
});