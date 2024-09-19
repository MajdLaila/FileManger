import 'package:files_manger/feauters/Folders/data/cubit/searchFoldersFiles/search_folders_files_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Searchbar extends StatelessWidget {
  Searchbar({super.key});
  TextEditingController textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 4),  
            ),
          ],
        ),
        child: TextField(
          controller: textEditingController,
          decoration: InputDecoration(
            hintText: 'Search...',
            hintStyle: const TextStyle(color: Colors.grey),
            border: InputBorder.none,
            prefixIcon: Padding(
              padding: const EdgeInsets.all(8.0),  
              child: Image.asset('assest/magnifying-glass.png',
                  width: 24, height: 24),  
            ),
          ),
          onChanged: (value) {
            BlocProvider.of<SearchFoldersFilesCubit>(context).search(
                thefolder: textEditingController.text, context: context);
          },
        ),
      ),
    );
  }
}
