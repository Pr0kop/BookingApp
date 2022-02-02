
import 'package:first_app/model/booking_model.dart';
import 'package:first_app/state/staff_user_history_state.dart';
import 'package:first_app/state/state_managment.dart';
import 'package:first_app/string/strings.dart';
import 'package:first_app/utils/utils.dart';
import 'package:first_app/view_model/hairdresser_booking_history/hairdresser_booking_history_view_model_imp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class HairdresserHistoryScreen extends ConsumerWidget{
  final hairdresserHistoryViewModel = HairdresserBookingHistoryViewModelImp();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var dateWatch = ref.watch(hairdresserHistorySelectedDate.state).state;
    return SafeArea(child: Scaffold(
      backgroundColor: Color(0XFFDFDFDF),
      appBar: AppBar(
        title: Text('Historia Fryzjera'),
        backgroundColor: Color(0xFF383838),

      ),
      body: Column(children: [
        Container(
            color: Color(0xFF008577),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child:
                Center(child: Padding(padding: const EdgeInsets.all(12), child: Column(children: [
                  Text('${DateFormat.MMMM().format(dateWatch)}',
                    style: GoogleFonts.robotoMono(color: Colors.white54),),
                  Text('${dateWatch.day}', style: GoogleFonts.robotoMono(color:Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                  Text('${DateFormat.EEEE().format(dateWatch)}',
                    style: GoogleFonts.robotoMono(color: Colors.white54),),
                ],),),),),
                GestureDetector(onTap: (){
                  DatePicker.showDatePicker(context,showTitleActions: true,
                      onConfirm: (date) => ref.read(selectedDate.state).state = date); // next time you can choose is 31 days next
                }, child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Icon(Icons.calendar_today, color:Colors.white),
                  ),
                ),)
              ],
            )
        ),
        FutureBuilder(
            future: hairdresserHistoryViewModel.getHairdresserBookingHistory(context, ref, dateWatch),
            builder: (context,snapshot){
              if(snapshot.connectionState == ConnectionState.waiting)
                return Center(child: CircularProgressIndicator(),);
              else{
                var userBookings = snapshot.data as List<BookingModel>;
                print(userBookings);
                print(snapshot);
                if(userBookings == null || userBookings.length == 0)
                  return Center(child: Text(historyHairdresserErrorText),);
                else
                  return FutureBuilder(
                      future: syncTime(),
                      builder: (context, snapshot){
                        if(snapshot.connectionState == ConnectionState.waiting)
                          return Center(child: CircularProgressIndicator(),);
                        else{
                          var syncTime = snapshot.data as DateTime;
                          print('time stamp');
                          print('SyncTime');
                          print(syncTime);
                          print('timestamp from millisecsincep');
                          print(DateTime.fromMillisecondsSinceEpoch(userBookings[0].timeStamp));
                          return  ListView.builder(
                              itemCount: userBookings.length,
                              itemBuilder:(context,index){
                                var isExpired = DateTime.fromMillisecondsSinceEpoch(userBookings[index].timeStamp)
                                    .isBefore(syncTime); // TUTAJ JEST ZMIANA  EXPIRED NA DATACH.
                                print(isExpired);
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

                                    ],),
                                );
                              });
                        }
                      });
              }


            })
      ]),// AppBar
    ));
  }

}

