import 'package:bloc/bloc.dart';
import 'package:files_manger/feauters/homepage/data/cubit/getallfiles/getallfilecubit.dart';
import 'package:files_manger/feauters/homepage/data/cubit/getrecentimages/getrecentimagecubit.dart';
import 'package:files_manger/feauters/homepage/data/cubit/permission/getpermissionstate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:permission_handler/permission_handler.dart';

class RequstPermissionCubit extends Cubit<Getpermissionstate> {
  RequstPermissionCubit() : super(Getpermissionstateinit());
  Future<void> requestPermissions(BuildContext context) async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      // log('Permission granted');
      emit(Getpermissionstatesuccss(context));
      BlocProvider.of<Getallfilecubit>(context).listFiles();
      BlocProvider.of<Getrecentimagecubit>(context).fetchImages(context);
    } else {
      // log('Permission denied');
      emit(Getpermissionstatefailuer(error: 'permission denied'));
    }
  }
}
