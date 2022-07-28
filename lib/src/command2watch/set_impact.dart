import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

const List<int> ENABLE_IMPACT = [0x00,0x01,0x05];
const List<int> DISABLE_IMPACT = [0x00,0x02,0x05];
const List<int> IMPACT_CANCEL_BY_USER = [0x00,0x04,0x05];
List<int> setGValue (int gvalue)
{
  return [gvalue,0x03,0x05];
}
void enableImpactAlert (FlutterReactiveBle ble, QualifiedCharacteristic characteristic, int gValue) async
{
  await ble.writeCharacteristicWithoutResponse(characteristic, value:ENABLE_IMPACT );
  await ble.writeCharacteristicWithoutResponse(characteristic, value:setGValue(gValue) );
}

void disableImpactAlert (FlutterReactiveBle ble, QualifiedCharacteristic characteristic) async
{
  await ble.writeCharacteristicWithoutResponse(characteristic, value:DISABLE_IMPACT );
}
