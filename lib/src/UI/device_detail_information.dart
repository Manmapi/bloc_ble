import 'dart:async';
import 'package:bloc_ble/main.dart';
import 'package:bloc_ble/src/UI/fall_detect.dart';
import 'package:bloc_ble/src/UI/sleep_reset_page.dart';
import 'package:bloc_ble/src/UI/tracking_heartbeat.dart';
import 'package:bloc_ble/src/ble/characteristic.dart';
import 'package:bloc_ble/src/UI/log_page.dart';
import 'package:bloc_ble/src/Widget/time_set_widget.dart';
import 'package:bloc_ble/src/ble/ble_action.dart';
import 'package:bloc_ble/src/ble/ble_connector.dart';
import 'package:bloc_ble/src/ble/ble_logger.dart';
import 'package:bloc_ble/src/ble/ble_scanner.dart';
import 'package:bloc_ble/src/ble/handle_data.dart';
import 'package:bloc_ble/src/preference/time_prefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bloc_ble/src/command2watch/set_time.dart' as set_time;

class DeviceInformation extends StatelessWidget{
  const DeviceInformation({ Key? key,required this.device}):super(key: key);
  final DiscoveredDevice  device;
  @override
  Widget build(BuildContext context)
  {
    return Consumer5<BleAction,ConnectionStateUpdate,SharedPreferences,FlutterReactiveBle,FlutterLocalNotificationsPlugin>(
        builder: (_,action,connectionState,prefs,ble,notification,child)
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
                bleStatus: bleStatus,
              );
            }
            );
  }
}

class _WatchMonitor extends StatefulWidget{
  const _WatchMonitor({required this.bleStatus ,required this.connector,required this.device,required this.connectionState,required this.prefs,required this.ble,required this.scanner,required this.logger,required this.notification});
  final BleLogger logger;
  final ConnectionStateUpdate connectionState;
  final DiscoveredDevice device;
  final BleConnector connector;
  final FlutterReactiveBle ble;
  final SharedPreferences prefs;
  final BleScanner scanner;
  final FlutterLocalNotificationsPlugin notification;
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
  @override
  Widget build(BuildContext context)
  {
    if(widget.bleStatus == BleStatus.ready ){
      if(!isRemove) {
        if (widget.connectionState.connectionState!=DeviceConnectionState.connected) {
          _subscriptionCharacteristic?.cancel();
          _subscriptionCharacteristic = null;
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
              child: Column(
                children: [
                    SizedBox(
                      height: 64,
                      child:  DrawerHeader(
                          decoration:  BoxDecoration(
                            color: Colors.greenAccent[200],
                          ),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children:  [
                                const Text("Menu",style: TextStyle(fontSize: 30),textAlign: TextAlign.center,),
                                GestureDetector(
                                  onTap: (){
                                    Navigator.pop(context);
                                  },
                                  child: const Icon(Icons.arrow_forward),
                                )
                              ])
                      ),
                    ),
                  Flexible(
                    child: ListView(
                      padding: const EdgeInsets.only(top: 0),
                      children:  [
                        ListTile(
                          title: const Text("Log Page",
                          style: TextStyle(fontSize: 20),),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const LogPage()));
                          },
                        ),
                        ListTile(
                          title: const Text("Impact Detect Setting",
                            style: TextStyle(fontSize: 20),),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => FallDetect(device:  widget.device,)));
                          },
                        ),
                        ListTile(
                          title: const Text("Sleep and Reset",
                            style: TextStyle(fontSize: 20),),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => SleepResetPage(device:  widget.device,)));
                          },
                        ),
                        ListTile(
                          title: const Text("Heartbeat and Tracking",
                            style: TextStyle(fontSize: 20),),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => TrackingHeartBeatPage(device:  widget.device,)));
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.blueAccent[200],
                      shape: BoxShape.rectangle,
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(5),topRight: Radius.circular(5))
                    ),
                    padding: const EdgeInsets.only(bottom: 20,top:20),
                    child: GestureDetector(
                        onTap:() async {
                          isRemove = true;
                          Navigator.pop(context);
                          Navigator.pushReplacement(
                              context, MaterialPageRoute(builder: (
                              context) => const MyApp()));
                          widget.connector.removeConnection(widget.device.id);
                          removeAll(widget.prefs);
                          widget.scanner.clearState();
                        },
                        child:const Text(
                          "Remove Device",
                          style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center ,)
                    )
                  )
              ],)

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
                                Text('Connection status: ${widget.connectionState.connectionState}'),
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














