
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

void setTime(FlutterReactiveBle ble,QualifiedCharacteristic characteristic) async
{
  final now = DateTime.now();

  await ble.writeCharacteristicWithoutResponse(characteristic, value: [0x10,0x01,0x07]);
  await ble.writeCharacteristicWithoutResponse(characteristic, value: [0x03,0x02,0x07]);
  await ble.writeCharacteristicWithoutResponse(characteristic, value: [0x02,0x03,0x07]);

  await ble.writeCharacteristicWithoutResponse(characteristic, value: [0x02,0x01,0x07]);
  await ble.writeCharacteristicWithoutResponse(characteristic, value: [0x03,0x02,0x07]);
  await ble.writeCharacteristicWithoutResponse(characteristic, value: [0x14,0x03,0x07]);
}
