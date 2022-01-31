

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/model/booking_model.dart';
import 'package:first_app/model/user_model.dart';
import 'package:first_app/state/state_managment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<UserModel> getUserProfiles(BuildContext context, WidgetRef ref, String phone) async {
  CollectionReference userRef = FirebaseFirestore.instance.collection('User');
  DocumentSnapshot snapshot = await userRef.doc(phone).get();
  if(snapshot.exists) {
    var userModel = UserModel.fromJson(snapshot.data());
    ref.read(userInformation.state).state = userModel;
    return userModel;
  }
  else return UserModel();
}

Future<List<BookingModel>> getUserHistory() async {
  var listBooking = new List<BookingModel>.empty(growable: true);
  var userRef = FirebaseFirestore.instance.collection('User')
      .doc(FirebaseAuth.instance.currentUser.phoneNumber)
      .collection('Booking_${FirebaseAuth.instance.currentUser.uid}');
  var snapshot = await userRef.orderBy('timeStamp', descending: true).get();
  snapshot.docs.forEach((element) {
    var booking = BookingModel.fromJson(element.data());
    booking.docId = element.id;
    listBooking.add(booking);
    print(listBooking.length);
  });
  return listBooking;
}