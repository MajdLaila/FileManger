part of 'check_box_cubit.dart';

@immutable
sealed class CheckBoxState {}

final class CheckBoxInitial extends CheckBoxState {}

final class ChangeCheckBoxState extends CheckBoxState {}
