import 'package:files_manger/feauters/Folders/data/cubit/getallfiles/getallfilecubit.dart';

import 'package:files_manger/feauters/Folders/data/cubit/permission/getpermissioncubit.dart';
import 'package:files_manger/feauters/Folders/data/cubit/searchFoldersFiles/search_folders_files_cubit.dart';
import 'package:files_manger/feauters/Folders/view/mainhomepage.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // this cubit for get all files from device
        BlocProvider(
          create: (context) => Getallfilecubit(),
        ),
        // this cubit for get permission    from device  for storage
        BlocProvider(
          create: (context) => RequstPermissionCubit(),
        ),

        // this cubit for search
        BlocProvider(
          create: (context) => SearchFoldersFilesCubit(),
        )
      ],
      // this package i used for responsive
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'File Manager Example',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            textTheme: GoogleFonts.abelTextTheme(),
          ),
          home: const HomePage(),
        ),
      ),
    );
  }
}
