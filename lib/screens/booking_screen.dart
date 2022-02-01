import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/cloud_firestore/all_salon_ref.dart';
import 'package:first_app/model/booking_model.dart';
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

  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey();

  @override
  Widget build(BuildContext context, ref) {
    var step = ref.watch(currentStep.state).state;
    var cityWatch = ref.watch(selectedCity.state).state;
    var salonWatch = ref.watch(selectedSalon.state).state;
    var hairdresserWatch = ref.watch(selectedHairdresser.state).state;
    var dateWatch = ref.watch(selectedDate.state).state;
    var timeWatch = ref.watch(selectedTime.state).state;
    var timeSlotWatch = ref.watch(selectedTimeSlot.state).state;

    return SafeArea(
        child: Scaffold(
          key:scaffoldKey,
          appBar: AppBar(title: Text('Booking'),),
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
                step == 3 ? displayHairdresser(context, ref, salonWatch) : step == 4 ? displayTimeSlot(context, ref, hairdresserWatch) :
                    step == 5 ? displayConfirm(context, ref)
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
                    cities[index].name
                    ? Icon(Icons.check)
                        : null,
                    title: Text('${cities[index].name}', style: GoogleFonts.robotoMono(),),
                    ),),);
                  });
          }

        });
  }

  displaySalon(BuildContext context, WidgetRef ref, String cityName) {
    print(cityName);
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
                          ignoreGestures: true,
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

                    future: getTimeSlotOfHairdresser(hairdresserModel, DateFormat('dd_MM_yyyy').format(ref.read(selectedDate.state).state)),
                    builder: (context,snapshot) {
                      if(snapshot.connectionState == ConnectionState.waiting)
                        return Center(child: CircularProgressIndicator(),);
                      else {
                        var listTimeSlot = snapshot.data as List<int>;
                        return GridView.builder(
                            itemCount: TIME_SLOT.length,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                            itemBuilder: (context,index)=> GestureDetector(
                              onTap: maxTimeSlot > index || listTimeSlot.contains(index) ? null : (){
                                ref.read(selectedTime.state).state = TIME_SLOT.elementAt(index);
                                ref.read(selectedTimeSlot.state).state = index;
                              },
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

  confirmBooking(BuildContext context, WidgetRef ref) {

    var hour = ref.read(selectedTime.state).state.length <= 10 ? int.parse(ref.read(selectedTime.state).state.split(':')[0].substring(0,1)) :
    int.parse(ref.read(selectedTime.state).state.split(':')[0].substring(0,2));

    var minutes =  ref.read(selectedTime.state).state.length <= 10 ? int.parse(ref.read(selectedTime.state).state.split(':')[1].substring(0,1)) :
    int.parse(ref.read(selectedTime.state).state.split(':')[1].substring(0,2));
    var timeStamp = DateTime (
      ref.read(selectedDate.state).state.year,
      ref.read(selectedDate.state).state.month,
      ref.read(selectedDate.state).state.day,
      hour,
      minutes
    ).millisecondsSinceEpoch;
    //Create booking Model
    var bookingModel = BookingModel(
    hairdresserId : ref.read(selectedHairdresser.state).state.docId,
    hairdresserName : ref.read(selectedHairdresser.state).state.name,
    cityBook : ref.read(selectedCity.state).state.name,
    customerId: FirebaseAuth.instance.currentUser.uid,
    customerName : ref.read(userInformation.state).state.name,
    customerPhone : FirebaseAuth.instance.currentUser.phoneNumber,
    done : false,
    salonAddress : ref.read(selectedSalon.state).state.address,
    salonId : ref.read(selectedSalon.state).state.docId,
    salonName : ref.read(selectedSalon.state).state.name,
    slot : ref.read(selectedTimeSlot.state).state,
    timeStamp : timeStamp,
    time :
    '${ref.read(selectedTime.state).state} - ${DateFormat('dd/MM/yyyy').format(ref.read(selectedDate.state).state)}'

    );
    //submit on firestore

    var batch = FirebaseFirestore.instance.batch();

    DocumentReference hairdresserBooking = ref
        .read(selectedHairdresser.state)
        .state
        .reference
        .collection(
        '${DateFormat('dd_MM_yyyy').format(ref.read(selectedDate.state).state)}')
        .doc(ref.read(selectedTimeSlot.state).state.toString());

    DocumentReference userBooking = FirebaseFirestore.instance.collection('User')
    .doc(FirebaseAuth.instance.currentUser.phoneNumber)
    .collection('Booking_${FirebaseAuth.instance.currentUser.uid}')
    .doc('${ref.read(selectedHairdresser.state).state.docId}_${DateFormat('dd_MM_yyyy')
    .format(ref.read(selectedDate.state).state)}');

    batch.set(hairdresserBooking, bookingModel.toJson());
    batch.set(userBooking, bookingModel.toJson());
    batch.commit().then((value) {

      Navigator.of(context).pop();
      ScaffoldMessenger.of(scaffoldKey.currentContext)
          .showSnackBar(SnackBar(content: Text('Zarezerwowano pomyślnie'),));

      //Event creation
      final event = Event(
          title: 'Wizyta u Fryzjera',
          description: 'Wizyta fryzjerska ${ref.read(selectedTime.state).state} - '
              '${DateFormat('dd/MM/yyyy').format(ref.read(selectedDate.state).state)}',
          location: '${ref.read(selectedSalon.state).state.address}',
          startDate: DateTime(
              ref.read(selectedDate.state).state.year,
              ref.read(selectedDate.state).state.month,
              ref.read(selectedDate.state).state.day,
              hour,
              minutes
          ),
          endDate: DateTime(
              ref.read(selectedDate.state).state.year,
              ref.read(selectedDate.state).state.month,
              ref.read(selectedDate.state).state.day,
              hour,
              minutes+30
          ),
          iosParams: IOSParams(reminder: Duration (minutes: 30)),
          androidParams: AndroidParams (emailInvites: [])
      );
      Add2Calendar.addEvent2Cal(event).then((value) {

      });
      // Reset value
      ref.read(selectedDate.state).state = DateTime.now();
      ref.read(selectedHairdresser.state).state = HairdresserModel();
      ref.read(selectedCity.state).state = CityModel();
      ref.read(selectedSalon.state).state = SalonModel();
      ref.read(currentStep.state).state = 1;
      ref.read(selectedTime.state).state = '';
      ref.read(selectedTimeSlot.state).state = -1;
    });



  }

  displayConfirm(BuildContext context, WidgetRef ref) {

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(flex: 1, child: Padding(padding: const EdgeInsets.all(24),
          child: Image.asset('assets/images/logo.jpg'),),),
        Expanded(flex: 3, child: Container(
          width: MediaQuery.of(context).size.width,
          child: Card(child: Padding(padding: const EdgeInsets.all(16), child:
            Column(
              children: [
                Text('Dziękujemy za skorzystanie z naszych usług!'.toUpperCase(),
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
                ElevatedButton(onPressed: () => confirmBooking(context, ref),
                  child: Text('Potwierdź'),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.black26)),
                )
              ], )
        ))))
      ],
    );

  }
}