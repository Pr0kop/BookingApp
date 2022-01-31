import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_ui/firebase_auth_ui.dart';
import 'package:firebase_auth_ui/providers.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:first_app/screens/booking_screen.dart';
import 'package:first_app/screens/home_screen.dart';
import 'package:first_app/screens/user_history_screen.dart';
import 'package:first_app/utils/utils.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:first_app/state/state_managment.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
//import 'package:flutter_bloc/flutter_bloc.dart' show BlocBuilder, BlocProvider;
//import 'package:flutter_bloc/flutter_bloc.dart' hide ReadContext;

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  //Firebase
  Firebase.initializeApp();
  runApp(// Before
      ProviderScope(
        child: MyApp(),

      ));
}


class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

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
  GlobalKey<ScaffoldState> scaffoldState = new GlobalKey();


  processLogin(BuildContext context, WidgetRef ref) {
    var user = FirebaseAuth.instance.currentUser;
    if(user == null) // gdy nie jest zalogowany
        {
      FirebaseAuthUi.instance()
          .launchAuth([
        AuthProvider.phone()
      ]).then((firebaseUser) {
        // odswiezenie stanu
        // context.read().state = userLogged;
        ref.read(userLogged.state).state = FirebaseAuth.instance.currentUser;
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      }).catchError((e) {
        if(e is PlatformException)
          if(e.code == FirebaseAuthUi.kUserCancelledError) {
            ScaffoldMessenger.of(scaffoldState.currentContext).showSnackBar(
                SnackBar(content: Text('${e.message}')));
          }else {
            ScaffoldMessenger.of(scaffoldState.currentContext).showSnackBar(
                SnackBar(content: Text('Nieznany blad')));
          }
      });
    }
    else // zalogowany -> przejdz na strone glowna
        {

    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(child: Scaffold(
      key: scaffoldState,
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/bookingappimg.jpg'),
                fit: BoxFit.cover)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              width: MediaQuery.of(context).size.width,
              // child: ElevatedButton(onPressed: () {  }, child: Text('Zaloguj')),
              child: FutureBuilder(

                future: checkLoginState(context, false, scaffoldState, ref),

                builder: (context,snapshot){
                  if(snapshot.connectionState == ConnectionState.waiting)
                    return Center(child: CircularProgressIndicator(),);
                  else{
                    var userState = snapshot.data as LOGIN_STATE;
                    if(userState == LOGIN_STATE.LOGGED){
                      return Container();
                    }
                    else{
                      //If user not login before then return button
                      return ElevatedButton.icon(
                        onPressed: ()=> processLogin(context, ref),
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

  Future<LOGIN_STATE>  checkLoginState(BuildContext context,bool fromLogin, GlobalKey<ScaffoldState> scaffoldState, WidgetRef ref) async{
    if(!ref.read(forceReload.state).state) {
      await Future.delayed(Duration(seconds: fromLogin == true ? 0 : 3)).then((value) => {
        FirebaseAuth.instance.currentUser
            .getIdToken()
            .then((token) async {
          //If get token, we print it
          print('$token');
          ref.read(userToken.state).state = token;
          // check user in firestore
          CollectionReference userRef = FirebaseFirestore.instance.collection('User');
          DocumentSnapshot snapshotUser = await userRef
              .doc(FirebaseAuth.instance.currentUser.phoneNumber)
              .get();
          //Force reload state
          ref.read(forceReload.state).state = true;   // tu powinno byc read(forceReload)

          if(snapshotUser.exists) {
            // And because user already login, we will start new screen
            Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
          }
          else {
            print('blasbdsalbdalsbddblaasdaslkdsadsajkdsakjhsakjhfakafjhkfaskjjhkfsajhk');
            // if user info doesn't available, show dialog
            var nameController = TextEditingController();
            var addressController = TextEditingController();
            Alert(
                context:context,
                title: 'UPDATE PROFILES',
                content:Column(
                  children: [
                    TextField(decoration: InputDecoration(
                        icon:Icon(Icons.account_circle),
                        labelText: 'Name'
                    ),controller: nameController,),
                    TextField(decoration: InputDecoration(
                        icon:Icon(Icons.home),
                        labelText: 'Address'
                    ),controller: addressController,)
                  ],
                ),
                buttons: [
                  DialogButton(child: Text('CANCEL'), onPressed: ()=>Navigator.pop(context)),
                  DialogButton(child: Text('UPDATE'), onPressed: (){
                    // update to server
                    userRef.doc(FirebaseAuth.instance.currentUser.phoneNumber)
                        .set({
                      'name':nameController.text,
                      'address':addressController.text
                    }).then((value) async {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(scaffoldState.currentContext)
                          .showSnackBar(SnackBar(content: Text('UPDATE PROFILES SUCCESSFULLY!')));
                      await Future.delayed(Duration(seconds: 1), () {
                        // And because user already login, we will start new screen
                        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                      });
                    })
                        .catchError((e) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(scaffoldState.currentContext)
                          .showSnackBar(SnackBar(content: Text('$e')));
                    });
                  }),
                ]
            ).show();
          }
        })
      });
    }
    return FirebaseAuth.instance.currentUser != null
        ? LOGIN_STATE.LOGGED
        : LOGIN_STATE.NOT_LOGIN;
  }
}
