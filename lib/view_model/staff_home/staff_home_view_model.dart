import 'package:first_app/model/city_model.dart';
import 'package:first_app/model/salon_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class StaffHomeViewModel {
  //City
  Future<List<CityModel>> displayCities();
  void onSelectedCity(BuildContext context, WidgetRef ref, CityModel cityModel);
  bool isCitySelected(BuildContext context, WidgetRef ref, CityModel cityModel);

  //Salon
  Future<List<SalonModel>> displaySalonByCity(String cityName);
  void onSelectedSalon(BuildContext context, WidgetRef ref, SalonModel salonModel);
  bool isSalonSelected(BuildContext context, WidgetRef ref, SalonModel salonModel);

  //Appoinment
  Future<bool> isStaff0fThisSalon (BuildContext context, WidgetRef ref);
  Future<int> displayMaxAvailableTimeSlot(DateTime dt);
  Future<List<int>> displayBookingSlot0fHairdresser (BuildContext context, WidgetRef ref, String date);
  bool isTimeSlotBooked (List<int> listTimeSlot, int index);
  void processDoneServices (BuildContext context, WidgetRef ref, int index);
  Color getColorOfThisSlot(BuildContext context, WidgetRef ref, List<int> listTimeSlot, int index, int maxTimeSlot);
}