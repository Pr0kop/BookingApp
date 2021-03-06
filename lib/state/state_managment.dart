

import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/model/booking_model.dart';
import 'package:first_app/model/city_model.dart';
import 'package:first_app/model/hairdresser_model.dart';
import 'package:first_app/model/salon_model.dart';
import 'package:first_app/model/service_model.dart';
import 'package:first_app/model/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userLogged = StateProvider((ref) => FirebaseAuth.instance.currentUser);
final userToken = StateProvider((ref)=>'');
final forceReload = StateProvider((ref)=> false);

final userInformation = StateProvider((ref)=> UserModel(address: '', name: ''));

//Booking state
final currentStep = StateProvider((ref) => 1);
final selectedCity = StateProvider((ref)=>CityModel(name: ''));
final selectedSalon = StateProvider((ref)=>SalonModel(address: '', name: ''));
final selectedHairdresser = StateProvider((ref)=>HairdresserModel());
final selectedDate = StateProvider ((ref)=> DateTime.now());
final selectedTimeSlot = StateProvider ((ref)=> -1);
final selectedTime = StateProvider ((ref)=> '');

//Deleting Booking
final deleteFlagRefresh = StateProvider((ref) => false);

//Personel
final staffStep = StateProvider((ref) => 1);
final selectedBooking = StateProvider((ref) =>
    BookingModel(
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
    slot: 0));


final selectedServices = StateProvider((ref) => List<ServiceModel>.empty(growable: true));