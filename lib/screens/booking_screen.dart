import 'package:first_app/cloud_firestore/all_salon_ref.dart';
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
class BookingScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ref) {
    var step = ref.watch(currentStep.state).state;
    var cityWatch = ref.watch(selectedCity.state).state;
    var salonWatch = ref.watch(selectedSalon.state).state;
    var hairdresserWatch = ref.watch(selectedHairdresser.state).state;
    var dateWatch = ref.watch(selectedDate.state).state;
    var timeWatch = ref.watch(selectedTime.state).state;

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
            Expanded(
              flex: 10,
              child: step == 1 ? displayCityList(context, ref)
                : step == 2
                ? displaySalon(context, ref, cityWatch.name) :
                step == 3 ? displayHairdresser(context, ref, salonWatch) : step == 4 ? displayTimeSlot(context, ref, hairdresserWatch)
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
                                        (step == 3 && ref.read(selectedHairdresser.state).state.docId == null) ||
                                        (step == 4 && ref.read(selectedTimeSlot.state).state == -1)
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
                          onRatingUpdate: (value){},
                          itemBuilder: (context,_) => Icon(Icons.star, color:Colors.amber),
                          itemPadding: const EdgeInsets.all(4),
                        ),
                      ),),);
                  });
          }

        });

  }

  displayTimeSlot(BuildContext context, WidgetRef ref, HairdresserModel hairdresserModel) {

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
                minTime: now,
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
          child: GridView.builder(
              itemCount: TIME_SLOT.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
            itemBuilder: (context,index)=> GestureDetector(
              onTap: (){
                ref.read(selectedTime.state).state = TIME_SLOT.elementAt(index);
              },
              child: Card(
                color: ref.read(selectedTime.state).state == TIME_SLOT.elementAt(index) ? Colors.white54 : Colors.white,
                child: GridTile(
                  child: Center(
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('${TIME_SLOT.elementAt(index)}'),
                      Text('Dostępne')
                    ],),),
                  header: ref.read(selectedTime.state).state == TIME_SLOT.elementAt(index) ? Icon(Icons.check):null,
                ),),
            )),
        )
      ]
    );


  }
}