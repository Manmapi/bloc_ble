import 'package:bloc_ble/src/ble/characteristic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:provider/provider.dart';
import 'package:bloc_ble/src/command2watch/sleep_reset.dart' as sleep_reset;
class SleepResetPage extends StatelessWidget{
  final DiscoveredDevice device;
  const SleepResetPage({Key? key, required this.device}):super(key:key);
  @override
  Widget build(BuildContext context)
  {
    return Consumer<FlutterReactiveBle>(
        builder: (_,ble,__) => _SleepResetPage(
          ble: ble,
          device: device,
        )
    );
  }
}
class _SleepResetPage extends StatefulWidget
{
  final DiscoveredDevice device;
  final FlutterReactiveBle ble;
  const _SleepResetPage({required this.ble,required this.device});
  @override
  State<_SleepResetPage> createState() => _SleepResetPageState();
}

class _SleepResetPageState extends State<_SleepResetPage> {
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              ElevatedButton(onPressed: (){
                sleep_reset.resetWatch(widget.ble, writeChracteristic(widget.device.id));
              }, child: const Text("Reset watch")),
              ElevatedButton(onPressed: (){
                sleep_reset.sleepWatch(widget.ble, writeChracteristic(widget.device.id));
              }, child: const Text("Sleep watch")),
            ],
          ),
        ),
      ),
    );
  }
}