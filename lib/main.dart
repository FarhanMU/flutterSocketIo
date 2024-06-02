import 'package:flutter/material.dart';
import 'package:socketio/socket_io_client.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late SocketService _socketService;

  @override
  void initState() {
    super.initState();
    // Pastikan untuk memasukkan callback ke SocketService
    _socketService = SocketService(() {
      setState(() {}); // Ini akan memicu rebuild UI setiap kali data diperbarui
    });
    _socketService.createSocketConnection();
  }

  @override
  void dispose() {
    _socketService.closeConnection();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Socket.IO Client'),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _socketService.messages.length,
                itemBuilder: (context, index) {
                  var record = _socketService.messages[index];
                  return ListTile(
                    title: Text(
                        'ID: ${record['id']}, Status: ${record['status']}'),
                    subtitle: Text(
                        'Cost: ${record['cost']} at ${record['createdAt']}'),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                onSubmitted: (value) {
                  _socketService.sendMessage(value);
                },
                decoration: InputDecoration(
                  labelText: 'Send a message',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
