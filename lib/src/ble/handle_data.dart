



class Information {
  final String status;
  final String? checkInStatus1;
  final String? checkInStatus2;
  final bool batteryStatus;
  const Information({required this.status,required this.checkInStatus1,required this.checkInStatus2,required this.batteryStatus});

  @override
  String toString () {
    return 'status: $status, check in 1: $checkInStatus1, check in 2: $checkInStatus2, battery: $batteryStatus';
  }
}


Information inforDecode(List<int> res, Information preInfor)
{
  String? status;
  String? checkInStatus1;
  String? checkInStatus2;
  bool batteryStatus;
  if(res[0]==1)
    {
      batteryStatus = true;
    }
  else
    {
      batteryStatus = false;
    }
  switch(res[1])
  {
    case 1:
      status = 'HELPAlarm at ${DateTime.now().toString().substring(0,19)}';
      break;
    case 2:
      status = 'AllOk at ${DateTime.now().toString().substring(0,19)}';
      break;
    case 3:
      status = 'Test at ${DateTime.now().toString().substring(0,19)}';
      break;
    case 14:
      checkInStatus1 = 'Checkin1 done at ${DateTime.now().toString().substring(0,19)}';
      break;
    case 15:
      checkInStatus2 = 'Checkin2 done at ${DateTime.now().toString().substring(0,19)}';
      break;
    case 16:
      checkInStatus1 = 'Checkin1 fail at ${DateTime.now().toString().substring(0,19)}';
      break;
    case 17:
      checkInStatus2 = 'Checkin2 fail at ${DateTime.now().toString().substring(0,19)}';
      break;
  }
  return Information(status: status??preInfor.status, checkInStatus1: checkInStatus1??preInfor.checkInStatus1, checkInStatus2: checkInStatus2??preInfor.checkInStatus2, batteryStatus: batteryStatus);
}