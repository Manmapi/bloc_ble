import 'package:flutter/material.dart';
import 'package:bloc_ble/src/ble/set_time.dart' as set_time;
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class SetTimeCheck extends StatefulWidget
{
  final String? checkIn1State;
  final String? checkIn2State;
  final FlutterReactiveBle ble;
  final QualifiedCharacteristic characteristic;
  const SetTimeCheck({Key? key,required this.ble,required this.characteristic,required this.checkIn1State, required this.checkIn2State}):super(key: key);
  @override
  State<SetTimeCheck> createState() => _SetTimeCheckState();
}

class _SetTimeCheckState extends State<SetTimeCheck> {
  bool isCheckIn1 = false;
  bool isCheckIn2 = false;
  TimeOfDay time1 = const TimeOfDay(hour: 12, minute: 00);
  TimeOfDay time2 = const TimeOfDay(hour: 12, minute: 00);

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
            width: 200,
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
                  )
                ],
              ),
              Text(widget.checkIn1State??''),
            ],
            )


        ),
        Container(
            padding:const EdgeInsets.symmetric(vertical: 10,horizontal: 0),
            width: 200,
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