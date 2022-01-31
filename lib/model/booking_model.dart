import 'package:cloud_firestore/cloud_firestore.dart';

class BookingModel{
  String docId,hairdresserId,hairdresserName,cityBook,customerName,customerPhone,salonAddress,salonId,salonName,time;
  bool done;
  int slot,timeStamp;

  DocumentReference reference;

  BookingModel(
      {this.docId,
      this.hairdresserId,
      this.hairdresserName,
      this.cityBook,
      this.customerName,
      this.customerPhone,
      this.salonAddress,
      this.salonId,
      this.salonName,
      this.time,
      this.done,
      this.slot,
      this.timeStamp});

  BookingModel.fromJson (Map<String, dynamic> json){
    print('entered');
    hairdresserId = json['hairdresserId'];
    print('1 done');
    hairdresserName = json['hairdresserName'];
    print('2 done');
    cityBook = json['cityBook'];
    print('3 done');
    customerName = json['customerName'];
    print('4 done');
    customerPhone = json['customerPhone'];
    print('5 done');
    salonAddress = json['salonAddress'];
    print('6 done');
    salonName = json['salonName'];
    print('7 done');
    salonId = json['salonId'];
    print('8 done');
    time = json['time'];
    print('9 done');
    done = json['done'] as bool;
    print('10 done');
    slot = int.parse(json['slot'] == null ? '0' : json['slot'].tostring());
    print('11 done');
    timeStamp = int.parse(json['timeStamp'] == null ? '0' : json['timeStamp'].toString());
    print('12 done');
  }

  Map<String, dynamic> toJson() {
    final Map<String,dynamic> data = new Map<String,dynamic>();
    data['hairdresserId'] = this.hairdresserId;
    data['hairdresserName'] = this.hairdresserName;
    data['cityBook'] = this.cityBook;
    data['customerPhone'] = this.customerPhone;
    data['customerName' ] = this.customerName;
    data['salonId'] = this.salonId;
    data['salonName'] = this.salonName;
    data['salonAddress'] = this.salonAddress;
    data['time'] = this.time;
    data['done'] = this.done;
    data['slot'] = this.slot;
    data['timeStamp'] = this.timeStamp;

    return data;
  }

}