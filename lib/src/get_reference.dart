import 'dart:typed_data';

import 'package:bloc_ble/src/ble/handle_data.dart';
import 'package:flutter/material.dart';
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

  final Uuid serviceUuids = Uuid.parse(prefs.getString('serviceUuids')??'79700043--11eb1101-80d6-510900000d10');

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

void setStatus (SharedPreferences prefs, Information status) async
{
  await prefs.setBool('batteryStatus', status.batteryStatus);
  await prefs.setString('healthStatus', status.status);
  if (status.checkInStatus1 != null)
    {
      await prefs.setString('checkIn1Status',status.checkInStatus1??'');
    }
  if (status.checkInStatus2 != null)
  {
    await prefs.setString('checkIn2Status',status.checkInStatus2??'');
  }
}

Information getStatus (SharedPreferences prefs)
{
  String? status = prefs.getString('healthStatus');
  String? checkInStatus1 = prefs.getString('checkIn1Status');
  String? checkInStatus2 = prefs.getString('checkIn2Status');
  bool? batteryStatus = prefs.getBool('batteryStatus');
  return Information(status: status??'Waiting...', checkInStatus1: checkInStatus1, checkInStatus2: checkInStatus2, batteryStatus: batteryStatus??true);
}


void removeStatus (SharedPreferences prefs) async
{
  await prefs.remove('healthStatus');
  await prefs.remove('batteryStatus');
  await prefs.remove('checkIn2Status');
  await prefs.remove('checkIn1Status');
}


void setCheckIn1 (SharedPreferences prefs, TimeOfDay time, bool isOn) async
{
  await prefs.setInt('checkIn1Hour',time.hour);
  await prefs.setInt('checkIn1Min',time.minute);
  await prefs.setBool('isCheckIn1On', isOn);
}
CheckInData getCheckIn1(SharedPreferences prefs)
{
  int? hour = prefs.getInt('checkIn1Hour');
  int? min = prefs.getInt('checkIn1Min');
  bool? isOn = prefs.getBool('isCheckIn1On');
  return CheckInData(time: TimeOfDay(hour: hour??00, minute: min??00), isOn: isOn??false);
}
void setCheckIn2 (SharedPreferences prefs, TimeOfDay time, bool isOn) async
{
  await prefs.setInt('checkIn2Hour',time.hour);
  await prefs.setInt('checkIn2Min',time.minute);
  await prefs.setBool('isCheckIn2On', isOn);
}

CheckInData getCheckIn2(SharedPreferences prefs)
{
  int? hour = prefs.getInt('checkIn2Hour');
  int? min = prefs.getInt('checkIn2Min');
  bool? isOn = prefs.getBool('isCheckIn2On');
  return CheckInData(time: TimeOfDay(hour: hour??00, minute: min??00), isOn: isOn??false);
}
void removeCheckIn1(SharedPreferences prefs) async
{
  await prefs.remove('checkIn1Hour');
  await prefs.remove('checkIn1Min');
  await prefs.remove('isCheckIn1On');
}

void removeCheckIn2(SharedPreferences prefs) async
{
  await prefs.remove('checkIn2Hour');
  await prefs.remove('checkIn2Min');
  await prefs.remove('isCheckIn2On');
}


void removeAll(SharedPreferences prefs)
{
  removeDevice(prefs);
  removeCheckIn1(prefs);
  removeCheckIn2(prefs);
  removeStatus(prefs);
}
class CheckInData
{
  final TimeOfDay time;
  final bool isOn;
  const CheckInData({required this.time,required this.isOn});
}