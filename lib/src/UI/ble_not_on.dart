
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class BleNotOpen extends StatelessWidget{
  const BleNotOpen({Key? key,required this.status}):super(key: key);

  String _statusDetermine ()
  {
    switch(status)
    {
      case BleStatus.poweredOff:
        return "Please turn on Bluetooth";
      case BleStatus.unsupported:
        return "This device is not supported for Bluetooth connection";
      case BleStatus.locationServicesDisabled:
        return "Enable location services";
      case BleStatus.unauthorized:
        return "Authorize the FlutterReactiveBle example app to use Bluetooth and location";
      default:
        return "Waiting to fetch Bluetooth status $status";
    }
  }

  final BleStatus status;
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Text(_statusDetermine()),
        ),
      ),
    );
  }

}