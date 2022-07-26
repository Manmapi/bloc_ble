
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LogPage extends StatefulWidget{

  const LogPage({Key? key}):super(key: key);
  @override
  State<LogPage> createState() => _LogPageState();
}

class _LogPageState extends State<LogPage> {
  @override
  Widget build(BuildContext context)
  {
    return Consumer<List<String>>(
            builder: (_,loggerState,__) =>Scaffold(
            body: SafeArea(
              child: GestureDetector(
                onVerticalDragUpdate: (detail){

                },
                child: Center(
                  child:Column(
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Back to main")),
                      Flexible(child:(loggerState.isNotEmpty)?ListView.builder(
                          itemCount: loggerState.length,
                          itemBuilder: (_,index)=> Text(loggerState[index])
                      ):const SizedBox.shrink(), ),
                    ]
                  ),
                ),
              ),
            ),
          ),
        );
  }
}
