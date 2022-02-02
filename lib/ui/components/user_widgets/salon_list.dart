import 'package:first_app/model/salon_model.dart';
import 'package:first_app/state/state_managment.dart';
import 'package:first_app/view_model/booking/booking_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

displaySalon(BookingViewModel bookingViewModel, BuildContext context, WidgetRef ref, String cityName) {
  print(cityName);
  return FutureBuilder(
      future: bookingViewModel.displaySalonByCity(cityName),
      builder: (context,snapshot){
        if(snapshot.connectionState == ConnectionState.waiting)
          return Center(child: CircularProgressIndicator(),);
        else{
          var salons = snapshot.data as List<SalonModel>;
          if(salons.length == 0)
            return Center(child: Text('Cannot load Salon list'),);
          else
            return  ListView.builder(
                key: PageStorageKey('keep'),
                itemCount: salons.length,
                itemBuilder:(context,index){
                  return GestureDetector(onTap: ()=> ref.read(selectedSalon.state).state = salons[index],
                    child: Card(child: ListTile(
                      leading: Icon(Icons.home_outlined, color: Colors.black,
                      ),
                      trailing: ref.read(selectedSalon.state).state.docId ==
                          salons[index].docId
                          ? Icon(Icons.check)
                          : null,
                      title: Text('${salons[index].name}', style: GoogleFonts.robotoMono(),),
                      subtitle: Text('${salons[index].address}', style: GoogleFonts.robotoMono(fontStyle: FontStyle.italic),),
                    ),),);
                });
        }

      });

}