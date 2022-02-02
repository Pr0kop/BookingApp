import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:first_app/ui/booking_screen.dart';
import 'package:first_app/ui/done_services_screens.dart';
import 'package:first_app/ui/home_screen.dart';
import 'package:first_app/ui/staff_home_screen.dart';
import 'package:first_app/ui/user_history_screen.dart';

import 'package:first_app/utils/utils.dart';
import 'package:first_app/view_model/main/main_view_model_imp.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:first_app/state/state_managment.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  //Firebase
  await Firebase.initializeApp();
  runApp(// Before
      ProviderScope(
        child: MyApp(),

      ));
}


class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      onGenerateRoute: (settings){
        switch(settings.name){
          case '/home':
            return PageTransition(
                settings: settings,
                child: HomePage(),
                type: PageTransitionType.fade);
            break;
          case '/staffHome':
            return PageTransition(
                settings: settings,
                child: StaffHome(),
                type: PageTransitionType.fade);
            break;
          case '/doneService':
            return PageTransition(
                settings: settings,
                child: DoneService(),
                type: PageTransitionType.fade);
            break;
          case '/history':
            return PageTransition(
                settings: settings,
                child: UserHistory(),
                type: PageTransitionType.fade);
            break;
          case '/booking':
            return PageTransition(
                settings: settings,
                child: BookingScreen(),
                type: PageTransitionType.fade);
            break;
          default:
            return null;
        }
      },
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}


class MyHomePage extends ConsumerWidget {
  final scaffoldState = new GlobalKey<ScaffoldState>();

  final mainViewModel = MainViewModelImp();


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(child: Scaffold(
      key: scaffoldState,
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/my_bg.png'),
                fit: BoxFit.cover)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              width: MediaQuery.of(context).size.width,
              // child: ElevatedButton(onPressed: () {  }, child: Text('Zaloguj')),
              child: FutureBuilder(
                future: mainViewModel.checkLoginState(context, ref, false, scaffoldState),
                builder: (context,snapshot){
                  if(snapshot.connectionState == ConnectionState.waiting)
                    return Center(child: CircularProgressIndicator(),);
                  else{
                    print('heyhey');
                    print(FirebaseAuth.instance.currentUser);
                    print('heyhey');
                    var userState = snapshot.data as LOGIN_STATE;

                    if(userState == LOGIN_STATE.LOGGED){
                      return Container();
                    }
                    else{
                      //If user not login before then return button
                      return ElevatedButton.icon(
                        onPressed: ()=> mainViewModel.processLogin(context, scaffoldState, ref),
                        icon: Icon(Icons.phone, color:Colors.white),
                        label: Text('Zaloguj się', style: TextStyle(color: Colors.white),),
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.black)),
                      );
                    }
                  }
                },
              ),
            )
          ],
        ),
      ),
    ));
  }


}
