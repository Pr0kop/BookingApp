import 'package:first_app/state/state_managment.dart';
import 'package:first_app/string/strings.dart';
import 'package:first_app/view_model/booking/booking_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
displayConfirm(BookingViewModel bookingViewModel, BuildContext context, WidgetRef ref,
    GlobalKey<ScaffoldState> scaffoldKey) {

  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Expanded(flex: 1, child: Padding(padding: const EdgeInsets.all(24),
        child: Image.asset('assets/images/logo.png'),),),
      Expanded(flex: 3, child: Container(
          width: MediaQuery.of(context).size.width,
          child: Card(child: Padding(padding: const EdgeInsets.all(16), child:
          Column(
            children: [
              Text(thanksForBookingText.toUpperCase(),
                style: GoogleFonts.robotoMono(fontWeight: FontWeight.bold),),
              Text('Informacje o rezerwacji'.toUpperCase(),
                style: GoogleFonts.robotoMono(),),
              Row(children: [
                Icon(Icons.calendar_today),
                SizedBox(width: 20,),
                Text('${ref.read(selectedTime.state).state} - ${DateFormat('dd/MM/yyyy').format(ref.read(selectedDate.state).state)}'.toUpperCase(),
                  style: GoogleFonts.robotoMono(),)
              ]),
              SizedBox(height: 10,),
              Row(children: [
                Icon(Icons.person),
                SizedBox(width: 20,),
                Text('${ref.read(selectedHairdresser.state).state.name}'.toUpperCase(),
                  style: GoogleFonts.robotoMono(),)
              ]),
              SizedBox(height: 10,),
              Divider(thickness: 1,),
              Row(children: [
                Icon(Icons.home),
                SizedBox(width: 20,),
                Text('${ref.read(selectedSalon.state).state.name}'.toUpperCase(),
                  style: GoogleFonts.robotoMono(),)
              ]),
              SizedBox(height: 10,),
              Row(children: [
                Icon(Icons.location_on),
                SizedBox(width: 20,),
                Text('${ref.read(selectedSalon.state).state.address}'.toUpperCase(),
                  style: GoogleFonts.robotoMono(),)
              ]),
              SizedBox(height: 8,),
              ElevatedButton(onPressed: () => bookingViewModel.confirmBooking(context, ref, scaffoldKey),
                child: Text('Potwierdź'),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.black26)),
              )
            ], )
          ))))
    ],
  );

}