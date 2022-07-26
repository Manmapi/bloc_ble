
import 'package:bloc_ble/src/ble/ble_connector.dart';
import 'package:bloc_ble/src/ble/ble_device_interaction.dart';
import 'package:bloc_ble/src/ble/ble_logger.dart';
import 'package:bloc_ble/src/ble/ble_scanner.dart';

class BleAction{
  final BleConnector connector;
  final BleScanner scanner;
  final BleInteraction interactor;
  final BleLogger logger;
  const BleAction({required this.connector, required this.scanner, required this.interactor,required this.logger});
}