import 'dart:async';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';


class BleInteraction {

  BleInteraction({required this.ble});
  final FlutterReactiveBle ble;

  // Stream set up
  final StreamController<List<DiscoveredService>> _serviceStreamController = StreamController();

  Stream<List<DiscoveredService>> get serviceState => _serviceStreamController.stream;

  void _pushService (List<DiscoveredService> services) {
    _serviceStreamController.sink.add( services);
  }

  void dispose () async {
    await _serviceStreamController.close();
  }

  // End stream set up
  void discoverService(deviceId) async {
    try{
      List<DiscoveredService> services = await ble.discoverServices(deviceId);
      _pushService(services);
    }
    catch(e){
      rethrow;
    }

  }

}
