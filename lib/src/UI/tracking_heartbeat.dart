
import 'package:bloc_ble/src/ble/characteristic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:provider/provider.dart';
import 'package:bloc_ble/src/command2watch/tracking_heartbeat.dart' as tracking_hearbeat;

class TrackingHeartBeatPage extends StatelessWidget
{
  final DiscoveredDevice device;
  const TrackingHeartBeatPage({Key? key,required this.device}):super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer<FlutterReactiveBle>(
        builder:(_,ble,__) => _TrackingHeartBeatPage(
          ble: ble,
          device: device,
        )
    );
  }
}
class _TrackingHeartBeatPage extends StatefulWidget
{
  final FlutterReactiveBle ble;
  final DiscoveredDevice device;
  const _TrackingHeartBeatPage({required this.ble, required this.device});
  @override
  State<_TrackingHeartBeatPage> createState() => _TrackingHeartBeatPageState();
}

class _TrackingHeartBeatPageState extends State<_TrackingHeartBeatPage> {
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      body:SafeArea(
        child: Center(
          child: Column(
            children: [
              ElevatedButton(onPressed: () {
                tracking_hearbeat.startHeartBeat(widget.ble, writeChracteristic(widget.device.id));
              }, child: const Text("Start heartbeat")),
              ElevatedButton(onPressed: () {
                tracking_hearbeat.stopHeartBeat(widget.ble, writeChracteristic(widget.device.id));
              }, child: const Text("Stop heartbeat")),
              ElevatedButton(onPressed: () {
                tracking_hearbeat.startTracking(widget.ble, writeChracteristic(widget.device.id));
              }, child: const Text("Start tracking")),
              ElevatedButton(onPressed: () {
                tracking_hearbeat.stopTracking(widget.ble, writeChracteristic(widget.device.id));
              }, child: const Text("Stop tracking")),
              ElevatedButton(onPressed: () {
                tracking_hearbeat.stopCurrentTracking(widget.ble, writeChracteristic(widget.device.id));
              }, child: const Text("Stop current tracking")),
            ],
          ),
        ),
      ),
    );
  }
}