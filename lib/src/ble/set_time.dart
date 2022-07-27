
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

const List<int> TURN_OFF_CHECKIN_1 = [0x00,0x07,0x06];
const List<int> TURN_ON_CHECKIN_1 = [0x00,0x05,0x06];
const List<int> TURN_OFF_CHECKIN_2 = [0x00,0x08,0x06];
const List<int> TURN_ON_CHECKIN_2 = [0x00,0x06,0x06];

List<int> setHour(int hour)
{
  return [hour,0x01,0x07];
}

List<int> setMin(int min)
{
  return [min,0x02,0x07];
}
List<int> setSec(int sec)
{
  return [sec,0x03,0x07];
}
List<int> setDay(int day)
{
  return [day,0x04,0x07];
}
List<int> setMonth(int month)
{
  return [month,0x05,0x07];
}
List<int> setYear(int year)
{
  return [year%100,0x06,0x07];
}
List<int> setWeekday(int weekday)
{
  return [weekday,0x07,0x07];
}
List<int> setCheckIn1Hour (int hour)
{
  return [hour,0x01,0x06];
}
List<int> setCheckIn1Min (int min)
{
  return [min,0x02,0x06];
}
List<int> setCheckIn2Hour (int hour)
{
  return [hour,0x03,0x06];
}
List<int> setCheckIn2Min (int min)
{
  return [min,0x04,0x06];
}




void setTime(FlutterReactiveBle ble,QualifiedCharacteristic characteristic) async
{
  final now = DateTime.now();

  await ble.writeCharacteristicWithoutResponse(characteristic, value: setHour(now.hour));
  await ble.writeCharacteristicWithoutResponse(characteristic, value: setMin(now.minute));
  await ble.writeCharacteristicWithoutResponse(characteristic, value: setSec(now.second));
  
  await ble.writeCharacteristicWithoutResponse(characteristic, value: setDay(now.day));
  await ble.writeCharacteristicWithoutResponse(characteristic, value: setMonth(now.month));
  await ble.writeCharacteristicWithoutResponse(characteristic, value: setYear(now.year));
  await ble.writeCharacteristicWithoutResponse(characteristic, value: setWeekday(now.weekday));

}
void setCheckin1(FlutterReactiveBle ble,QualifiedCharacteristic characteristic, TimeOfDay time) async
{
  await ble.writeCharacteristicWithoutResponse(characteristic, value: TURN_OFF_CHECKIN_1);
  await ble.writeCharacteristicWithoutResponse(characteristic, value: setCheckIn1Hour(time.hour));
  await ble.writeCharacteristicWithoutResponse(characteristic, value: setCheckIn1Min(time.minute));
  await ble.writeCharacteristicWithoutResponse(characteristic, value: TURN_ON_CHECKIN_1);
}
void setCheckin2(FlutterReactiveBle ble,QualifiedCharacteristic characteristic, TimeOfDay time) async
{
  await ble.writeCharacteristicWithoutResponse(characteristic, value: TURN_OFF_CHECKIN_2);
  await ble.writeCharacteristicWithoutResponse(characteristic, value: setCheckIn2Hour(time.hour));
  await ble.writeCharacteristicWithoutResponse(characteristic, value: setCheckIn2Min(time.minute));
  await ble.writeCharacteristicWithoutResponse(characteristic, value: TURN_ON_CHECKIN_2);
}

void turnOffCheckin1(FlutterReactiveBle ble,QualifiedCharacteristic characteristic) async {
  await ble.writeCharacteristicWithoutResponse(characteristic, value: TURN_OFF_CHECKIN_1);
}
void turnOffCheckin2(FlutterReactiveBle ble,QualifiedCharacteristic characteristic) async {
  await ble.writeCharacteristicWithoutResponse(characteristic, value: TURN_OFF_CHECKIN_2);
}