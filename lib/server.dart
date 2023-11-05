import 'dart:io';
import 'dart:typed_data';

final ip = InternetAddress.anyIPv4;
final int port = 3000;
Future<void> handleConnect() async {
  final server = await ServerSocket.bind(ip, port);
  print("server is running on: ${ip.address}:$port");
  server.listen((Socket event) {
    handleConnection(event);
  });
}

List<Socket> clients = [];
void handleConnection(Socket client) {
  client.listen(
    (Uint8List data) {
      print(
          "Connection from: ${client.remoteAddress.address}:${client.remotePort}");
      final message = String.fromCharCodes(data);
      clients.add(client);
      client.write(
          "Server: you are logged in as: $message and ${clients.length}");
      for (final c in clients) {
        c.write("Server: $message joined the party");
      }
    },
    onError: (error) {
      print(error);
      client.close();
    },
    onDone: () {
      print("Server: client left");
    },
  );
}
