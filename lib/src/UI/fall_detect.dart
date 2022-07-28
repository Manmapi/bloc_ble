import 'package:bloc_ble/src/preference/fall_detect_prefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FallDetect extends StatelessWidget{
  @override
  Widget build(BuildContext context)
  {
    return Consumer3<FlutterReactiveBle,ConnectionStateUpdate,SharedPreferences>(
        builder:(_,ble,connectionState,prefs,__) => _FallDetectPage(
            connectionState:connectionState,
            prefs:prefs,
        ));
  }
}
class _FallDetectPage extends StatefulWidget{
  final ConnectionStateUpdate connectionState;
  final SharedPreferences prefs;
  const _FallDetectPage({required this.connectionState,required this.prefs});
  @override
  State<_FallDetectPage> createState() => _FallDetectPageState();
}

class _FallDetectPageState extends State<_FallDetectPage>{
  late ImpactDetectSetting impactDetectSetting;
  late double gValue ;
  late bool impactDetectEnable  ;
  @override
  void initState()
  {
    impactDetectSetting = getImpactDetectSetting(widget.prefs);
    gValue = impactDetectSetting.gValue;
    impactDetectEnable = impactDetectSetting.impactDetectEnable;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Fall Detect"),
                Switch(
                    value: impactDetectEnable ,
                    onChanged: (value)
                    {
                      setState((){
                        impactDetectEnable = value;
                        setImpactDetectSetting(widget.prefs, ImpactDetectSetting(gValue: gValue, impactDetectEnable: impactDetectEnable));
                      });
                    },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Set g value: "),
                Slider(
                  value: gValue,
                  onChanged: (value){
                    setState(() {
                      gValue = value;
                      setImpactDetectSetting(widget.prefs, ImpactDetectSetting(gValue: gValue, impactDetectEnable: impactDetectEnable));
                    });
                  },
                  label: '$gValue',
                  divisions: 4,
                  min: 0,
                  max: 80,
                ),
              ],
            ),
            Text(widget.connectionState.connectionState .toString()),
          ],
        ),
      ),
    );
  }
}
