import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/model/booking_model.dart';
import 'package:first_app/model/city_model.dart';
import 'package:first_app/model/hairdresser_model.dart';
import 'package:first_app/model/salon_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:first_app/state/state_managment.dart';
import 'package:flutter_riverpod/fLutter_riverpod.dart';
import 'package:intl/intl.dart';

Future<BookingModel> getDetailBooking(
    BuildContext context, WidgetRef ref, int timeSlot) async {
  CollectionReference userRef = FirebaseFirestore.instance
      .collection('AllSalon')
      .doc(ref.read(selectedCity.state).state.name)
      .collection('Branch')
      .doc(ref.read(selectedSalon.state).state.docId)
      .collection('Fryzjer')
      .doc(FirebaseAuth.instance.currentUser.uid)
      .collection(
          DateFormat('dd_MM_yyyy').format(ref.read(selectedDate.state).state));

  DocumentSnapshot snapshot = await userRef.doc(timeSlot.toString()).get();
  if (snapshot.exists) {
    var bookingModel =
        BookingModel.fromJson(json.decode(json.encode(snapshot.data)));
    bookingModel.docId = snapshot.id;
    bookingModel.reference = snapshot.reference;
    ref.read(selectedBooking.state).state = bookingModel;
    return bookingModel;
  } else
    return BookingModel(
        totalPrice: 0,
        customerName: '',
        done: false,
        salonName: '',
        salonId: '',
        salonAddress: '',
        cityBook: '',
        timeStamp: 0,
        time: '',
        hairdresserId: '',
        customerPhone: '',
        hairdresserName: '',
        customerId: '',
        slot: 0);
}

Future<List<CityModel>> getCities() async {
  var cities = new List<CityModel>.empty(growable: true);
  var cityRef = FirebaseFirestore.instance.collection('AllSalon');
  var snapshot = await cityRef.get();
  snapshot.docs.forEach((element) {
    cities.add(CityModel.fromJson(element.data()));
  });
  return cities;
}

Future<List<SalonModel>> getSalonByCity(String cityName) async {
  var salons = new List<SalonModel>.empty(growable: true);
  if (cityName == 'Białystok') cityName = 'Bialystok';
  var salonRef = FirebaseFirestore.instance
      .collection('AllSalon')
      .doc(cityName.replaceAll(' ', ''))
      .collection('Branch');
  var snapshot = await salonRef.get();
  snapshot.docs.forEach((element) {
    var salon = SalonModel.fromJson(element.data());
    salon.docId = element.id;
    salon.reference = element.reference;
    salons.add(salon);
  });
  return salons;
}

Future<List<HairdresserModel>> getHairdressersBySalon(SalonModel salon) async {
  var hairdressers = new List<HairdresserModel>.empty(growable: true);
  var hairdresserRef = salon.reference.collection('Fryzjer');
  var snapshot = await hairdresserRef.get();
  snapshot.docs.forEach((element) {
    var hairdresser = HairdresserModel.fromJson(element.data());
    hairdresser.docId = element.id;
    hairdresser.reference = element.reference;
    hairdressers.add(hairdresser);
  });
  return hairdressers;
}

Future<List<int>> getTimeSlotOfHairdresser(
    HairdresserModel hairdresserModel, String date) async {
  List<int> result = new List<int>.empty(growable: true);
  var bookingRef = hairdresserModel.reference.collection(date);
  QuerySnapshot snapshot = await bookingRef.get();
  snapshot.docs.forEach((element) {
    result.add(int.parse(element.id));
  });
  return result;
}

Future<bool> checkStaffOfThisSalon(BuildContext context, WidgetRef ref) async {
  /// /AllSalon/Warszawa/Branch/2OfQtmNY72cikGHexEHq/Fryzjer/q9pmeSnolUxX7SEryW8V
  DocumentSnapshot hairdresserSnapshot = await FirebaseFirestore.instance
      .collection('AllSalon')
      .doc('${ref.read(selectedCity.state).state.name}')
      .collection('Branch')
      .doc(ref.read(selectedSalon.state).state.docId)
      .collection('Fryzjer')
      .doc(FirebaseAuth.instance.currentUser.uid)
      .get(); // porownanie uid personelu
  return hairdresserSnapshot.exists;
}

Future<List<int>> getBookingSlotOfHairdresser(
    BuildContext context, WidgetRef ref, String date) async {
  var hairdresserDocument = FirebaseFirestore.instance
      .collection('AllSalon')
      .doc('${ref.read(selectedCity.state).state.name}')
      .collection('Branch')
      .doc(ref.read(selectedSalon.state).state.docId)
      .collection('Fryzjer')
      .doc(FirebaseAuth.instance.currentUser.uid);

  List<int> result = new List<int>.empty(growable: true);
  var bookingRef = hairdresserDocument.collection(date);
  QuerySnapshot snapshot = await bookingRef.get();
  snapshot.docs.forEach((element) {
    result.add(int.parse(element.id));
  });
  return result;
}
