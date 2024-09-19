import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:files_manger/feauters/Folders/data/cubit/getallfiles/getallfilecubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'search_folders_files_state.dart';

class SearchFoldersFilesCubit extends Cubit<SearchFoldersFilesState> {
  SearchFoldersFilesCubit() : super(SearchFoldersFilesInitial());

  List<String> search_folders_files = [];

  void search({required String thefolder, required BuildContext context}) {
    emit(SearchFoldersFilesStateLoading());
    search_folders_files.clear();
    int n = BlocProvider.of<Getallfilecubit>(context).fileSystem.keys.length;

    Map<String, List<String>> fileSystem =
        BlocProvider.of<Getallfilecubit>(context).fileSystem;

    for (int i = 0; i < n; i++) {
      String path = fileSystem.keys.elementAt(i);

      if (path.contains("/$thefolder/")) {
        search_folders_files.add(path);
        continue;
      }
      log("=========================================");
      int x = fileSystem[path]?.length ?? 3;
      for (int j = 0; j < x; j++) {
        log(fileSystem[path]?[j] ?? "11");
        if (fileSystem[path]?[j].contains(thefolder) ??
            " ".contains(thefolder)) {
          search_folders_files.add(fileSystem[path]?[j] ?? "1");
        }
      }
    }
    emit(SearchFoldersFilesStateSuccessful());
  }
}
