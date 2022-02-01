

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_app/model/image_model.dart';
import 'package:first_app/model/user_model.dart';
import 'package:flutter/cupertino.dart';

Future<List<ImageModel>> getBanners() async {
  List<ImageModel> result = new List<ImageModel>.empty(growable: true);
  CollectionReference bannerRef = FirebaseFirestore.instance.collection('Bannery');
  QuerySnapshot snapshot = await bannerRef.get();
  snapshot.docs.forEach((element) {
    final data = element.data() as Map<String, dynamic>;
    result.add(ImageModel.fromJson(data));
  });
  return result;
}