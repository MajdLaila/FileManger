import 'dart:ui';

 
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

/// In this file are all the const objects in the application. 
  class Appcolor {
  static Color prime = const Color(0xFFF6F4EB);
  static Color second =const Color(0xFF91C8E4);
  static Color third = const Color(0xFF749BC2);
  static Color fourth =  const Color(0xFF4682A9);
  }
 

class LOAD extends StatelessWidget {
  const LOAD({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolor.prime,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SpinKitFoldingCube(
            color: Appcolor.third,
            size: 40.h,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.2,
          ),
          const Text('Loading')
        ],
      ),
    );
  }
}