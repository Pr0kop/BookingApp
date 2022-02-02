import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_app/cloud_firestore/all_salon_ref.dart';
import 'package:first_app/cloud_firestore/services_ref.dart';
import 'package:first_app/model/booking_model.dart';
import 'package:first_app/model/service_model.dart';
import 'package:first_app/state/state_managment.dart';
import 'package:first_app/utils/utils.dart';
import 'package:first_app/view_model/done_service/done_service_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/material/scaffold.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class DoneServiceViewModelImp implements DoneServiceViewModel{
  @override
  double calculateTotalPrice(List<ServiceModel> serviceSelected) {
    return serviceSelected.map((item) => item.price)
        .fold(0,
            (value, element) => double.parse(value.toString()) + element);
  }

  @override
  Future<BookingModel> displayDetailBooking(BuildContext context, WidgetRef ref, int timeSlot) {
    return getDetailBooking(context, ref, timeSlot);
  }

  @override
  Future<List<ServiceModel>> displayServices(BuildContext context, WidgetRef ref) {
    return getServices(context, ref);
  }

  @override
  void finishService(BuildContext context, WidgetRef ref, GlobalKey<ScaffoldState> scaffoldKey) {
    var batch = FirebaseFirestore.instance.batch();

    var hairdresserBook = ref.read(selectedBooking.state).state;
    var userBook = FirebaseFirestore.instance
        .collection('User')
        .doc('${hairdresserBook.customerPhone}')
        .collection('Booking_${hairdresserBook.customerId}')
        .doc('${hairdresserBook.hairdresserId}_${DateFormat('dd_MM_yyyy').format(
        DateTime.fromMillisecondsSinceEpoch(hairdresserBook.timeStamp))}');

    Map<String, dynamic> updateDone = new Map();
    updateDone['done'] = true;
    updateDone['services'] = convertServices(ref.read(selectedServices.state).state);
    updateDone['totalPrice'] = ref.read(selectedServices.state).state
        .map((e)=>e.price).fold(0, (previousValue, element) => double.parse(previousValue.toString()) + element);

    batch.update(userBook, updateDone);
    batch.update(hairdresserBook.reference, updateDone);

    batch.commit().then((value){
      ScaffoldMessenger.of(scaffoldKey.currentContext)
          .showSnackBar(SnackBar(content: Text('Proces udany!')))
          .closed
          .then((v) => Navigator.of(context).pop());

    });
  }

  @override
  bool isDone(BuildContext context, WidgetRef ref) {
    return ref.read(selectedBooking.state).state.done;
  }

  @override
  bool isSelectedService(BuildContext context, WidgetRef ref, ServiceModel serviceModel) {
    return ref.read(selectedServices.state).state.contains(serviceModel);
  }

  @override
  void onSelectedchip(BuildContext context, WidgetRef ref, bool isSelected, ServiceModel e) {
    var list = ref
        .read(selectedServices.state)
        .state;
    if (isSelected) {
      list.add(e);
      ref
          .read(selectedServices.state)
          .state = list;
    }
    else {
      list.remove(e);
      ref
          .read(selectedServices.state)
          .state = list;
    }
  }

}