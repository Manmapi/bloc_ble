
import 'package:bloc_ble/src/UI/ble_not_on.dart';
import 'package:bloc_ble/src/UI/device_detail_information.dart';
import 'package:bloc_ble/src/ble/ble_connector.dart';
import 'package:bloc_ble/src/ble/ble_device_interaction.dart';
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

  final _ble = FlutterReactiveBle();
  final _bleStatus = BleStatusMonitor(_ble);
  final _bleScanner = BleScanner(ble: _ble);
  final _connector = BleConnector(ble: _ble);
  final _interactor = BleInteraction(ble: _ble);
  final  prefs = await SharedPreferences.getInstance();
  runApp(MultiProvider(providers: [
    Provider.value(value: _ble),
    Provider.value(value: prefs),
    Provider.value(value: _bleScanner),
    Provider.value(value: _connector),
    Provider.value(value: _interactor),
    StreamProvider<List<DiscoveredService>>(create: (_) => _interactor.serviceState, initialData:const <DiscoveredService>[]),
    StreamProvider<ConnectionStateUpdate>(create: (_) => _connector.state, initialData: const ConnectionStateUpdate(
      deviceId: '',
      connectionState: DeviceConnectionState.disconnected,
      failure: null,
    )),
    StreamProvider<BleStatus>(create: (_) => _bleStatus.state, initialData: BleStatus.unknown),
    StreamProvider<BleScannerState>(create: (_) => _bleScanner.state , initialData:const BleScannerState(
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
      home: Consumer4<BleStatus,SharedPreferences,BleConnector,BleInteraction>(builder: (_,status,prefs,connector,interactor,child)  {
        if(status == BleStatus.ready)
          {
            final device = getDevice(prefs);
            if(device!= null)
              {
                connector.scanAndConnect(device);
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

