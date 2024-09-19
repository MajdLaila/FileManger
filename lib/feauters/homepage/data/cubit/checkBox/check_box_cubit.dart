// ignore_for_file: non_constant_identifier_names

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'check_box_state.dart';

class CheckBoxCubit extends Cubit<CheckBoxState> {
  CheckBoxCubit() : super(CheckBoxInitial());

  bool show_all_boxes = false;
  void change_boxes_state() {
    if (show_all_boxes == false) {
      show_all_boxes = true;
    } else {
      show_all_boxes = false;
    }
    emit(ChangeCheckBoxState());
  }
}
