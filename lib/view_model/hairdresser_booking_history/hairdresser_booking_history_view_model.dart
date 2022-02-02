

import 'package:first_app/model/booking_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class HairdresserBookingHistoryViewModel {
  Future<List<BookingModel>> getHairdresserBookingHistory(BuildContext context, WidgetRef ref,
      DateTime dateTime);
}