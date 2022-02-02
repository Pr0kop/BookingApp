import 'package:first_app/model/hairdresser_model.dart';
import 'package:first_app/model/salon_model.dart';
import 'package:first_app/state/state_managment.dart';
import 'package:first_app/string/strings.dart';
import 'package:first_app/view_model/booking/booking_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';


displayHairdresser(BookingViewModel bookingViewModel,BuildContext context, WidgetRef ref, SalonModel salonModel) {
  return FutureBuilder(
      future: bookingViewModel.displayHairdresserBySalon(salonModel),
      builder: (context,snapshot){
        if(snapshot.connectionState == ConnectionState.waiting)
          return Center(child: CircularProgressIndicator(),);
        else{
          var hairdressers = snapshot.data as List<HairdresserModel>;
          if(hairdressers.length == 0)
            return Center(child: Text(hairdresserEmpty),);
          else
            return  ListView.builder(
                key: PageStorageKey('keep'),
                itemCount: hairdressers.length,
                itemBuilder:(context,index){
                  return GestureDetector(onTap: ()=> bookingViewModel.onSelectedHairdresser(context, ref, hairdressers[index]),
                    child: Card(child: ListTile(
                      leading: Icon(Icons.person, color: Colors.black,
                      ),
                      trailing: bookingViewModel.isHairdresserSelected(context, ref, hairdressers[index])
                          ? Icon(Icons.check)
                          : null,
                      title: Text('${hairdressers[index].name}', style: GoogleFonts.robotoMono(),),
                      subtitle: RatingBar.builder(
                        itemSize: 16,
                        allowHalfRating: true,
                        ignoreGestures: true,
                        initialRating: hairdressers[index].rating,
                        direction: Axis.horizontal,
                        itemCount: 5,
                        itemBuilder: (context,_) => Icon(Icons.star, color:Colors.amber),
                        itemPadding: const EdgeInsets.all(4),
                        onRatingUpdate: (val){},
                      ),
                    ),),);
                });
        }

      });

}