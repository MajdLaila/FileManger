import 'dart:io';

import 'package:flutter/material.dart';

sealed class Getrecentimagestate {}

final class Getrecentimagestateinit extends Getrecentimagestate {}
final class Getrecentimagestateload extends Getrecentimagestate {}

final class Getrecentimagestatesuccss extends Getrecentimagestate {
  final List<File> imageFiles;
  Getrecentimagestatesuccss(BuildContext context, this.imageFiles);
}

final class Getrecentimagestatefailure extends Getrecentimagestate {
  final String error;

  Getrecentimagestatefailure({required this.error});
}
