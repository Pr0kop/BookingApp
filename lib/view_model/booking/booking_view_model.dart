import 'package:first_app/model/city_model.dart';
import 'package:first_app/model/hairdresser_model.dart';
import 'package:first_app/model/salon_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class BookingViewModel {
  //City
  Future<List<CityModel>> displayCities();

  void onSelectedCity(BuildContext context, WidgetRef ref, CityModel cityModel);

  bool isCitySelected(BuildContext context, WidgetRef ref, CityModel cityModel);

  //Salon
  Future<List<SalonModel>> displaySalonByCity(String cityName);
  void onSelectedSalon(BuildContext context, WidgetRef ref, SalonModel salonModel);
  bool isSalonSelected(BuildContext context, WidgetRef ref, SalonModel salonModel);

  //Hairdresser
  Future<List<HairdresserModel>> displayHairdresserBySalon(SalonModel salonModel);
  void onSelectedHairdresser(BuildContext context, WidgetRef ref, HairdresserModel hairdresserModel);
  bool isHairdresserSelected(BuildContext context, WidgetRef ref, HairdresserModel hairdresserModel);

  //Timeslot
  Future<int> displayMaxAvailableTimeslot(DateTime dt);
  Future<List<int>> displayTimeSlotOfHairdresser(HairdresserModel hairdresserModel, String date);
  bool isAvailableForTapTimeSlot(int maxTime,
      int index,
      List<int> listTimeSlot);
  void onSelectedTimeSlot(BuildContext context, WidgetRef ref, int index);
  Color displayColorTimeSLot(BuildContext context,
      WidgetRef ref,
      List<int> listTimeSlot,
      int index,
      int maxTimeSlot);

  void confirmBooking(BuildContext context, WidgetRef ref, GlobalKey<ScaffoldState> scaffoldKey);
}