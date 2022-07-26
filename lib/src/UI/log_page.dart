import 'package:bloc_ble/src/ble/ble_action.dart';
import 'package:bloc_ble/src/ble/ble_logger.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LogPage extends StatelessWidget{

  LogPage({Key? key}):super(key: key);
  @override 
  Widget build(BuildContext context)
  {
    return Consumer<List<String>>(
        builder: (_,loggerState,__) =>
        Scaffold(
          body: SafeArea(
            child: Center(
              child:(loggerState.isNotEmpty)?ListView.builder(
                  itemCount: loggerState.length,
                  itemBuilder: (_,index)=> Text(loggerState[index])
              ):null,
            ),
          ),
        )
    );
  }
}
// class _LogPage extends StatelessWidget{
//   final List<String> loggerState;
//
//   const _LogPage({required this.loggerState});
//   @override
//   Widget build(BuildContext context){
//     print('rebuild');
//     return
//   }
// }