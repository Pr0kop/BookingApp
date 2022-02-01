import 'package:carousel_slider/carousel_slider.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/cloud_firestore/all_salon_ref.dart';
import 'package:first_app/cloud_firestore/banner_ref.dart';
import 'package:first_app/cloud_firestore/services_ref.dart';
import 'package:first_app/cloud_firestore/user_ref.dart';
import 'package:first_app/model/booking_model.dart';
import 'package:first_app/model/city_model.dart';
import 'package:first_app/model/image_model.dart';
import 'package:first_app/model/salon_model.dart';
import 'package:first_app/model/service_model.dart';
import 'package:first_app/model/user_model.dart';
import 'package:first_app/state/state_managment.dart';
import 'package:first_app/string/strings.dart';
import 'package:first_app/utils/utils.dart';
import 'package:first_app/view_model/done_service/done_service_view_model.dart';
import 'package:first_app/view_model/done_service/done_service_view_model_imp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class DoneService extends ConsumerWidget{
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final doneServiceViewModel = DoneServiceViewModelImp();
  @override
  Widget build(BuildContext context, ref) {
    //chip choices nie trzyma stanu, wiec trzeba wyczyscic servicesSelected
    ref.read(selectedServices.state).state.clear();
    var currentStaffStep = ref.watch(staffStep.state).state;
    var cityWatch = ref.watch(selectedCity.state).state;
    var salonWatch = ref.watch(selectedSalon.state).state;
    var dateWatch = ref.watch(selectedDate.state).state;
    // var selectTimeWatch = ref.watch(selectedTime.state).state;

    return SafeArea(child: Scaffold(
      key:scaffoldKey,
      resizeToAvoidBottomInset: true,
      backgroundColor: Color(0xFFDFDFDF),
      appBar: AppBar(
        title: Text(doneServicesText),
        backgroundColor: Color(0xFF383838),),
      body: Column(children: [
        Padding(padding: const EdgeInsets.all(8),child:
        FutureBuilder(
          future: doneServiceViewModel.displayDetailBooking(context, ref, ref.read(selectedTimeSlot.state).state),
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
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                          Consumer(builder: (context,watch,_){
                            var servicesSelected = ref.watch(selectedServices.state).state;

                            return Text('Cena: ${ref.read(selectedBooking.state).state.totalPrice == 0 ? doneServiceViewModel.calculateTotalPrice(servicesSelected) : ref.read(selectedBooking.state).state.totalPrice} zł', style: GoogleFonts.robotoMono(fontSize: 22) ,);
                          }),
                              ref.read(selectedBooking.state).state.done ? Chip(label: Text('Zakończono'),) : Container()
                        ]),
                      ],
                    )
                  ),
                );

            }
          },
        )),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: FutureBuilder(
              future: doneServiceViewModel.displayServices(context, ref),
              builder: (context,snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting)
                return Center(child: CircularProgressIndicator(),);
              else {

                var services = snapshot.data as List<ServiceModel>;
                return Consumer(builder: (context,watch,_){
                  var servicesWatch = ref.watch(selectedServices.state).state;
                  return SingleChildScrollView(
                    child: Column(children: [

                      Wrap(
                        children: services.map((e) => Padding(
                          padding: const EdgeInsets.all(4),
                          child: ChoiceChip(
                            selected: doneServiceViewModel.isSelectedService(context, ref, e),
                            selectedColor: Colors.blue,
                            label: Text('${e.name}'),
                            labelStyle: TextStyle(color:Colors.white),
                            backgroundColor: Colors.teal,
                            onSelected: (isSelected) => doneServiceViewModel.onSelectedchip(context, ref, isSelected, e),
                          ),

                        )).toList(),
                      ),

                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                          onPressed:  doneServiceViewModel.isDone(context, ref)
                              ? null : servicesWatch.length > 0 ? () => doneServiceViewModel.finishService(context, ref, scaffoldKey) : null,
                          child: Text('ZAKOŃCZ', style: GoogleFonts.robotoMono(),),
                        ),
                      )
                    ],)
                  );
                });
              }
            }
          ),
        ))
      ]),
    ),
    );
  }




}