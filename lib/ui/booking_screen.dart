import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/cloud_firestore/all_salon_ref.dart';
import 'package:first_app/model/booking_model.dart';
import 'package:first_app/model/city_model.dart';
import 'package:first_app/model/hairdresser_model.dart';
import 'package:first_app/model/salon_model.dart';
import 'package:first_app/state/state_managment.dart';
import 'package:first_app/utils/utils.dart';
import 'package:first_app/view_model/booking/booking_view_model_imp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:im_stepper/stepper.dart';
import 'package:intl/intl.dart';
import 'package:provider/src/provider.dart';

import 'components/city_list.dart';
import 'components/confirm.dart';
import 'components/hairdresser_list.dart';
import 'components/salon_list.dart';
import 'components/time_slot.dart';
class BookingScreen extends ConsumerWidget {

  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final bookingViewModel = new BookingViewModelImp();

  @override
  Widget build(BuildContext context, ref) {
    var step = ref.watch(currentStep.state).state;
    var cityWatch = ref.watch(selectedCity.state).state;
    var salonWatch = ref.watch(selectedSalon.state).state;
    var hairdresserWatch = ref.watch(selectedHairdresser.state).state;
    var dateWatch = ref.watch(selectedDate.state).state;
    var timeWatch = ref.watch(selectedTime.state).state;
    var timeSlotWatch = ref.watch(selectedTimeSlot.state).state;

    return SafeArea(
        child: Scaffold(
          key:scaffoldKey,
          appBar: AppBar(title: Text('Booking'),),
          resizeToAvoidBottomInset: true,
          backgroundColor: Color(0XFFFDF9EE),
          body: Column(children:[
            NumberStepper(
              activeStep: step-1,
              direction: Axis.horizontal,
              enableNextPreviousButtons: false,
              enableStepTapping: false,
              numbers: [1,2,3,4,5],
              stepColor: Colors.black,
              activeStepColor: Colors.grey,
              numberStyle: TextStyle(color: Colors.white),
            ),
            //Screen
            Expanded(
              flex: 10,
              child: step == 1 ? displayCityList(bookingViewModel, context, ref)
                : step == 2
                ? displaySalon(bookingViewModel ,context, ref, cityWatch.name) :
                step == 3
                    ? displayHairdresser(bookingViewModel ,context, ref, salonWatch)
                    : step == 4
                            ? displayTimeSlot(bookingViewModel, context, ref, hairdresserWatch) :
                    step == 5 ? displayConfirm(bookingViewModel, context, ref, scaffoldKey)
                : Container(),),
            Expanded(
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: ElevatedButton(
                                  onPressed: step == 1 ? null : ()=> ref.read(currentStep.state).state--,
                                  child: Text('Previous'),
                                )),
                            SizedBox(width: 30,),
                            Expanded(
                                child: ElevatedButton(
                                    onPressed: (step == 1 && ref.read(selectedCity.state).state.name.length == 0) ||
                                        (step == 2 && ref.read(selectedSalon.state).state.docId.length == 0) ||
                                        (step == 3 && ref.read(selectedHairdresser.state).state.docId.length == 0) ||
                                        (step == 4 && ref.read(selectedTimeSlot.state).state == -1)
                                        ? null : step == 5
                                        ? null
                                        : ()=> ref.read(currentStep.state).state++,
                                  child: Text('Next'),
                                )),
                          ],
                        ),
                    ),
                ),
            )
          ],),
        ));
  }












}