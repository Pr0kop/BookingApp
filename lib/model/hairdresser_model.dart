import 'package:cloud_firestore/cloud_firestore.dart';

class HairdresserModel {
  String name, docId;
  double rating;
  int ratingTimes;

  DocumentReference reference;

  HairdresserModel();

  HairdresserModel.fromJson(Map<String, dynamic> json) {
    //userName = json['userName'];
    name = json['name'];
    rating = double.parse(json['raiting'] == null ? '0' : json['raiting'].toString());
    ratingTimes = int.parse(json['raitingTimes'] == null ? '0' : json['raitingTimes'].toString());
  }

  Map<String,dynamic> toJson() {
    final Map<String,dynamic> data = new Map<String,dynamic>();
    //data['userName'] = this.userName;
    data['name'] = this.name;
    data['raiting'] = this.rating;
    data['raitingTimes'] = this.ratingTimes;

    return data;
  }
}
