

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_ui/firebase_auth_ui.dart';
import 'package:firebase_auth_ui/providers.dart';

import 'package:first_app/state/state_managment.dart';
import 'package:first_app/ui/components/user_widgets/register_dialog.dart';
import 'package:first_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'main_view_model.dart';

class MainViewModelImp implements MainViewModel{
  @override
  Future<LOGIN_STATE>  checkLoginState(BuildContext context, WidgetRef ref, bool fromLogin, GlobalKey<ScaffoldState> scaffoldState) async{
    print('Im here in checkLoginState method');

    if(!ref.read(forceReload.state).state) {


      await Future.delayed(Duration(seconds: fromLogin == true ? 0 : 3)).then((value) => {

        FirebaseAuth.instance.currentUser
            .getIdToken()
            .then((token) async {
          print('I in await');
          print('FirebaseAuth.instance.currentUser');
          print(FirebaseAuth.instance.currentUser);
          //Force reload state
          ref.read(forceReload.state).state = true;   // tu powinno byc read(forceReload)


          //If get token, we print it
          print('$token');
          ref.read(userToken.state).state = token;
          // check user in firestore
          CollectionReference userRef = FirebaseFirestore.instance.collection('User');
          DocumentSnapshot snapshotUser = await userRef
              .doc(FirebaseAuth.instance.currentUser.phoneNumber)
              .get();

          if(snapshotUser.exists) {
            // And because user already login, we will start new screen
            Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
          }
          else {
           showRegisterDialog(context,userRef,scaffoldState,ref);
          }
        })
      });
    }
    return FirebaseAuth.instance.currentUser != null
        ? LOGIN_STATE.LOGGED
        : LOGIN_STATE.NOT_LOGIN;
  }

  @override
  processLogin(BuildContext context, GlobalKey<ScaffoldState> scaffoldState, WidgetRef ref) {
    print('Im here in procesLogin method');
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


}

