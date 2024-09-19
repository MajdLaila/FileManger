import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:files_manger/feauters/Folders/data/cubit/getrecentimages/getrecentimagestate.dart';

class Getrecentimagecubit extends Cubit<Getrecentimagestate> {
  Getrecentimagecubit() : super(Getrecentimagestateinit());

  Future<void> fetchImages(BuildContext context) async {
    emit(Getrecentimagestateload());

    try {
      final images = await _getRecentImages();
      emit(Getrecentimagestatesuccss(context, images));
    } catch (e) {
      emit(Getrecentimagestatefailure(error: 'Failed to load images: $e'));
    }
  }

  Future<List<File>> _getRecentImages() async {
    List<File> imageFiles = [];
    final directory = Directory('/storage/emulated/0/');
    final files = directory.listSync(recursive: true);

    // احصل على التاريخ الحالي
    final now = DateTime.now();

    for (var file in files) {
      if (file is File && _isImageFile(file.path)) {
        // الحصول على معلومات الملف
        final stat = await file.stat();
        final lastModified = stat.modified;

        // تحقق مما إذا كانت الصورة قديمة يومين فقط
        if (now.difference(lastModified).inDays <= 2) {
          imageFiles.add(file);
        }
      }
    }

    return imageFiles;
  }

  bool _isImageFile(String path) {
    return path.endsWith('.jpg') ||
        path.endsWith('.jpeg') ||
        path.endsWith('.png') ||
        path.endsWith('.gif');
  }
}
