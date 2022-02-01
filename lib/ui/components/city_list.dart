import 'package:first_app/model/city_model.dart';
import 'package:first_app/state/state_managment.dart';
import 'package:first_app/string/strings.dart';
import 'package:first_app/view_model/booking/booking_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


displayCityList(BookingViewModel bookingViewModel, context, ref){
  return FutureBuilder(
      future: bookingViewModel.displayCities(),
      builder: (context,snapshot){
        if(snapshot.connectionState == ConnectionState.waiting)
          return Center(child: CircularProgressIndicator(),);
        else{
          var cities = snapshot.data as List<CityModel>;
          if(cities.length == 0)
            return Center(child: Text(cannotLoadCity),);
          else
            return  ListView.builder(
                key: PageStorageKey('keep'),
                itemCount: cities.length,
                itemBuilder:(context,index){
                  return GestureDetector(
                    onTap: ()=> bookingViewModel.onSelectedCity(context, ref, cities[index]),
                    child: Card(child: ListTile(
                      leading: Icon(Icons.home_work, color: Colors.black,
                      ),
                      trailing: bookingViewModel.isCitySelected(context, ref, cities[index])
                          ? Icon(Icons.check)
                          : null,
                      title: Text('${cities[index].name}', style: GoogleFonts.robotoMono(),),
                    ),),);
                });
        }

      });
}