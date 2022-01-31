import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/cloud_firestore/all_salon_ref.dart';
import 'package:first_app/cloud_firestore/user_ref.dart';
import 'package:first_app/model/booking_model.dart';
import 'package:first_app/model/city_model.dart';
import 'package:first_app/model/hairdresser_model.dart';
import 'package:first_app/model/salon_model.dart';
import 'package:first_app/state/state_managment.dart';
import 'package:first_app/utils/utils.dart';
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
import 'package:rflutter_alert/rflutter_alert.dart';

class UserHistory extends ConsumerWidget {

  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey();

  @override
  Widget build(BuildContext context, ref) {
    var watchRefresh = ref.watch(deleteFlagRefresh.state).state;
    return SafeArea(
        child: Scaffold(
          key:scaffoldKey,
          appBar: AppBar(title: Text('User History'),),
          resizeToAvoidBottomInset: true,
          backgroundColor: Color(0XFFFDF9EE),
          body: Padding(padding: const EdgeInsets.all(12), child: displayUserHistory(context, ref),)
        ));
  }
  displayUserHistory(context, ref){
    return FutureBuilder(
        future: getUserHistory(),
        builder: (context,snapshot){
          if(snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator(),);
          else{
            var userBookings = snapshot.data as List<BookingModel>;
            print(userBookings);
            print(snapshot);
            print(userBookings[0].slot);
            if(userBookings == null || userBookings.length == 0)
              return Center(child: Text('Cannot load booking history'),);
            else
              return FutureBuilder(
                  future: syncTime(),
                  builder: (context, snapshot){
                if(snapshot.connectionState == ConnectionState.waiting)
                  return Center(child: CircularProgressIndicator(),);
                else{
                  var syncTime = snapshot.data as DateTime;
                  print(userBookings[0].timeStamp);
                  print(syncTime);
                  print(DateTime.fromMillisecondsSinceEpoch(userBookings[0].timeStamp));
                  return  ListView.builder(
                      itemCount: userBookings.length,
                      itemBuilder:(context,index){
                        var isExpired = DateTime.fromMillisecondsSinceEpoch(userBookings[index].timeStamp)
                            .isAfter(syncTime); // TUTAJ JEST ZMIANA  EXPIRED NA DATACH.
                        return Card (
                          elevation: 8,
                          shape: RoundedRectangleBorder (
                              borderRadius: BorderRadius.all(Radius.circular(22))),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column (
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children:[
                                    Row (mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                      Column (children: [
                                        Text( 'Date', style: GoogleFonts.robotoMono (),),
                                        Text(DateFormat("dd/MM/yy").format(
                                            DateTime.fromMillisecondsSinceEpoch(userBookings[index].timeStamp)
                                        ),style: GoogleFonts.robotoMono(fontSize:22, fontWeight: FontWeight.bold),)
                                      ],),
                                      Column (children: [
                                        Text( 'Date', style: GoogleFonts.robotoMono (),),

                                        Text(TIME_SLOT.elementAt(userBookings[index].slot)
                                          , style: GoogleFonts.robotoMono(fontSize:22, fontWeight: FontWeight.bold),)
                                      ],)
                                    ],
                                    ),
                                    Divider (thickness: 1,),
                                    Column (mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row (
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '${userBookings[index].salonName}',
                                              style: GoogleFonts.robotoMono (
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              '${userBookings[index].hairdresserName}',
                                              style: GoogleFonts.robotoMono (),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          '${userBookings[index].salonAddress}',
                                          style: GoogleFonts.robotoMono (),
                                        ),
                                      ],),
                                  ],
                                ),
                              ),
                              GestureDetector(onTap: isExpired ? null : (){

                                Alert(
                                    context:context,
                                    type: AlertType.warning,
                                    title: 'Usuń Termin',
                                    desc: 'Pamiętaj by anulować powiadomienie w również w kalendarzu',
                                    buttons: [
                                      DialogButton(
                                        child: Text(
                                            'Anuluj',
                                            style: GoogleFonts.robotoMono(
                                                color: Colors.red)),
                                        onPressed: (){
                                          Navigator.of(context).pop();
                                          cancelBooking(context, userBookings[index], ref);
                                        },
                                        color: Colors.white,)
                                    ]
                                ).show();
                              } , child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(22),
                                        bottomLeft: Radius.circular(22)
                                    ),
                                  ),
                                  child: Row(mainAxisAlignment: MainAxisAlignment.center,children:[
                                    Padding(padding: const EdgeInsets.symmetric(vertical: 10),
                                      child: Text(userBookings[index].done ? 'Finish' :isExpired ? 'Expired' : 'Anuluj', style: GoogleFonts.robotoMono(color: isExpired ? Colors.grey : Colors.white),),)
                                  ])
                              ),)
                            ],),
                        );
                      });
                }
              });
          }


        });
  }

  void cancelBooking(BuildContext context, BookingModel bookingModel, WidgetRef ref) {
    var batch = FirebaseFirestore.instance.batch();
    var hairdresserBooking = FirebaseFirestore.instance
    .collection('AllSalon')
    .doc(bookingModel.cityBook)
    .collection('Branch')
    .doc(bookingModel.salonId)
    .collection('Fryzjer')
    .doc(bookingModel.hairdresserId)
    .collection(DateFormat('dd_MM_yyyy').format(DateTime.fromMillisecondsSinceEpoch(bookingModel.timeStamp)))
    .doc(bookingModel.slot.toString());
    var userBooking = bookingModel.reference;
    batch.delete(userBooking);
    batch.delete(hairdresserBooking);

    batch.commit().then((value) {

      //Refresh Data
      ref.read(deleteFlagRefresh.state).state = !ref.read(deleteFlagRefresh.state).state;
    });
  }


}