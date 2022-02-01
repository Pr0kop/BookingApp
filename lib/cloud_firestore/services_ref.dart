

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_app/model/service_model.dart';
import 'package:first_app/state/state_managment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<List<ServiceModel>> getServices (BuildContext context, WidgetRef ref) async {
  var services = List<ServiceModel>.empty(growable: true);
  var serviceRef = FirebaseFirestore.instance.collection('Services');

  QuerySnapshot snapshot= await serviceRef
      .where(ref.read(selectedSalon.state).state.docId, isEqualTo: true)
      .get();
  snapshot.docs.forEach((element) {
    var serviceModel = ServiceModel.fromJson(element.data());
    serviceModel.docId = element.id;
    services.add(serviceModel);
  });
  return services;
}