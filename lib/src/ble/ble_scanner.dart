import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';


// This is a stream that can discover ble device

class BleScanner {
  BleScanner({required FlutterReactiveBle ble}) : _ble = ble;


  final FlutterReactiveBle _ble;

  final _devices = <DiscoveredDevice> [];

  StreamSubscription? _subscription;

  List<DiscoveredDevice> get devices => _devices;

  bool isScanning = false;
  // Ble Scanner stream

  final StreamController<BleScannerState> _stateStreamController = StreamController();

  Stream<BleScannerState>  get state => _stateStreamController.stream;

  void _pushState() {
    _stateStreamController.sink.add(BleScannerState(
        discoverdDevices: _devices,
        scanIsInProgress: _subscription!=null ));
  }

  void clearState() {
    _stateStreamController.sink.add(const BleScannerState(discoverdDevices: [], scanIsInProgress: false));
  }
  void startScan (List<Uuid> serviceIds) {
    _subscription?.cancel();
    _devices.clear();
    _subscription = _ble.scanForDevices(withServices: serviceIds).listen((device) {

       final knowDeviceIndex = _devices.indexWhere((element) => element.id == device.id);
       if(knowDeviceIndex >= 0)
         {
           _devices[knowDeviceIndex] = device;
         }
       else{
         _devices.add(device);
       }
       _pushState();
    },onError: (e) => throw Exception(e)
    );
  }


  void stopScan () async {
    await _subscription?.cancel();
    _subscription = null;
    _pushState();
  }

  Future<void> dispose() async {
    await _stateStreamController.close();
  }

}


@immutable
class BleScannerState {
  const BleScannerState({
    required this.discoverdDevices,
    required this.scanIsInProgress,
  });
  final List<DiscoveredDevice> discoverdDevices;
  final bool scanIsInProgress;
}