
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';


const List<int> TURN_OFF_CHECKIN_1 = [0x00,0x07,0x06];
const List<int> TURN_ON_CHECKIN_1 = [0x00,0x05,0x06];
const List<int> TURN_OFF_CHECKIN_2 = [0x00,0x08,0x06];
const List<int> TURN_ON_CHECKIN_2 = [0x00,0x06,0x06];
void setTime(FlutterReactiveBle ble,QualifiedCharacteristic characteristic) async
{

  final now = DateTime.now();

  await ble.writeCharacteristicWithoutResponse(characteristic, value: [now.hour,0x01,0x07]);
  await ble.writeCharacteristicWithoutResponse(characteristic, value: [now.minute,0x02,0x07]);
  await ble.writeCharacteristicWithoutResponse(characteristic, value: [now.second,0x03,0x07]);




  await ble.writeCharacteristicWithoutResponse(characteristic, value: [now.day,0x04,0x07]);
  await ble.writeCharacteristicWithoutResponse(characteristic, value: [now.month,0x05,0x07]);
  await ble.writeCharacteristicWithoutResponse(characteristic, value: [now.year%100,0x06,0x07]);
  await ble.writeCharacteristicWithoutResponse(characteristic, value: [now.weekday,0x07,0x07]);

}
void setCheckin1(FlutterReactiveBle ble,QualifiedCharacteristic characteristic, TimeOfDay time) async
{
  await ble.writeCharacteristicWithoutResponse(characteristic, value: TURN_OFF_CHECKIN_1);
  await ble.writeCharacteristicWithoutResponse(characteristic, value: [time.hour,0x01,0x06]);
  await ble.writeCharacteristicWithoutResponse(characteristic, value: [time.minute,0x02,0x06]);
  await ble.writeCharacteristicWithoutResponse(characteristic, value: TURN_ON_CHECKIN_1);
}
void setCheckin2(FlutterReactiveBle ble,QualifiedCharacteristic characteristic, TimeOfDay time) async
{
  await ble.writeCharacteristicWithoutResponse(characteristic, value: TURN_OFF_CHECKIN_2);
  await ble.writeCharacteristicWithoutResponse(characteristic, value: [time.hour,0x03,0x06]);
  await ble.writeCharacteristicWithoutResponse(characteristic, value: [time.minute,0x04,0x06]);
  await ble.writeCharacteristicWithoutResponse(characteristic, value: TURN_ON_CHECKIN_2);
}

void turnOffCheckin1(FlutterReactiveBle ble,QualifiedCharacteristic characteristic) async {
  await ble.writeCharacteristicWithoutResponse(characteristic, value: TURN_OFF_CHECKIN_1);
}
void turnOffCheckin2(FlutterReactiveBle ble,QualifiedCharacteristic characteristic) async {
  await ble.writeCharacteristicWithoutResponse(characteristic, value: TURN_OFF_CHECKIN_2);
}