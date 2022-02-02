

import 'package:first_app/cloud_firestore/all_salon_ref.dart';
import 'package:first_app/state/state_managment.dart';
import 'package:first_app/string/strings.dart';
import 'package:first_app/utils/utils.dart';
import 'package:first_app/view_model/staff_home/staff_home_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

displayAppoiment(StaffHomeViewModel staffHomeViewModel, BuildContext context, WidgetRef ref) {

  //spr czy uzytkownik pracuje jako personel w salonie
  return FutureBuilder(
      future: staffHomeViewModel.isStaff0fThisSalon(context, ref),
      builder: (context,snapshot){
        if(snapshot.connectionState == ConnectionState.waiting)
          return Center(child: CircularProgressIndicator(),);
        else {

          var result = snapshot.data as bool;
          if(result) return displaySlot(staffHomeViewModel, context, ref);
          else return Center(child: Text('Nie jestes pracownikiem tego salonu!'),);
        }
      });
}

displaySlot(StaffHomeViewModel staffHomeViewModel, BuildContext context, WidgetRef ref) {
  var now = ref.read(selectedDate.state).state;

  return Column(
      children: [
        Container(
            color: Color(0xFF008577),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child:
                Center(child: Padding(padding: const EdgeInsets.all(12), child: Column(children: [
                  Text('${DateFormat.MMMM().format(now)}',
                    style: GoogleFonts.robotoMono(color: Colors.white54),),
                  Text('${now.day}', style: GoogleFonts.robotoMono(color:Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                  Text('${DateFormat.EEEE().format(now)}',
                    style: GoogleFonts.robotoMono(color: Colors.white54),),
                ],),),),),
                GestureDetector(onTap: (){
                  DatePicker.showDatePicker(context,showTitleActions: true,
                      minTime: DateTime.now(),
                      maxTime: now.add(Duration(days: 31)),
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
        Expanded(
          child: FutureBuilder(
              future: staffHomeViewModel.displayMaxAvailableTimeSlot(ref.read(selectedDate.state).state),
              builder: (context,snapshot){
                if(snapshot.connectionState == ConnectionState.waiting)
                  return Center(child: CircularProgressIndicator(),);
                else
                {
                  var maxTimeSlot = snapshot.data as int;
                  return FutureBuilder(

                    future: staffHomeViewModel.displayBookingSlot0fHairdresser(context, ref, DateFormat('dd_MM_yyyy').format(ref.read(selectedDate.state).state)),
                    builder: (context,snapshot) {
                      if(snapshot.connectionState == ConnectionState.waiting)
                        return Center(child: CircularProgressIndicator(),);
                      else {
                        var listTimeSlot = snapshot.data as List<int>;
                        return GridView.builder(
                          key: PageStorageKey('keep'),
                            itemCount: TIME_SLOT.length,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                            itemBuilder: (context,index)=> GestureDetector(
                              onTap:
                              !listTimeSlot.contains(index) ? null : () => staffHomeViewModel.processDoneServices(context, ref, index),

                              child: Card(
                                color:staffHomeViewModel.getColorOfThisSlot(context, ref, listTimeSlot, index, maxTimeSlot),
                                child: GridTile(
                                  child: Center(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text('${TIME_SLOT.elementAt(index)}'),
                                        Text(
                                            listTimeSlot.contains(index) ? fullText :
                                            maxTimeSlot > index ? notAvailableText
                                                : availableText)
                                      ],),),
                                  header: ref.read(selectedTime.state).state == TIME_SLOT.elementAt(index) ? Icon(Icons.check):null,
                                ),),
                            ));
                      }

                    },
                  );
                }
              }
          ),
        )
      ]
  );
}

