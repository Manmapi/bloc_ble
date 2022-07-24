import 'dart:async';

import 'package:bloc_ble/src/UI/device_detail_information.dart';
import 'package:bloc_ble/src/ble/ble_scanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

import 'package:provider/provider.dart';

class SearchPage extends StatelessWidget{
  const SearchPage({Key? key}): super(key: key);
  @override
  Widget build(BuildContext context){
    return Consumer2<BleScanner,BleScannerState>(
        builder:  (_,_bleScanner,status,__) => _SearchForDevice(
            status: status,
            startScan: _bleScanner.startScan,
            stopScan: _bleScanner.stopScan)
    );
  }
}

class _SearchForDevice extends StatefulWidget{
  final BleScannerState status;
  final void Function(List<Uuid>) startScan;
  final void Function() stopScan;

  const _SearchForDevice({required this.status,required this.startScan, required this.stopScan});

  @override
  State<_SearchForDevice> createState() => _SearchForDeviceState();
}

class _SearchForDeviceState extends State<_SearchForDevice> {

  _startScanning() async {
    widget.startScan([Uuid.parse('50db152A-418d-4690-9589-ab7be9e22684')]);
    Timer(const Duration(seconds: 5),() {
      widget.stopScan();
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
                        onTap: (){
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> DeviceInformation(device: widget.status.discoverdDevices[index],isKnow: false,)));
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
          label: const Text("Find watch"),
          hoverColor: Colors.grey,
          backgroundColor:widget.status.scanIsInProgress?Colors.grey:Colors.blue ,
          onPressed: widget.status.scanIsInProgress? null :() {_startScanning();},

        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}