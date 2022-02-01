import 'package:first_app/cloud_firestore/banner_ref.dart';
import 'package:first_app/cloud_firestore/lookbook_ref.dart';
import 'package:first_app/cloud_firestore/user_ref.dart';
import 'package:first_app/model/image_model.dart';
import 'package:first_app/model/user_model.dart';
import 'package:first_app/state/state_managment.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'homve_view_model.dart';

class HomeViewModelImp implements HomeViewModel {
  @override
  Future<List<ImageModel>> displayBanner() {
    return getBanners();
  }

  @override
  Future<List<ImageModel>> displayLookbook() {
    return getLookbook();
  }


  @override
  Future<UserModel> displayUserProfile(BuildContext context, WidgetRef ref, String phoneNumber) async {
    return getUserProfiles(context, ref, phoneNumber);
  }

  @override
  bool isStaff(BuildContext context, WidgetRef ref) {
    return ref.read(userInformation.state).state.isStaff;
  }


}