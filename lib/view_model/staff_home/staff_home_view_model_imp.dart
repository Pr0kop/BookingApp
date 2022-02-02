

import 'package:first_app/cloud_firestore/all_salon_ref.dart';
import 'package:first_app/model/city_model.dart';
import 'package:first_app/model/salon_model.dart';
import 'package:first_app/state/state_managment.dart';
import 'package:first_app/utils/utils.dart';
import 'package:first_app/view_model/staff_home/staff_home_view_model.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'staff_home_view_model.dart';

import 'package:flutter/material.dart';


class StaffHomeViewModelImp implements StaffHomeViewModel{

  @override
  Future<List<CityModel>> displayCities() {
    return getCities();
  }

  @override
  bool isCitySelected(BuildContext context, WidgetRef ref, CityModel cityModel) {
    return ref.read(selectedCity.state).state.name == cityModel.name;
  }

  @override
  void onSelectedCity(BuildContext context, WidgetRef ref, CityModel cityModel) {
    ref.read(selectedCity.state).state = cityModel;
  }

  @override
  Future<List<SalonModel>> displaySalonByCity(String cityName) {
    return getSalonByCity(cityName);
  }

  @override
  bool isSalonSelected(BuildContext context, WidgetRef ref, SalonModel salonModel) {
    return ref.read(selectedSalon.state).state.docId == salonModel.docId;
  }

  @override
  void onSelectedSalon(BuildContext context, WidgetRef ref, SalonModel salonModel) {
    ref.read(selectedSalon.state).state = salonModel;
  }

  @override
  Future<List<int>> displayBookingSlot0fHairdresser(BuildContext context, WidgetRef ref, String date) {
    return getBookingSlotOfHairdresser(context, ref, date);
  }

  @override
  Future<int> displayMaxAvailableTimeSlot(DateTime dt) {
    return getMaxAvailableTimeslot(dt);
  }

  @override
  Future<bool> isStaff0fThisSalon(BuildContext context, WidgetRef ref) {
    return checkStaffOfThisSalon(context, ref);
  }

  @override
  bool isTimeSlotBooked(List<int> listTimeSlot, int index) {
    return listTimeSlot.contains (index) ? false: true;
  }

  @override
  void processDoneServices(BuildContext context, WidgetRef ref, int index) {
    ref.read(selectedTimeSlot.state).state = index;
    Navigator.of(context).pushNamed('/doneService');

  }

  @override
  Color getColorOfThisSlot(BuildContext context, WidgetRef ref, List<int> listTimeSlot, int index, int maxTimeSlot) {
    return listTimeSlot.contains(index) ?
    Colors.white10 : maxTimeSlot > index ? Colors.white60 : ref.read(selectedTime.state).state == TIME_SLOT.elementAt(index) ?
    Colors.white54 : Colors.white;
  }

}