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
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
    return Consumer6<BleAction,ConnectionStateUpdate,SharedPreferences,FlutterReactiveBle,FlutterLocalNotificationsPlugin,List<String>>(
        builder: (_,action,connectionState,prefs,ble,notification,logState,child)
            {
              final BleStatus bleStatus = Provider.of<BleStatus>(context);
              return _WatchMonitor(
                logger:action.logger,
                scanner: action.scanner,
                connector: action.connector,
                device:device,
                connectionState: connectionState,
                prefs: prefs,
                ble:ble,
                notification:notification,
                logstate:logState,
                bleStatus: bleStatus,
              );
            }
            );
  }
}

class _WatchMonitor extends StatefulWidget{
  const _WatchMonitor({required this.bleStatus,required this.logstate,required this.connector,required this.device,required this.connectionState,required this.prefs,required this.ble,required this.scanner,required this.logger,required this.notification});
  final BleLogger logger;
  final ConnectionStateUpdate connectionState;
  final DiscoveredDevice device;
  final BleConnector connector;
  final FlutterReactiveBle ble;
  final SharedPreferences prefs;
  final BleScanner scanner;
  final FlutterLocalNotificationsPlugin notification;
  final List<String> logstate;
  final BleStatus bleStatus;
  @override
  State<_WatchMonitor> createState() => _WatchMonitorState();
}

class _WatchMonitorState extends State<_WatchMonitor> {

  List<int> characteristicValue = <int>[-1,-1];
  late Information information  ;
  bool isConnected = true;
  bool isRemove = false;
  StreamSubscription<List<int>>? _subscriptionCharacteristic;
  bool isReady = false;
  @override
  void initState() {
    information = getStatus(widget.prefs);
    super.initState();
  }

  // @override
  // void dispose() {
  //   print('dispose');
  //   super.dispose();
  // }
  @override
  Widget build(BuildContext context)
  {
    if(widget.bleStatus == BleStatus.ready ){
      if(!isRemove) {
        if (widget.connectionState.connectionState!=DeviceConnectionState.connected) {
          _subscriptionCharacteristic?.cancel();
          widget.connector.scanAndConnect(widget.device);
        } else {
          _subscriptionCharacteristic ??= widget.ble.subscribeToCharacteristic(readChracteristic(widget.device.id)).listen((event) {
            widget.logger.addLooger(event.toString());
            if(event[1]==18) {
              set_time.setTime(widget.ble, writeChracteristic(widget.device.id));
            }
            if(mounted) {
              setState(() {
                characteristicValue = event;
                information = inforDecode(event, information, widget.notification);
                setStatus(widget.prefs, information);
              });
            }
          });
        }
      }
    }

    return SafeArea(
      child: WillPopScope(
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Device Information'),
            ),
            endDrawer: Drawer(
              child: ListView(
                padding: const EdgeInsets.only(top: 0),
                children:  [
                  const SizedBox(
                    height: 64,
                    child:  DrawerHeader(
                      decoration:  BoxDecoration(
                        color: Colors.orange,
                      ),
                      child: Text("Menu",style: TextStyle(fontSize: 30),textAlign: TextAlign.center,),
                    ),
                  ),
                  ListTile(
                    title: const Text("Log Page"),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const LogPage()));
                    },
                  ),
                  ListTile(
                      title: const Text('Remove device'),
                      onTap: () async {
                          isRemove = true;
                          Navigator.pop(context);
                          Navigator.pushReplacement(
                              context, MaterialPageRoute(builder: (
                              context) => const SearchPage()));
                          print("go here");
                          widget.connector.removeConnection(widget.device.id);
                          removeAll(widget.prefs);
                          widget.scanner.clearState();

                        },
                    ),
                ],
              ),
            ),
            body: Builder(
              builder: (context)=>Center(
                child: Container(
                  padding:const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Align(
                            alignment: Alignment.topLeft,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                (widget.bleStatus != BleStatus.ready)?const Text('Bluetooth is not on, please turn on it',style:  TextStyle(color: Colors.red),):const SizedBox.shrink(),
                                Text('Connection status: ${widget.connectionState.connectionState!=DeviceConnectionState.connected?'Connecting':'Connected'}'),
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
                        SetTimeCheck(checkIn1State: information.checkInStatus1,checkIn2State: information.checkInStatus2,ble: widget.ble,characteristic:  writeChracteristic(widget.device.id),prefs: widget.prefs,),
                        Flexible(child: (widget.logstate.isNotEmpty)?ListView.builder(
                            itemCount: widget.logstate.length,
                            itemBuilder: (_,index)=> Text(widget.logstate[index])
                        ):const SizedBox.shrink(),)

                      ]),
                ),
              ),
            )
                ),
          onWillPop: () async {
            return false;
          }),
    );
  }
}














