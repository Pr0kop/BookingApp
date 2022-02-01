import 'package:first_app/model/booking_model.dart';
import 'package:first_app/model/service_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class DoneServiceViewModel{
  Future<BookingModel> displayDetailBooking(BuildContext context, WidgetRef ref, int timeSlot);
  Future<List<ServiceModel>> displayServices(BuildContext context, WidgetRef ref);
  void finishService(BuildContext context, WidgetRef ref, GlobalKey<ScaffoldState> scaffoldKey);
  double calculateTotalPrice(List<ServiceModel> serviceModel);
  bool isDone(BuildContext context, WidgetRef ref);
  bool isSelectedService(BuildContext context, WidgetRef ref, ServiceModel serviceModel);
  void onSelectedchip(BuildContext context, WidgetRef ref, bool isSelected, ServiceModel e);
}