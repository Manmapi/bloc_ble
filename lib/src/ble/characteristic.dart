import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

QualifiedCharacteristic writeChracteristic(String deviceID)
{
  return QualifiedCharacteristic(characteristicId: Uuid.parse('50db1527-418d-4690-9589-ab7be9e22684') , serviceId: Uuid.parse('50bd152a-418d-4690-9589-ab7be9e22684'), deviceId: deviceID);
}


QualifiedCharacteristic readChracteristic(String deviceID)
{
  return QualifiedCharacteristic(characteristicId: Uuid.parse('50db1524-418d-4690-9589-ab7be9e22684') , serviceId: Uuid.parse('50bd152a-418d-4690-9589-ab7be9e22684'), deviceId: deviceID);
}