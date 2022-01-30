import 'package:first_app/cloud_firestore/all_salon_ref.dart';
import 'package:first_app/model/city_model.dart';
import 'package:first_app/state/state_managment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:im_stepper/stepper.dart';
import 'package:provider/src/provider.dart';
class BookingScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ref) {
    var step = ref.watch(currentStep.state).state;
    var cityWatch = ref.watch(selectedCity.state).state;
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
            Expanded(child: step == 1 ? displayCityList(context, ref)  : Container(),),
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
                                    onPressed: ref.read(selectedCity.state).state == '' ? null : step == 5
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
                    return GestureDetector(onTap: ()=> ref.read(selectedCity.state).state = cities[index].name,
                    child: Card(child: ListTile(
                    leading: Icon(Icons.home_work, color: Colors.black,
                    ),
                    trailing: ref.read(selectedCity.state).state ==
                    cities[index].name
                    ? Icon(Icons.check)
                        : null,
                    title: Text('${cities[index].name}', style: GoogleFonts.robotoMono(),),
                    ),),);
                  });
          }

        });
  }
}