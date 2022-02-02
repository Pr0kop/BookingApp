

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/model/booking_model.dart';
import 'package:first_app/state/state_managment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'hairdresser_booking_history_view_model.dart';

class HairdresserBookingHistoryViewModelImp implements HairdresserBookingHistoryViewModel {

  @override
  Future<List<BookingModel>> getHairdresserBookingHistory(BuildContext context, WidgetRef ref, DateTime dateTime)async {
    var listBooking = List<BookingModel>.empty(growable: true);
    var hairdresserDocument = FirebaseFirestore.instance
        .collection('AllSalon')
        .doc('${ref.read(selectedCity.state).state.name}')
        .collection('Branch')
        .doc ('${ref.read(selectedSalon.state).state.docId}')
        .collection('Barber')
        .doc ('${FirebaseAuth.instance.currentUser.uid}')
        .collection(DateFormat('dd_MM_yyVy').format(dateTime));

    var snapshot = await hairdresserDocument.get();
    snapshot.docs.forEach((element){
      var hairdresserBooking = BookingModel.fromJson(element.data());
      hairdresserBooking.docId = element.id;
      hairdresserBooking.reference = element.reference;
      listBooking.add (hairdresserBooking);
    });
    return listBooking;
  }
}