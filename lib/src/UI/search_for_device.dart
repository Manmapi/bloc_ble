import 'dart:async';

import 'package:bloc_ble/src/UI/device_detail_information.dart';
import 'package:bloc_ble/src/ble/ble_action.dart';
import 'package:bloc_ble/src/ble/ble_connector.dart';
import 'package:bloc_ble/src/ble/ble_device_interaction.dart';
import 'package:bloc_ble/src/ble/ble_scanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

import 'package:provider/provider.dart';

class SearchPage extends StatelessWidget{
  const SearchPage({Key? key}): super(key: key);
  @override
  Widget build(BuildContext context){
    return Consumer2<BleAction,BleScannerState>(
        builder:  (_,action,status,__) => _SearchForDevice(
            status: status,
            startScan: action.scanner.startScan,
            connector: action.connector,
            interactor: action.interactor,
            stopScan: action.scanner.stopScan,
            clearScan: action.scanner.clearState,
        ),
    );
  }
}

class _SearchForDevice extends StatefulWidget{
  final BleScannerState status;
  final void Function(List<Uuid>) startScan;
  final void Function() stopScan;
  final void Function () clearScan;
  final BleConnector connector;
  final BleInteraction interactor;
  const _SearchForDevice({required this.status,required this.startScan, required this.stopScan,required this.connector,required this.interactor,required this.clearScan});

  @override
  State<_SearchForDevice> createState() => _SearchForDeviceState();
}

class _SearchForDeviceState extends State<_SearchForDevice> {
  bool isScanning = false;
  _startScanning() async {
    if(mounted){
      setState((){
        isScanning = true;
      });
    }
    widget.startScan([Uuid.parse('50db152A-418d-4690-9589-ab7be9e22684')]);
    Timer(const Duration(seconds: 5),() {
      widget.stopScan();
      if(mounted) {
          setState((){
            isScanning = false;
          });
        }
    });
  }
  @override
  Widget build(BuildContext context){
    return  Scaffold(
      body: Container(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Center(
          child:Column(
            children: [
              const SizedBox(
                height: 200,
              ),
              Flexible(
                child: ListView.separated(
                    separatorBuilder:(_, a) => const Divider(),
                    itemCount: widget.status.discoverdDevices.length,
                    itemBuilder: (_,index){
                      return ListTile(
                        dense: true,
                        leading:const SizedBox(
                            width: 64,
                            height: 64,
                            child: Align(alignment: Alignment.center, child: Icon(Icons.bluetooth,color: Colors.blue,)),),
                        title: Text(widget.status.discoverdDevices[index].name
                        ,style:const TextStyle(fontSize: 25,fontWeight: FontWeight.w500),),
                        onTap: () async {
                          widget.stopScan();
                          widget.connector.establishConnect(widget.status.discoverdDevices[index]);
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> DeviceInformation(device: widget.status.discoverdDevices[index])));
                        },
                      );
                }),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        width: double.infinity,
        child: FloatingActionButton.extended(
          label:isScanning?const CircularProgressIndicator():const Text("Find watch"),
          hoverColor: Colors.grey,
          backgroundColor:isScanning?Colors.grey:Colors.blue ,
          onPressed: isScanning? null :() {_startScanning();},
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}