import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/cloud_firestore/all_salon_ref.dart';
import 'package:first_app/cloud_firestore/banner_ref.dart';
import 'package:first_app/cloud_firestore/user_ref.dart';
import 'package:first_app/model/city_model.dart';
import 'package:first_app/model/image_model.dart';
import 'package:first_app/model/salon_model.dart';
import 'package:first_app/model/user_model.dart';
import 'package:first_app/state/state_managment.dart';
import 'package:first_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class StaffHome extends ConsumerWidget{
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
      appBar: AppBar(title: Text(currentStaffStep == 1 ? 'Wybierz miasto' : currentStaffStep == 2
          ? 'Wybierz salon' : currentStaffStep == 3 ? 'Twoj kalendarz' : 'Personel'),backgroundColor: Color(0xFF383838),),
      body: Column(children: [

        Expanded(child: currentStaffStep == 1 ? displayCity(ref) : currentStaffStep == 2 ? displaySalon(ref, cityWatch.name)
            : currentStaffStep == 3 ? displayAppoiment(context, ref)
        : Container(), flex: 10,),
        //button
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
                        onPressed: currentStaffStep == 1 ? null : ()=> ref.read(staffStep.state).state--,
                        child: Text('Previous'),
                      )),
                  SizedBox(width: 30,),
                  Expanded(
                      child: ElevatedButton(
                        onPressed: (currentStaffStep == 1
                            && ref.read(selectedCity.state).state.name ==
                                null) ||
                            (currentStaffStep == 2 &&
                                ref.read(selectedSalon.state).state.docId ==
                                    null) ||
                            currentStaffStep == 3
                            ? null
                            : ()=> ref.read(staffStep.state).state++,
                        child: Text('Next'),
                      )),
                ],
              ),
            ),
          ),
        )
      ],

      ),
    ),
    );
  }

  displayCity(WidgetRef ref) {
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
              return GridView.builder(
                itemCount: cities.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                  itemBuilder: (context, index) {

                  return GestureDetector(
                    onTap: () =>  ref.read(selectedCity.state).state = cities[index],
                    child: Padding(padding: const EdgeInsets.all(8),
                    child: Card(
                      shape: ref.read(selectedCity.state).state.name == cities[index].name ?
                          RoundedRectangleBorder(side: BorderSide(color:Colors.green,width: 4),
                          borderRadius: BorderRadius.circular(5)) : null,
                      child: Center(child: Text('${cities[index].name}')),
                    )),
                  );

                  });
          }

        });

  }

  displaySalon(WidgetRef ref, String name) {

    return FutureBuilder(
        future: getSalonByCity(name),
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
                        shape: ref.read(selectedSalon.state).state.name == salons[index].name ?
                        RoundedRectangleBorder(side: BorderSide(color:Colors.green,width: 4),
                            borderRadius: BorderRadius.circular(5)) : null,
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

  displayAppoiment(BuildContext context, WidgetRef ref) {

    //spr czy uzytkownik pracuje jako personel w salonie
    return FutureBuilder(
        future: checkStaffOfThisSalon(context, ref),
        builder: (context,snapshot){
          if(snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator(),);
          else {

            var result = snapshot.data as bool;
            if(result) return displaySlot(context, ref);
            else return Center(child: Text('Nie jestes pracownikiem tego salonu!'),);
          }
        });
  }

  displaySlot(BuildContext context, WidgetRef ref) {
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
                future: getMaxAvailableTimeslot(ref.read(selectedDate.state).state),
                builder: (context,snapshot){
                  if(snapshot.connectionState == ConnectionState.waiting)
                    return Center(child: CircularProgressIndicator(),);
                  else
                  {
                    var maxTimeSlot = snapshot.data as int;
                    return FutureBuilder(

                      future: getBookingSlotOfHairdresser(context, ref, DateFormat('dd_MM_yyyy').format(ref.read(selectedDate.state).state)),
                      builder: (context,snapshot) {
                        if(snapshot.connectionState == ConnectionState.waiting)
                          return Center(child: CircularProgressIndicator(),);
                        else {
                          var listTimeSlot = snapshot.data as List<int>;
                          return GridView.builder(
                              itemCount: TIME_SLOT.length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                              itemBuilder: (context,index)=> GestureDetector(
                                onTap:
                                    !listTimeSlot.contains(index) ? null : () => processDoneServices(context, ref, index),

                                child: Card(
                                  color: listTimeSlot.contains(index) ? Colors.white10 : maxTimeSlot > index ? Colors.white60 : ref.read(selectedTime.state).state == TIME_SLOT.elementAt(index) ? Colors.white54 : Colors.white,
                                  child: GridTile(
                                    child: Center(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text('${TIME_SLOT.elementAt(index)}'),
                                          Text( listTimeSlot.contains(index) ? 'Zajęte' :
                                          maxTimeSlot > index ? 'Niedostępne'
                                              : 'Dostępne')
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

  processDoneServices(BuildContext context, WidgetRef ref, int index) {
    ref.read(selectedTimeSlot.state).state = index;
    Navigator.of(context).pushNamed('/doneService');

  }
}