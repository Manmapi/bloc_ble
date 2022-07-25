import 'package:bloc_ble/src/ble/ble_logger.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LogPage extends StatelessWidget{
  
  @override 
  Widget build(BuildContext context)
  {
    return Consumer<BleLogger>(builder: (_,logger,__) => _LogPage(logger: logger,) );
  }
}
class _LogPage extends StatelessWidget{
  final BleLogger logger;
  _LogPage({required this.logger});
  @override 
  Widget build(BuildContext context){
    return Scaffold(
      body: SafeArea(
        child: Center(
          child:(logger.logger.length>0)?ListView.builder(
              itemCount: logger.logger.length,
              itemBuilder: (_,index)=> Text(logger.logger[index])
          ):null,
        ),
      ),
    );
  }
}