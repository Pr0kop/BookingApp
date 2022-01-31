import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_app/model/city_model.dart';
import 'package:first_app/model/hairdresser_model.dart';
import 'package:first_app/model/salon_model.dart';

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
    if(cityName == 'Białystok')
      cityName = 'Bialystok';
    var salonRef = FirebaseFirestore.instance.collection('AllSalon').doc(cityName.replaceAll(' ', '')).collection('Branch');
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

Future<List<int>> getTimeSlotOfHairdresser(HairdresserModel hairdresserModel, String date) async {

  List<int> result = new List<int>.empty(growable:true);
  var bookingRef = hairdresserModel.reference.collection(date);
  QuerySnapshot snapshot = await bookingRef.get();
  snapshot.docs.forEach((element) {
    result.add(int.parse(element.id));
  });
  return result;
}