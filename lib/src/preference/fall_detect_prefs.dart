import 'package:shared_preferences/shared_preferences.dart';


class ImpactDetectSetting {
  final double gValue;
  final bool impactDetectEnable;
  const ImpactDetectSetting({required this.gValue, required this.impactDetectEnable});
}
void setImpactDetectSetting (SharedPreferences prefs , ImpactDetectSetting impactDetectSetting) async
{
  await prefs.setString('gValue', impactDetectSetting.gValue.toString());
  await prefs.setBool('fallDetectEnable', impactDetectSetting.impactDetectEnable);
}

ImpactDetectSetting getImpactDetectSetting (SharedPreferences prefs)
{
  String? gValue = prefs.getString('gValue');
  bool impactDetectEnable = prefs.getBool('impactDetectEnable')??false;
  return ImpactDetectSetting(gValue: (gValue!=null)?double.parse(gValue):0 ,impactDetectEnable: impactDetectEnable);
}


