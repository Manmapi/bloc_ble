import 'dart:async';
import 'package:bloc_ble/src/ble/characteristic.dart';
import 'package:bloc_ble/src/UI/log_page.dart';
import 'package:bloc_ble/src/UI/search_for_device.dart';
import 'package:bloc_ble/src/Widget/time_set_widget.dart';
import 'package:bloc_ble/src/ble/ble_action.dart';
import 'package:bloc_ble/src/ble/ble_connector.dart';
import 'package:bloc_ble/src/ble/ble_logger.dart';
import 'package:bloc_ble/src/ble/ble_scanner.dart';
import 'package:bloc_ble/src/ble/handle_data.dart';
import 'package:bloc_ble/src/get_reference.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bloc_ble/src/ble/set_time.dart' as set_time;


class DeviceInformation extends StatelessWidget{
  const DeviceInformation({ Key? key,required this.device}):super(key: key);
  final DiscoveredDevice  device;
  @override
  Widget build(BuildContext context)
  {
    return Consumer4<BleAction,ConnectionStateUpdate,SharedPreferences,FlutterReactiveBle>(
        builder: (_,action,connectionState,prefs,ble,child)=> _WatchMonitor(
            logger:action.logger,
            scanner: action.scanner,
            connector: action.connector,
            device:device,
            connectionState: connectionState,
            prefs: prefs,
            ble:ble,

          ));
  }
}

class _WatchMonitor extends StatefulWidget{
  const _WatchMonitor({required this.connector,required this.device,required this.connectionState,required this.prefs,required this.ble,required this.scanner,required this.logger});
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
  late Information information  ;
  bool isConnected = true;
  StreamSubscription<List<int>>? _subscriptionCharacteristic ;

  @override
  void initState() {
    information =getStatus(widget.prefs);
    super.initState();
  }
  @override
  Widget build(BuildContext context)
  {
    Timer(const Duration(seconds: 5),() async {
      if(widget.connectionState.connectionState!=DeviceConnectionState.connected)
        {
          _subscriptionCharacteristic = null;
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

              _subscriptionCharacteristic ??= widget.ble.subscribeToCharacteristic(readChracteristic(widget.device.id)).listen((event) {
                widget.logger.addLooger(event.toString());
                if(event[1]==18)
                  {
                    set_time.setTime(widget.ble, writeChracteristic(widget.device.id));
                  }
                if(mounted)
                  {
                    setState(() {
                      characteristicValue = event;
                      information = inforDecode(event, information);
                      setStatus(widget.prefs, information);
                    });
                  }
              });
            }

        }
    });
    return WillPopScope(
        child: Scaffold(
          body:  SafeArea(
              child: Center(
                child: Container(
                  padding:const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Align(
                              alignment: Alignment.centerRight,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Connection status: ${widget.connectionState.connectionState!=DeviceConnectionState.connected?'Connecting':'Connected'}'),
                                  ElevatedButton(onPressed:(widget.connectionState.connectionState== DeviceConnectionState.connected)? ()  {
                                    widget.connector.removeConnection(widget.device.id);
                                    removeAll(widget.prefs);
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
                                Icon(Icons. battery_4_bar,color: information.batteryStatus?Colors.greenAccent[200]:Colors.redAccent[200],size: 150 ,),
                                Flexible(
                                      child: Center(
                                        child: Text("Health Status ${information.status}",
                                          softWrap: false,
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,),
                                      ),
                                )
                              ],
                            ),
                          Text(characteristicValue.toString()),
                          ElevatedButton(
                              onPressed: ()  {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const LogPage()));
                              },
                              child: const Text("Logger")),
                          SetTimeCheck(checkIn1State: information.checkInStatus1,checkIn2State: information.checkInStatus2,ble: widget.ble,characteristic:  writeChracteristic(widget.device.id),prefs: widget.prefs,),
                          // StreamBuilder(
                          //     stream: widget.ble.connectedDeviceStream,
                          //     builder: (_,snapshot)=>Text(snapshot.toString()))
                        ]),
                  ),
                ),
              ),
        ),
        onWillPop: () async {
          _subscriptionCharacteristic?.cancel();
          return true;
        });
  }
}














