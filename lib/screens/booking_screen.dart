import 'package:first_app/cloud_firestore/all_salon_ref.dart';
import 'package:first_app/model/city_model.dart';
import 'package:first_app/model/hairdresser_model.dart';
import 'package:first_app/model/salon_model.dart';
import 'package:first_app/state/state_managment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:im_stepper/stepper.dart';
import 'package:provider/src/provider.dart';
class BookingScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ref) {
    var step = ref.watch(currentStep.state).state;
    var cityWatch = ref.watch(selectedCity.state).state;
    var salonWatch = ref.watch(selectedSalon.state).state;
    var hairdresserWatch = ref.watch(selectedHairdresser.state).state;
    return SafeArea(
        child: Scaffold(
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
            Expanded(child: step == 1 ? displayCityList(context, ref)
                : step == 2
                ? displaySalon(context, ref, cityWatch.name) :
                step == 3 ? displayHairdresser(context, ref, salonWatch)
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
                                    onPressed: (step == 1 && ref.read(selectedCity.state).state.name == null) ||
                                        (step == 2 && ref.read(selectedSalon.state).state.docId == null) ||
                                        (step == 3 && ref.read(selectedHairdresser.state).state.docId == null)
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

  displayCityList(context, ref){
    return FutureBuilder(
        future: getCities(),
        builder: (context,snapshot){
          if(snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator(),);
          else{
            var cities = snapshot.data as List<CityModel>;
            if(cities == null || cities.length == 0)
              return Center(child: Text('Cannot load city list'),);
            else
              return  ListView.builder(
                  itemCount: cities.length,
                  itemBuilder:(context,index){
                    return GestureDetector(onTap: ()=> ref.read(selectedCity.state).state = cities[index],
                    child: Card(child: ListTile(
                    leading: Icon(Icons.home_work, color: Colors.black,
                    ),
                    trailing: ref.read(selectedCity.state).state.name ==
                    cities[index]
                    ? Icon(Icons.check)
                        : null,
                    title: Text('${cities[index].name}', style: GoogleFonts.robotoMono(),),
                    ),),);
                  });
          }

        });
  }

  displaySalon(BuildContext context, WidgetRef ref, String cityName) {
    return FutureBuilder(
        future: getSalonByCity(cityName),
        builder: (context,snapshot){
          if(snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator(),);
          else{
            var salons = snapshot.data as List<SalonModel>;
            if(salons == null || salons.length == 0)
              return Center(child: Text('Cannot load Salon list'),);
            else
              return  ListView.builder(
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

  displayHairdresser(BuildContext context, WidgetRef ref, SalonModel salonModel) {
    return FutureBuilder(
        future: getHairdressersBySalon(salonModel),
        builder: (context,snapshot){
          if(snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator(),);
          else{
            var hairdressers = snapshot.data as List<HairdresserModel>;
            if(hairdressers == null || hairdressers.length == 0)
              return Center(child: Text('Hairdresser list is empty'),);
            else
              return  ListView.builder(
                  itemCount: hairdressers.length,
                  itemBuilder:(context,index){
                    return GestureDetector(onTap: ()=> ref.read(selectedHairdresser.state).state = hairdressers[index],
                      child: Card(child: ListTile(
                        leading: Icon(Icons.person, color: Colors.black,
                        ),
                        trailing: ref.read(selectedHairdresser.state).state.docId ==
                            hairdressers[index].docId
                            ? Icon(Icons.check)
                            : null,
                        title: Text('${hairdressers[index].name}', style: GoogleFonts.robotoMono(),),
                        subtitle: RatingBar.builder(
                          itemSize: 16,
                          allowHalfRating: true,
                          initialRating: hairdressers[index].rating,
                          direction: Axis.horizontal,
                          itemCount: 5,
                          itemBuilder: (context,_) => Icon(Icons.star, color:Colors.amber),
                          itemPadding: const EdgeInsets.all(4),
                        ),
                      ),),);
                  });
          }

        });

  }
}