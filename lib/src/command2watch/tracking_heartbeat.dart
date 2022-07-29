
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

const List<int> DISABLE_TRACKING = [0x00,0x00,0x01];
const List<int> DISABLE_HEARTBEAT= [0x00,0x00,0x04];

void stopTracking (FlutterReactiveBle ble, QualifiedCharacteristic characteristic) async {
  await ble.writeCharacteristicWithoutResponse(characteristic, value: DISABLE_TRACKING);
}

void startTracking (FlutterReactiveBle ble, QualifiedCharacteristic characteristic) async {

  await ble.writeCharacteristicWithoutResponse(characteristic, value: [0x05,0x01,0x01]);
}

void stopCurrentTracking(FlutterReactiveBle ble, QualifiedCharacteristic characteristic) async {
  await ble.writeCharacteristicWithoutResponse(characteristic, value: [0x05,0x01,0x01]);
}
void startHeartBeat (FlutterReactiveBle ble, QualifiedCharacteristic characteristic) async {
  await ble.writeCharacteristicWithoutResponse(characteristic, value: [0x00,0x01,0x03]);
}

void stopHeartBeat (FlutterReactiveBle ble, QualifiedCharacteristic characteristic) async {
  await ble.writeCharacteristicWithoutResponse(characteristic, value: DISABLE_HEARTBEAT);
}
