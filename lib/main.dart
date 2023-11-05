import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_with/message_manager.dart';
import 'package:url_launcher/url_launcher.dart';

void main() async {
  final server = await ServerSocket.bind('192.168.1.15', 3000);
  final messageManager = MessageManager();
  final messages = <String>[];
  runApp(
    MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Desktop App'),
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: messageManager.messages,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final message = snapshot.data.toString();
                    var uri = Uri.parse(message);
                    launchUrl(uri);
                    return ListTile(
                      title: Text(message),
                    );
                  } else {
                    return Center(child: Text('No messages yet.'));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    ),
  );
  Future<void> handleLaunchURL(Uri uri) async {
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }
  // ...

  server.listen((Socket client) {
    client.listen((List<int> data) {
      String message = String.fromCharCodes(data);
      print('Received: $message');
      messageManager.sendMessage(message); // Update the UI
    });
  });
}
