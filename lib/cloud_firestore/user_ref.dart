

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_app/model/user_model.dart';
import 'package:first_app/state/state_managment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<UserModel> getUserProfiles(BuildContext context, WidgetRef ref, String phone) async {
  CollectionReference userRef = FirebaseFirestore.instance.collection('User');
  DocumentSnapshot snapshot = await userRef.doc(phone).get();
  if(snapshot.exists) {
    var userModel = UserModel.fromJson(snapshot.data());
    ref.read(userInformation.state).state = userModel;
    return userModel;
  }
  else return UserModel();
}