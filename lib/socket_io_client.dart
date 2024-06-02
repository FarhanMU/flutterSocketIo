import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  IO.Socket? socket;
  List<Map<String, dynamic>> messages = [];
  Function onUpdate; // Tambahkan parameter callback

  SocketService(this.onUpdate); // Constructor mengambil callback

  void createSocketConnection() {
    socket = IO.io('http://192.168.0.101:4000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket?.connect();

    socket?.onConnect((_) {
      print('Connected');
      socket?.emit('msg', 'test');
    });

    socket?.on('chargingConnector', (data) {
      List<dynamic> listData = data as List;
      var newMessages =
          listData.map((item) => item as Map<String, dynamic>).toList();
      messages.addAll(newMessages); // Menambahkan data baru ke list yang ada
      print(messages.length); // Debugging: Menampilkan jumlah pesan
      onUpdate(); // Panggil callback yang akan memicu setState
    });

    socket?.onDisconnect((_) => print('Disconnected'));
    socket?.onError((data) => print('Error: $data'));
  }

  void sendMessage(String message) {
    socket?.emit('msg', message);
  }

  void closeConnection() {
    if (socket != null) {
      socket?.disconnect();
    }
  }
}
