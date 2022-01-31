import 'package:ntp/ntp.dart';

enum LOGIN_STATE{LOGGED,NOT_LOGIN}

const TIME_SLOT = {
  '9:00-9:30',
  '9:30-10:00',
  '10:00-10:30',
  '10:30-11:00',
  '11:00-11:30',
  '11:30-12:00',
  '12:00-12:30',
  '12:30-13:00',
  '13:00-13:30',
  '13:30-14:00',
  '14:00-14:30',
  '14:30-15:00',
  '15:00-15:30',
  '15:30-16:00',
  '16:00-16:30',
  '16:30-17:00',
};

Future<int> getMaxAvailableTimeslot(DateTime dt) async {
    DateTime now = dt.toLocal();
    DateTime limitDays = now;
    limitDays = limitDays;
    int offset = await NTP.getNtpOffset(localTime: now);
    DateTime syncTime = now.add(Duration(milliseconds: offset));


    if(syncTime.isBefore(DateTime(now.year,now.month,now.day,9,00)))
      return 0;
    else if(syncTime.isAfter(DateTime(now.year,now.month,now.day,9,0)) && syncTime.isBefore(DateTime(now.year,now.month,now.day,9,30)))
    return 1;
    else if(syncTime.isAfter(DateTime(now.year,now.month,now.day,9,30)) && syncTime.isBefore(DateTime(now.year,now.month,now.day,10,0)))
    return 2;
    else if(syncTime.isAfter(DateTime(now.year,now.month,now.day,10,0)) && syncTime.isBefore(DateTime(now.year,now.month,now.day,10,30)))
      return 3;
    else if(syncTime.isAfter(DateTime(now.year,now.month,now.day,10,30)) && syncTime.isBefore(DateTime(now.year,now.month,now.day,11,0)))
      return 4;
    else if(syncTime.isAfter(DateTime(now.year,now.month,now.day,11,0)) && syncTime.isBefore(DateTime(now.year,now.month,now.day,11,30)))
      return 5;
    else if(syncTime.isAfter(DateTime(now.year,now.month,now.day,11,30)) && syncTime.isBefore(DateTime(now.year,now.month,now.day,12,0)))
      return 6;
    else if(syncTime.isAfter(DateTime(now.year,now.month,now.day,12,00)) && syncTime.isBefore(DateTime(now.year,now.month,now.day,12,30)))
      return 7;
    else if(syncTime.isAfter(DateTime(now.year,now.month,now.day,12,30)) && syncTime.isBefore(DateTime(now.year,now.month,now.day,13,0)))
      return 8;
    else if(syncTime.isAfter(DateTime(now.year,now.month,now.day,13,0)) && syncTime.isBefore(DateTime(now.year,now.month,now.day,13,30)))
      return 9;
    else if(syncTime.isAfter(DateTime(now.year,now.month,now.day,13,30)) && syncTime.isBefore(DateTime(now.year,now.month,now.day,14,0)))
      return 10;
    else if(syncTime.isAfter(DateTime(now.year,now.month,now.day,14,0)) && syncTime.isBefore(DateTime(now.year,now.month,now.day,14,30)))
      return 11;
    else if(syncTime.isAfter(DateTime(now.year,now.month,now.day,14,30)) && syncTime.isBefore(DateTime(now.year,now.month,now.day,15,0)))
      return 12;
    else if(syncTime.isAfter(DateTime(now.year,now.month,now.day,15,0)) && syncTime.isBefore(DateTime(now.year,now.month,now.day,15,30)))
      return 13;
    else if(syncTime.isAfter(DateTime(now.year,now.month,now.day,15,30)) && syncTime.isBefore(DateTime(now.year,now.month,now.day,16,0)))
      return 14;
    else if(syncTime.isAfter(DateTime(now.year,now.month,now.day,16,00)) && syncTime.isBefore(DateTime(now.year,now.month,now.day,16,30)))
      return 15;
    else if(syncTime.isAfter(DateTime(now.year,now.month,now.day,16,30)) && syncTime.isBefore(DateTime(now.year,now.month,now.day,17,0)))
      return 16;
    else return 17;
}

Future<DateTime> syncTime() async{
  var now = DateTime.now();
  var offset = await NTP.getNtpOffset(localTime: now);

  return now.add(Duration (milliseconds: offset));
}