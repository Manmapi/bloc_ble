import 'dart:async';


import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BleConnector{
  BleConnector({required this.ble});
  final FlutterReactiveBle ble;


  //Stream to observe connection state
  final StreamController<ConnectionStateUpdate> _connectionStateController = StreamController();

  Stream<ConnectionStateUpdate> get state => _connectionStateController.stream;

  void _pushState(ConnectionStateUpdate state) {
    _connectionStateController.sink.add(state);
  }

  Future<void> dispose() async {
    await _connectionStateController.close();
  }
  // End of stream
  late StreamSubscription<ConnectionStateUpdate> _connection;
  //Function to make connection with device
  void establishConnect(id) async {
    _connection = ble.connectToDevice(id: id).listen((ConnectionStateUpdate state) async {
      _pushState(state);
      if(state.connectionState==DeviceConnectionState.connected)
        {
          final prefs = await SharedPreferences.getInstance();
          prefs.setString('deviceId', state.deviceId);
        }
    },onError: (e) => throw e);
  }

  removeConnection(id) async {
    try{
      _connection.cancel();
    } catch (e){ 
      print('Error disconnection from a device: $e');
    } finally {
     _pushState(ConnectionStateUpdate(
       deviceId: id,
       connectionState: DeviceConnectionState.disconnected,
       failure: null,));
     final prefs = await SharedPreferences.getInstance();
     if(prefs.getString('deviceId')!= null)
       {
         prefs.remove('deviceId');
       }

    }
    await _connection.cancel();
  }
}