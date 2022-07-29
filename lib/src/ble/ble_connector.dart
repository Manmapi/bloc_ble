import 'dart:async';

import 'package:bloc_ble/src/preference/time_prefs.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BleConnector {
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
  Future<void> establishConnect(DiscoveredDevice device) async {
    _connection = ble.connectToDevice(id: device.id,connectionTimeout: const Duration(seconds: 2),).listen((ConnectionStateUpdate state) async {
      _pushState(state);
      if(state.connectionState==DeviceConnectionState.connected)
        {
          final prefs = await SharedPreferences.getInstance();
          setDevice(prefs,device);
        }
    },onError: (e) => throw e);
  }


  void scanAndConnect(DiscoveredDevice device) async {
    _connection = ble.connectToAdvertisingDevice(id: device.id,
        connectionTimeout: const Duration(seconds: 2),
        withServices: device.serviceUuids,
        prescanDuration:const Duration(seconds: 2)).listen((ConnectionStateUpdate state) async {
            _pushState(state);
    },onError: (e) => throw e );
  }





  removeConnection(id) async {
    try{
      _connection.cancel();
    } catch (e){ 
      throw 'Error disconnection from a device: $e';
    } finally {
     _pushState(ConnectionStateUpdate(
       deviceId: id,
       connectionState: DeviceConnectionState.disconnected,
       failure: null,));
    }
  }
}