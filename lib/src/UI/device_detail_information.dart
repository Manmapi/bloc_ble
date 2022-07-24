import 'package:bloc_ble/src/UI/search_for_device.dart';
import 'package:bloc_ble/src/ble/ble_connector.dart';
import 'package:bloc_ble/src/get_reference.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


class DeviceInformation extends StatelessWidget{
  const DeviceInformation({ Key? key,required this.device}):super(key: key);

  final DiscoveredDevice  device;

  @override
  Widget build(BuildContext context)
  {
    return Consumer2<BleConnector,ConnectionStateUpdate>(
        builder: (_,connector,connectionState,__)=> _WatchMonitor(
            connector: connector,
            device:device,
            connectionState: connectionState));
  }
}

class _WatchMonitor extends StatelessWidget{
  const _WatchMonitor({required this.connector,required this.device,required this.connectionState});

  final ConnectionStateUpdate connectionState;
  final DiscoveredDevice device;
  final BleConnector connector;
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
                        connector.removeConnection(connectionState.deviceId);
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>const SearchPage()));
                      }, child: const Icon(Icons.remove_circle)),
                      const SizedBox(
                        height: 100,
                      ),
                      ElevatedButton(onPressed: () async {
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        removeDevice(prefs);
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