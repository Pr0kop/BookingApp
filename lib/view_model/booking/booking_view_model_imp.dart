import 'dart:ui';

import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/cloud_firestore/all_salon_ref.dart';
import 'package:first_app/model/booking_model.dart';
import 'package:first_app/model/city_model.dart';
import 'package:first_app/model/hairdresser_model.dart';
import 'package:first_app/model/salon_model.dart';
import 'package:first_app/state/state_managment.dart';
import 'package:first_app/string/strings.dart';
import 'package:first_app/utils/utils.dart';
import 'package:flutter/material.dart';

import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'booking_view_model.dart';

class BookingViewModelImp implements BookingViewModel{
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
  Future<List<HairdresserModel>> displayHairdresserBySalon(SalonModel salonModel) {
    return getHairdressersBySalon(salonModel);
  }

  @override
  bool isHairdresserSelected(BuildContext context, WidgetRef ref, HairdresserModel hairdresserModel) {
    return ref.read(selectedHairdresser.state).state.docId == hairdresserModel.docId;
  }

  @override
  void onSelectedHairdresser(BuildContext context, WidgetRef ref, HairdresserModel hairdresserModel) {
    ref.read(selectedHairdresser.state).state = hairdresserModel;
  }

  @override
  Color displayColorTimeSLot(BuildContext context, WidgetRef ref, List<int> listTimeSlot, int index, int maxTimeSlot) {
    return listTimeSlot.contains(index)
        ? Colors.white10
        : maxTimeSlot > index
        ? Colors.white60
        : ref
        .read(selectedTime.state)
        .state ==
        TIME_SLOT.elementAt(index)
        ? Colors.white54
        : Colors.white;
  }

  @override
  Future<int> displayMaxAvailableTimeslot(DateTime dt) {
    return getMaxAvailableTimeslot(dt);
  }

  @override
  Future<List<int>> displayTimeSlotOfHairdresser(HairdresserModel hairdresserModel, String date) {
    return getTimeSlotOfHairdresser(hairdresserModel, date);
  }

  @override
  bool isAvailableForTapTimeSlot(int maxTime, int index, List<int> listTimeSlot) {
    return (maxTime > index) || listTimeSlot.contains(index);
  }

  @override
  void onSelectedTimeSlot(BuildContext context, WidgetRef ref, int index) {
    ref.read(selectedTimeSlot.state).state = index;
    ref.read(selectedTime.state).state = TIME_SLOT.elementAt(index);
  }

  @override
  void confirmBooking(BuildContext context, WidgetRef ref, GlobalKey<ScaffoldState> scaffoldKey) {

    var hour = ref.read(selectedTime.state).state.length <= 10 ? int.parse(ref.read(selectedTime.state).state.split(':')[0].substring(0,1)) :
    int.parse(ref.read(selectedTime.state).state.split(':')[0].substring(0,2));

    var minutes =  ref.read(selectedTime.state).state.length <= 10 ? int.parse(ref.read(selectedTime.state).state.split(':')[1].substring(0,1)) :
    int.parse(ref.read(selectedTime.state).state.split(':')[1].substring(0,2));
    var timeStamp = DateTime (
        ref.read(selectedDate.state).state.year,
        ref.read(selectedDate.state).state.month,
        ref.read(selectedDate.state).state.day,
        hour,
        minutes
    ).millisecondsSinceEpoch;
    //Create booking Model
    var bookingModel = BookingModel(
        totalPrice: 0,
        hairdresserId : ref.read(selectedHairdresser.state).state.docId,
        hairdresserName : ref.read(selectedHairdresser.state).state.name,
        cityBook : ref.read(selectedCity.state).state.name,
        customerId: FirebaseAuth.instance.currentUser.uid,
        customerName : ref.read(userInformation.state).state.name,
        customerPhone : FirebaseAuth.instance.currentUser.phoneNumber,
        done : false,
        salonAddress : ref.read(selectedSalon.state).state.address,
        salonId : ref.read(selectedSalon.state).state.docId,
        salonName : ref.read(selectedSalon.state).state.name,
        slot : ref.read(selectedTimeSlot.state).state,
        timeStamp : timeStamp,
        time :
        '${ref.read(selectedTime.state).state} - ${DateFormat('dd/MM/yyyy').format(ref.read(selectedDate.state).state)}'

    );
    //submit on firestore

    var batch = FirebaseFirestore.instance.batch();

    DocumentReference hairdresserBooking = ref
        .read(selectedHairdresser.state)
        .state
        .reference
        .collection(
        '${DateFormat('dd_MM_yyyy').format(ref.read(selectedDate.state).state)}')
        .doc(ref.read(selectedTimeSlot.state).state.toString());

    DocumentReference userBooking = FirebaseFirestore.instance.collection('User')
        .doc(FirebaseAuth.instance.currentUser.phoneNumber)
        .collection('Booking_${FirebaseAuth.instance.currentUser.uid}')
        .doc('${ref.read(selectedHairdresser.state).state.docId}_${DateFormat('dd_MM_yyyy')
        .format(ref.read(selectedDate.state).state)}');

    batch.set(hairdresserBooking, bookingModel.toJson());
    batch.set(userBooking, bookingModel.toJson());
    batch.commit().then((value) {

      Navigator.of(context).pop();
      ScaffoldMessenger.of(scaffoldKey.currentContext)
          .showSnackBar(SnackBar(content: Text('Zarezerwowano pomyślnie'),));

      //Event creation
      final event = Event(
          title: titleText,
          description: 'Wizyta fryzjerska ${ref.read(selectedTime.state).state} - '
              '${DateFormat('dd/MM/yyyy').format(ref.read(selectedDate.state).state)}',
          location: '${ref.read(selectedSalon.state).state.address}',
          startDate: DateTime(
              ref.read(selectedDate.state).state.year,
              ref.read(selectedDate.state).state.month,
              ref.read(selectedDate.state).state.day,
              hour,
              minutes
          ),
          endDate: DateTime(
              ref.read(selectedDate.state).state.year,
              ref.read(selectedDate.state).state.month,
              ref.read(selectedDate.state).state.day,
              hour,
              minutes+30
          ),
          iosParams: IOSParams(reminder: Duration (minutes: 30)),
          androidParams: AndroidParams (emailInvites: [])
      );
      Add2Calendar.addEvent2Cal(event).then((value) {

      });
      // Reset value
      ref.read(selectedDate.state).state = DateTime.now();
      ref.read(selectedHairdresser.state).state = HairdresserModel();
      ref.read(selectedCity.state).state = CityModel(name: '');
      ref.read(selectedSalon.state).state = SalonModel(name: '', address: '');
      ref.read(currentStep.state).state = 1;
      ref.read(selectedTime.state).state = '';
      ref.read(selectedTimeSlot.state).state = -1;
    });



  }

}