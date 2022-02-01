import 'package:first_app/model/image_model.dart';
import 'package:first_app/model/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class HomeViewModel {
  Future<UserModel> displayUserProfile(BuildContext context,
       WidgetRef ref, String phoneNumber);

  Future<List<ImageModel>> displayBanner();

  Future<List<ImageModel>> displayLookbook();


  bool isStaff(BuildContext context, WidgetRef ref);
}