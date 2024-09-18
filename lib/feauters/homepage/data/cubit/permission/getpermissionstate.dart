 

 
import 'package:files_manger/feauters/homepage/data/cubit/getallfiles/getallfilecubit.dart';
import 'package:flutter/material.dart';

sealed class Getpermissionstate {}

final class Getpermissionstateinit extends Getpermissionstate {}

final class Getpermissionstatesuccss extends Getpermissionstate {

  Getpermissionstatesuccss(BuildContext context){
    
  }
}


final class Getpermissionstatefailuer extends Getpermissionstate {
  final String error;

  Getpermissionstatefailuer({required this.error});
}
