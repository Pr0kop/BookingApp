import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/cloud_firestore/all_salon_ref.dart';
import 'package:first_app/cloud_firestore/banner_ref.dart';
import 'package:first_app/cloud_firestore/user_ref.dart';
import 'package:first_app/model/booking_model.dart';
import 'package:first_app/model/city_model.dart';
import 'package:first_app/model/image_model.dart';
import 'package:first_app/model/salon_model.dart';
import 'package:first_app/model/user_model.dart';
import 'package:first_app/state/state_managment.dart';
import 'package:first_app/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class DoneService extends ConsumerWidget{
  @override
  Widget build(BuildContext context, ref) {



    var currentStaffStep = ref.watch(staffStep.state).state;
    var cityWatch = ref.watch(selectedCity.state).state;
    var salonWatch = ref.watch(selectedSalon.state).state;
    var dateWatch = ref.watch(selectedDate.state).state;
    // var selectTimeWatch = ref.watch(selectedTime.state).state;

    return SafeArea(child: Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Color(0xFFDFDFDF),
      appBar: AppBar(
        title: Text('Wykonane usługi'),
        backgroundColor: Color(0xFF383838),),
      body: Column(children: [
        Padding(padding: const EdgeInsets.all(8),child:
        FutureBuilder(
          future: getDetailBooking(context, ref, ref.read(selectedTimeSlot.state).state),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );}
              else {
                var bookingModel = snapshot.data as BookingModel;
                return Card(
                  elevation: 8,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          CircleAvatar(
                            child: Icon(Icons.account_box_rounded, color:Colors.white),
                            backgroundColor: Colors.black,
                          ),
                          SizedBox(width: 30,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${bookingModel.customerName}', style: GoogleFonts.robotoMono(fontSize: 22,fontWeight: FontWeight.bold),),
                              Text('${bookingModel.customerPhone}', style: GoogleFonts.robotoMono(fontSize: 18,),)
                            ]
                          )
                        ]),
                        Divider(thickness: 2,),
                        Row(children: [
                          Consumer(builder: (context,watch,_){
                           // var servicesSelected = ref.watch(selectedServices.state).state;
                            return Text('Cena: ${1000}zł');
                          })
                        ])
                      ],
                    )
                  ),
                );

            }
          },
        ))
      ]),
    ),
    );
  }


}