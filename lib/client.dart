import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

TextEditingController username = TextEditingController();
Future<void> handleClient() async {
  final socket = await Socket.connect("0.0.0.0", 3000);

  print("Connected to: ${socket.remoteAddress.address}:${socket.remotePort}");
  socket.listen(
    (Uint8List data) {
      final serverResponse = String.fromCharCodes(data);
      print("Client $serverResponse");
    },
    onError: (error) {
      print("Client $error");
      socket.destroy();
    },
    onDone: () {
      print("Client: Server: Left");
      socket.destroy();
    },
  );
  socket.write(username.text);
}
