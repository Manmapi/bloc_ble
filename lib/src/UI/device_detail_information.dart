import 'dart:async';

import 'package:bloc_ble/src/UI/log_page.dart';
import 'package:bloc_ble/src/UI/search_for_device.dart';
import 'package:bloc_ble/src/ble/ble_connector.dart';
import 'package:bloc_ble/src/ble/ble_logger.dart';
import 'package:bloc_ble/src/ble/ble_scanner.dart';
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
    return Consumer6<BleScanner,BleConnector,ConnectionStateUpdate,SharedPreferences,FlutterReactiveBle,BleLogger>(
        builder: (_,scanner,connector,connectionState,prefs,ble,logger,child)=> _WatchMonitor(
            logger:logger,
            scanner: scanner,
            connector: connector,
            device:device,
            connectionState: connectionState,
            prefs: prefs,
            ble:ble,
          ));
  }
}

class _WatchMonitor extends StatefulWidget{
  _WatchMonitor({required this.connector,required this.device,required this.connectionState,required this.prefs,required this.ble,required this.scanner,required this.logger});
  final BleLogger logger;
  final ConnectionStateUpdate connectionState;
  final DiscoveredDevice device;
  final BleConnector connector;
  final FlutterReactiveBle ble;
  final SharedPreferences prefs;
  final BleScanner scanner;

  @override
  State<_WatchMonitor> createState() => _WatchMonitorState();
}

class _WatchMonitorState extends State<_WatchMonitor> {
  List<int> characteristicValue = <int>[-1,-1];
  bool isConnected = true;
  StreamSubscription<List<int>>? _subscriptionCharacteristic ;
  String readHeathStatus(int value) {
    switch(value)
    {
      case 1:
        return "Alert at ${DateTime.now().toString().substring(0,19)}";
      case 2:
        return "Ok at ${DateTime.now().toString().substring(0,19)}";
      case 3:
        return "Testing at ${DateTime.now().toString().substring(0,19)}";
      default:
        return 'Waiting... at ${DateTime.now().toString().substring(0,19)}';
    }

  }
  @override
  Widget build(BuildContext context)
  {
    Timer(const Duration(seconds: 5),() async {
      if(widget.connectionState.connectionState!=DeviceConnectionState.connected)
        {
          if(mounted)
            {
              setState((){});
              widget.connector.scanAndConnect(widget.device);
            }
        }
      else
        {
          if(widget.connectionState.connectionState==DeviceConnectionState.connected)
            {
              if(_subscriptionCharacteristic ==null)
                {
                  print("Subcribe once again");
                  _subscriptionCharacteristic = widget.ble.subscribeToCharacteristic(QualifiedCharacteristic(characteristicId: Uuid.parse('50db1524-418d-4690-9589-ab7be9e22684') , serviceId: Uuid.parse('50bd152a-418d-4690-9589-ab7be9e22684'), deviceId: widget.device.id)).listen((event) {
                    widget.logger.addLooger(event.toString());
                    setState(() {
                      characteristicValue = event;
                    });
                  });
                }

            }

        }
    });
    return WillPopScope(
        child: Scaffold(
          body:  SafeArea(
              child: Center(
                child: Container(
                  padding:const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: SingleChildScrollView(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Align(
                              alignment: Alignment.topLeft,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Connection status: ${widget.connectionState.connectionState!=DeviceConnectionState.connected?'Connecting':'Connected'}'),
                                  ElevatedButton(onPressed:(widget.connectionState.connectionState== DeviceConnectionState.connected)? ()  {
                                    widget.connector.removeConnection(widget.device.id);
                                    removeDevice(widget.prefs);
                                    widget.scanner.clearState();
                                    Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) =>const SearchPage()));
                                  }:null, child: const Icon(Icons.bluetooth_disabled)),
                                ],
                              )),

                          const SizedBox(
                            height: 50,
                          ),

                          Row(
                              children: [
                                const Icon(Icons. battery_4_bar,color: Colors.red,size: 150 ,),
                                Flexible(
                                      child: Center(
                                        child: Text("Health Status ${readHeathStatus(characteristicValue[1])}",
                                          softWrap: false,
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,),
                                      ),
                                )
                              ],
                            ),
                          ElevatedButton(
                              onPressed: (){

                                _subscriptionCharacteristic?.cancel();

                                // set_time.setTime(widget.ble, QualifiedCharacteristic(characteristicId: Uuid.parse('50db1527-418d-4690-9589-ab7be9e22684') , serviceId: Uuid.parse('50bd152a-418d-4690-9589-ab7be9e22684'), deviceId: widget.device.id));
                          },
                              child: const Text("Unsubscribe")),
                          ElevatedButton(
                              onPressed: (){
                                _subscriptionCharacteristic = widget.ble.subscribeToCharacteristic(QualifiedCharacteristic(characteristicId: Uuid.parse('50db1524-418d-4690-9589-ab7be9e22684') , serviceId: Uuid.parse('50bd152a-418d-4690-9589-ab7be9e22684'), deviceId: widget.device.id)).listen((event) {
                                  widget.logger.addLooger(event.toString());
                                  setState(() {
                                    characteristicValue = event;
                                  });
                                });
                                // set_time.setTime(widget.ble, QualifiedCharacteristic(characteristicId: Uuid.parse('50db1527-418d-4690-9589-ab7be9e22684') , serviceId: Uuid.parse('50bd152a-418d-4690-9589-ab7be9e22684'), deviceId: widget.device.id));
                              },
                              child: const Text("Subscribe")),
                          ElevatedButton(
                              onPressed: (){
                                widget.ble.writeCharacteristicWithoutResponse( QualifiedCharacteristic(characteristicId: Uuid.parse('50db1527-418d-4690-9589-ab7be9e22684') , serviceId: Uuid.parse('50bd152a-418d-4690-9589-ab7be9e22684'), deviceId: widget.device.id), value: [0x02,0x01,0x07]);

                                // set_time.setTime(widget.ble, QualifiedCharacteristic(characteristicId: Uuid.parse('50db1527-418d-4690-9589-ab7be9e22684') , serviceId: Uuid.parse('50bd152a-418d-4690-9589-ab7be9e22684'), deviceId: widget.device.id));
                              },
                              child: const Text("Subscribe")),
                          Text(characteristicValue.toString()),
                          ElevatedButton(
                              onPressed: () async {
                                TimeOfDay? newTime = await showTimePicker(context: context, initialTime: TimeOfDay.now());

                                // set_time.setTime(widget.ble, QualifiedCharacteristic(characteristicId: Uuid.parse('50db1527-418d-4690-9589-ab7be9e22684') , serviceId: Uuid.parse('50bd152a-418d-4690-9589-ab7be9e22684'), deviceId: widget.device.id));
                              },
                              child: const Text("Time picker")),
                          ElevatedButton(
                              onPressed: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => LogPage()));
                              },
                              child: const Text("Logger")),
                        ]),
                  ),
                ),
              ),
          ),
        ),
        onWillPop: () async {
          await widget.connector.removeConnection(widget.connectionState.deviceId);
          return true;
        });
  }
}