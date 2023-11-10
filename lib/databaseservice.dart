import 'package:mongo_dart/mongo_dart.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter_application_1/lib/userdata.dart';
import 'package:flutter/material.dart';

class DatabaseService with ChangeNotifier {
  IO.Socket? _socket;
  List<User> _users = [];

  List<User> get users => _users;

  // Initialize socket connection
  void initSocket() {
  // Only create a new socket if _socket is null
  if (_socket == null) {
    _socket = IO.io('http://192.168.1.7:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    _socket?.connect();

    _socket?.onConnect((_) => print('connected to socket server'));
    _socket?.onConnectError((data) => print('Connection Error: $data'));
    _socket?.onError((data) => print('Error socket: $data'));
  }
}

  // Connect and set up listeners
  void connectAndListen() {
    print('conny');
    if (_socket == null) {
      initSocket();
    }

    _socket!.on('connect', (_) {
      print('Connected to the server');
      _socket!.emit('request-users'); // Request users right after connection
    });

    _socket!.on('users', (data) {
      _users = (data as List).map((u) => User.fromMap(u)).toList();
      notifyListeners();
    });

    _socket!.on('error', (data) {
      print('Error: $data');
    });

    _socket!.on('disconnect', (_) => print('Disconnected from the server'));

    _socket!.connect();
  }

  @override
void dispose() {
  if (_socket != null) {
    _socket!.disconnect();
    _socket = null;
  }
  super.dispose();
}
}