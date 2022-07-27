
import 'package:bloc_ble/src/UI/ble_not_on.dart';
import 'package:bloc_ble/src/UI/device_detail_information.dart';
import 'package:bloc_ble/src/ble/ble_action.dart';
import 'package:bloc_ble/src/ble/ble_connector.dart';
import 'package:bloc_ble/src/ble/ble_device_interaction.dart';
import 'package:bloc_ble/src/ble/ble_logger.dart';
import 'package:bloc_ble/src/ble/ble_scanner.dart';
import 'package:bloc_ble/src/ble/ble_status.dart';
import 'package:bloc_ble/src/get_reference.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:bloc_ble/src/UI/search_for_device.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Permission.bluetooth.request();
  await Permission.location.request();
  await Permission.bluetoothConnect.request();
  await Permission.bluetoothScan.request();
  final ble = FlutterReactiveBle();
  final bleStatus = BleStatusMonitor(ble);
  final bleScanner = BleScanner(ble: ble);
  final connector = BleConnector(ble: ble);
  final interactor = BleInteraction(ble: ble);
  final  prefs = await SharedPreferences.getInstance();
  final logger = BleLogger();
  final bleAction = BleAction(connector: connector, scanner: bleScanner, interactor: interactor, logger: logger);

  runApp(MultiProvider(providers: [
    Provider.value(value: bleAction),
    Provider.value(value: logger),
    Provider.value(value: ble),
    Provider.value(value: prefs),
    StreamProvider<List<String>>(create: (_) => bleAction.logger.loggerState , initialData: const <String>[]),
    StreamProvider<List<DiscoveredService>>(create: (_) => bleAction.interactor.serviceState, initialData:const <DiscoveredService>[]),
    StreamProvider<ConnectionStateUpdate>(create: (_) => ble.connectedDeviceStream, initialData: const ConnectionStateUpdate(
      deviceId: '',
      connectionState: DeviceConnectionState.disconnected,
      failure: null,
    )),
    StreamProvider<BleStatus>(create: (_) => bleStatus.state, initialData: BleStatus.unknown),
    StreamProvider<BleScannerState>(create: (_) => bleAction.scanner.state , initialData:const BleScannerState(
      discoverdDevices: [],
      scanIsInProgress: false,
    )),],
    child: const MyApp(),) );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Consumer3<BleStatus,SharedPreferences,BleAction>(builder: (_,status,prefs,action,child)  {
        if(status == BleStatus.ready)
          {
            final device = getDevice(prefs);
            if(device!= null)
              {
                action.connector.scanAndConnect(device);

                return DeviceInformation(device: device);
              }
            return const SearchPage();
          }
        else
          {
            return BleNotOpen(status: status);
          }
          },
      ),
    );
  }
}

