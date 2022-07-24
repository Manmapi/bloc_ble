import 'package:bloc_ble/src/UI/search_for_device.dart';
import 'package:bloc_ble/src/ble/ble_connector.dart';
import 'package:bloc_ble/src/get_reference.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


class DeviceInformation extends StatelessWidget{
  const DeviceInformation({ Key? key,required this.device,required this.isKnow}):super(key: key);

  final DiscoveredDevice  device;
  final bool isKnow;
  @override
  Widget build(BuildContext context)
  {
    return Consumer4<BleConnector,ConnectionStateUpdate,SharedPreferences,FlutterReactiveBle>(
        builder: (_,connector,connectionState,prefs,ble,child)=> _WatchMonitor(
            connector: connector,
            device:device,
            connectionState: connectionState,
            prefs: prefs,
            isKnow: isKnow,
            ble:ble,
          ));
  }
}

class _WatchMonitor extends StatelessWidget{
  _WatchMonitor({required this.connector,required this.device,required this.connectionState,required this.prefs,required this.isKnow,required this.ble});
  bool isKnow;
  final ConnectionStateUpdate connectionState;
  final DiscoveredDevice device;
  final BleConnector connector;
  final FlutterReactiveBle ble;
  final SharedPreferences prefs;
  @override
  Widget build(BuildContext context)
  {

    return WillPopScope(
        child: Scaffold(
          body:  SafeArea(
              child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 100,
                      ),
                      const Text("Tap Button to connect to device"),
                      Text('Connection status: ${connectionState.connectionState.toString()}'),
                      ElevatedButton(onPressed: ()  {
                        connector.removeConnection(device.id);
                        removeDevice(prefs);

                      }, child: const Icon(Icons.remove_circle)),
                      const SizedBox(
                        height: 100,
                      ),
                      ElevatedButton(onPressed: () async {
                        print(await ble.discoverServices(device.id));
                      }, child: const Icon(Icons.search)),
                    ]),
              ),

          ),
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.connect_without_contact),
            onPressed: (){
              if(connectionState.connectionState==DeviceConnectionState.disconnected)
              {
                connector.establishConnect(device);
              }
              else{
                throw "Already connected, bitch!";
              }
            },
          ),
        ),
        onWillPop: () async {
          await connector.removeConnection(connectionState.deviceId);
          return true;
        });
  }
}