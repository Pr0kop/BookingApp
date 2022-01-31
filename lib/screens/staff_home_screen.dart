import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/cloud_firestore/banner_ref.dart';
import 'package:first_app/cloud_firestore/user_ref.dart';
import 'package:first_app/model/image_model.dart';
import 'package:first_app/model/user_model.dart';
import 'package:first_app/state/state_managment.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class StaffHome extends ConsumerWidget{
  @override
  Widget build(BuildContext context, ref) {
    return SafeArea(child: Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Color(0xFFDFDFDF),
      appBar: AppBar(title: Text('Personel'),backgroundColor: Color(0xFF383838),),
      body: Center(child: Text('Personel'),),
    ),
    );
  }
}