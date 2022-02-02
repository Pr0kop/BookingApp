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
import 'package:first_app/string/strings.dart';
import 'package:first_app/ui/components/staff_widgets/salon_list.dart';
import 'package:first_app/utils/utils.dart';
import 'package:first_app/view_model/staff_home/staff_home_view_model.dart';
import 'package:first_app/view_model/staff_home/staff_home_view_model_imp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'components/staff_widgets/appoiment_list.dart';
import 'components/staff_widgets/city_list.dart';

class StaffHome extends ConsumerWidget{

  final staffHomeViewModel = StaffHomeViewModelImp();

  @override
  Widget build(BuildContext context, ref) {
    var currentStaffStep = ref.watch(staffStep.state).state;
    var cityWatch = ref.watch(selectedCity.state).state;
    var salonWatch = ref.watch(selectedSalon.state).state;
    var dateWatch = ref.watch(selectedDate.state).state;
   // var selectTimeWatch = ref.watch(selectedTime.state).state;

    return SafeArea(
      child: Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Color(0xFFDFDFDF),
      appBar: AppBar(title: Text(currentStaffStep == 1 ? selectCityText : currentStaffStep == 2
          ? selectSalonText : currentStaffStep == 3 ? yourAppoinmentText : staffHomeText),
        backgroundColor: Color(0xFF383838),
      actions: [
        currentStaffStep == 3 ? InkWell(child: Icon(Icons.history),
          onTap: ()=> Navigator.of(context).pushNamed('/bookingHistory'),
        )
        : Container(

        )
      ],),
      body: Column(children: [

        Expanded(child: currentStaffStep == 1 ? staffDisplayCity(staffHomeViewModel, ref) : currentStaffStep == 2 ? staffdisplaySalon(staffHomeViewModel, ref, cityWatch.name)
            : currentStaffStep == 3 ? displayAppoiment(staffHomeViewModel, context, ref)
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
                        child: Text(previousText),
                      )),
                  SizedBox(width: 30,),
                  Expanded(
                      child: ElevatedButton(
                        onPressed: (currentStaffStep == 1
                            && ref.read(selectedCity.state).state.name.length == 0) ||
                            (currentStaffStep == 2 &&
                                ref.read(selectedSalon.state).state.docId == // docId!.length == 0
                                    null) ||
                            currentStaffStep == 3
                            ? null
                            : ()=> ref.read(staffStep.state).state++,
                        child: Text(nextText),
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


}