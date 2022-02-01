import 'package:first_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class MainViewModel{

  void processLogin(BuildContext context,GlobalKey<ScaffoldState> scaffoldKey, WidgetRef ref);
  Future<LOGIN_STATE> checkLoginState(BuildContext context, WidgetRef ref,bool fromLogin, GlobalKey<ScaffoldState> scaffoldState);

}