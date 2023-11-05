import 'dart:async';

import 'package:url_launcher/url_launcher.dart';

class MessageManager {
  final _messageController = StreamController<String>.broadcast();

  Stream<String> get messages => _messageController.stream;

  void sendMessage(String message) {
    _messageController.sink.add(message);
  }

  void dispose() {
    _messageController.close();
  }
}
