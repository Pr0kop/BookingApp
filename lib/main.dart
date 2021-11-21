import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_ui/firebase_auth_ui.dart';
import 'package:firebase_auth_ui/providers.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'state/state_managment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:first_app/state/state_managment.dart';
import 'package:provider/provider.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  //Firebase
  Firebase.initializeApp();
  runApp(ProviderScope(child: MyApp()));
}


class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  //const MyHomePage({Key? key, required this.title}) : super(key: key);
  const MyHomePage({Key key, this.title}) : super(key: key);


  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GlobalKey<ScaffoldState> scaffoldState = new GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              child: ElevatedButton.icon(
                onPressed: () => processLogin(context),
                icon: Icon(Icons.phone, color: Colors.white),
                label: Text('Zaloguj', style: TextStyle(color:Colors.white),),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blueAccent)
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  processLogin(BuildContext context) {
    var user = FirebaseAuth.instance.currentUser;
    if(user == null) // gdy nie jest zalogowany
        {
      FirebaseAuthUi.instance()
          .launchAuth([
        AuthProvider.phone()
      ]).then((firebaseUser) {
        // odswiezenie stanu
        context.read().state = userLogged;
        ScaffoldMessenger.of(scaffoldState.currentContext).showSnackBar(
            SnackBar(content: Text('Zalogowano pomyslnie ${FirebaseAuth.instance.currentUser.phoneNumber}')));
      }).catchError((e) {
        if(e is PlatformException)
          if(e.code == FirebaseAuthUi.kUserCancelledError)
            ScaffoldMessenger.of(scaffoldState.currentContext).showSnackBar(
                SnackBar(content: Text('${e.message}')));
          else
            ScaffoldMessenger.of(scaffoldState.currentContext).showSnackBar(
                SnackBar(content: Text('Nieznany blad')));
       });
    }
    else // zalogowany -> przejdz na strone glowna
        {

    }
  }
}
