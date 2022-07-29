import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';


const List<int> SLEEP_WATCH = [0x00,0x00,0x0B];
const List<int> RESET_WATCH = [0x00,0x00,0x09];

void sleepWatch(FlutterReactiveBle ble, QualifiedCharacteristic characteristic) async
{
  await ble.writeCharacteristicWithoutResponse(characteristic, value: SLEEP_WATCH);
}

void resetWatch(FlutterReactiveBle ble, QualifiedCharacteristic characteristic) async
{
  await ble.writeCharacteristicWithoutResponse(characteristic, value: RESET_WATCH);
}
