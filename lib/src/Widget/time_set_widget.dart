import 'dart:async';

import 'package:bloc_ble/src/preference/time_prefs.dart';
import 'package:flutter/material.dart';
import 'package:bloc_ble/src/command2watch/set_time.dart' as set_time;
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SetTimeCheck extends StatefulWidget
{
  final String? checkIn1State;
  final String? checkIn2State;
  final FlutterReactiveBle ble;
  final QualifiedCharacteristic characteristic;
  final SharedPreferences prefs;

  const SetTimeCheck({Key? key,required this.ble,required this.characteristic,required this.checkIn1State, required this.checkIn2State,required this.prefs}):super(key: key);
  @override
  State<SetTimeCheck> createState() => _SetTimeCheckState();
}

class _SetTimeCheckState extends State<SetTimeCheck> {
  late CheckInData checkIn1Data;
  late CheckInData checkIn2Data;
  late bool isCheckIn1;
  late bool isCheckIn2;
  late TimeOfDay time1;
  late TimeOfDay time2;
  late Timer timer;
  @override
  void initState() {
    checkIn1Data = getCheckIn1(widget.prefs);
    checkIn2Data = getCheckIn2(widget.prefs);
    isCheckIn1 = checkIn1Data.isOn;
    isCheckIn2 = checkIn2Data.isOn;
    time1 =checkIn1Data.time;
    time2 =checkIn2Data.time;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if(mounted)
        {
          setState(() {
          });
        }

    });
    super.initState();
  }
  @override
  void dispose()
  {
    timer.cancel();
    super.dispose();
  }

  String time2String (TimeOfDay time)
  {
    String hour = time.hour<10?'0${time.hour}':'${time.hour}';
    String min = time.minute<10?'0${time.minute}':'${time.minute}';
    return '$hour:$min';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            padding:const EdgeInsets.symmetric(vertical: 10,horizontal: 0),
            width: double.infinity,
            child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    child: Text(time2String(time1),style: const TextStyle(fontSize:40)),
                    onTap: () async {
                      TimeOfDay? time = await showTimePicker(context: context, initialTime:time1);
                      if(time!=null)
                      {
                        setState((){
                          time1 = time;
                          setCheckIn1(widget.prefs, time1, isCheckIn1);
                        });
                        if(isCheckIn1)
                        {
                          set_time.setCheckin1(widget.ble, widget.characteristic, time1);
                        }
                      }
                    },
                  ),
                  Switch(
                    value: isCheckIn1,
                    onChanged: (value) {
                      setState(() {
                        isCheckIn1 = value;
                        setCheckIn1(widget.prefs, time1, isCheckIn1);
                      });
                      if(isCheckIn1)
                      {
                        set_time.setCheckin1(widget.ble, widget.characteristic, time1);
                      }
                      else{
                        set_time.turnOffCheckin1(widget.ble, widget.characteristic);
                      }
                    },
                    activeColor: Colors.greenAccent[200],
                  ),
                  ElevatedButton(
                      onPressed: (isCheckIn1&&(DateTime.now().hour==time1.hour)&&(DateTime.now().minute-time1.minute>=0)&&(DateTime.now().minute-time1.minute<3))? (){
                        set_time.checkIn1Success(widget.ble, widget.characteristic);
                      }:null,
                      child: const Text("Check in"),
                  )
                ],
              ),
              Text(widget.checkIn1State??''),
            ],
            )


        ),
        Container(
            padding:const EdgeInsets.symmetric(vertical: 10,horizontal: 0),
            width: double.infinity,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      child: Text(time2String(time2),style:const TextStyle(fontSize:40)),
                      onTap: () async {
                        TimeOfDay? time = await showTimePicker(context: context, initialTime:time2);
                        if(time!=null)
                        {
                          setState((){
                            time2 = time;
                            setCheckIn2(widget.prefs, time2, isCheckIn2);
                          });
                          if(isCheckIn2)
                          {
                            set_time.setCheckin2(widget.ble, widget.characteristic, time2);
                          }
                        }
                      },
                    ),
                    Switch(
                      value: isCheckIn2,
                      onChanged: (value) {
                        setState(() {
                          isCheckIn2 = value;
                          setCheckIn2(widget.prefs, time2, isCheckIn2);
                        });
                        if(isCheckIn2)
                        {
                          set_time.setCheckin2(widget.ble, widget.characteristic, time2);
                        }
                        else{
                          set_time.turnOffCheckin2(widget.ble, widget.characteristic);
                        }
                      },
                      activeColor: Colors.greenAccent[200],
                    ),
                    ElevatedButton(
                      onPressed:(isCheckIn2&&(DateTime.now().hour==time2.hour)&&(DateTime.now().minute-time2.minute>=0)&&(DateTime.now().minute-time2.minute<3))?(){
                        set_time.checkIn2Success(widget.ble, widget.characteristic);
                      }:null,
                      child: const Text("Check in"),
                    )
                  ],
                ),
                Text(widget.checkIn2State??''),
        ],
    )


        )
      ],
    );
  }
}