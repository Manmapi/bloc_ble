import 'dart:typed_data';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:shared_preferences/shared_preferences.dart';



void setDevice (SharedPreferences prefs,DiscoveredDevice device) async {
  await prefs.setString('id',device.id);

  await prefs.setString('name',device.name);

  await prefs.setString('serviceUuids',device.serviceUuids[0].toString());

  await prefs.setInt('rssi',device.rssi);
}

DiscoveredDevice? getDevice (SharedPreferences prefs) {

  final String? id = prefs.getString('id');

  final String? name = prefs.getString('name');

  final Uuid serviceUuids = Uuid.parse(prefs.getString('serviceUuids')??'79700043-11eb-1101-80d6-510900000d10');

  final int? rssi = prefs.getInt('rssi');
  DiscoveredDevice device;

  Uint8List manufacturerData = Uint8List(0);

  if(id!=null&& name!=null && rssi!= null)
    {
      device = DiscoveredDevice(id: id, name: name, serviceData: const {}, manufacturerData: manufacturerData, rssi: rssi, serviceUuids: [serviceUuids]);
      return device;
    }
  return null;
}

void removeDevice (SharedPreferences prefs) async {
  await prefs.remove('id');
  await prefs.remove('name');
  await prefs.remove('serviceUuids');
  await prefs.remove('rssi');
}