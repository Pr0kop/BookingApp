import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

void showRegisterDialog(BuildContext context, CollectionReference userRef,
    GlobalKey<ScaffoldState> scaffoldState, WidgetRef ref) {
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