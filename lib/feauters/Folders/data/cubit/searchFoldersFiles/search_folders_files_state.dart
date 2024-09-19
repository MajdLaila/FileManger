part of 'search_folders_files_cubit.dart';

@immutable
sealed class SearchFoldersFilesState {}

final class SearchFoldersFilesInitial extends SearchFoldersFilesState {}

final class  SearchFoldersFilesStateLoading extends SearchFoldersFilesState {}

final class  SearchFoldersFilesStateSuccessful extends SearchFoldersFilesState {}


