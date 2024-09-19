import 'package:files_manger/feauters/Folders/data/cubit/getallfiles/getallfilecubit.dart';
import 'package:files_manger/feauters/Folders/data/cubit/getrecentimages/getrecentimagecubit.dart';
import 'package:files_manger/feauters/Folders/data/cubit/permission/getpermissioncubit.dart';
import 'package:files_manger/feauters/Folders/data/cubit/searchFoldersFiles/search_folders_files_cubit.dart';
import 'package:files_manger/feauters/Folders/view/mainhomepage.dart';
import 'package:files_manger/feauters/Folders/view/widgets/text_feild_search.dart';

import 'package:files_manger/feauters/homepage/data/cubit/checkBox/check_box_cubit.dart';
// import 'package:files_manger/feauters/homepage/data/cubit/getallfiles/getallfilecubit.dart';
// import 'package:files_manger/feauters/homepage/data/cubit/getrecentimages/getrecentimagecubit.dart';
// import 'package:files_manger/feauters/homepage/data/cubit/permission/getpermissioncubit.dart';
// import 'package:files_manger/feauters/homepage/view/mainhomepage.dart';
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
        BlocProvider(
          create: (context) => Getallfilecubit(),
        ),
        BlocProvider(
          create: (context) => RequstPermissionCubit(),
        ),
        BlocProvider(
          create: (context) => Getrecentimagecubit(),
        ),
        BlocProvider(
          create: (context) => CheckBoxCubit(),
        ),
        BlocProvider(
          create: (context) => SearchFoldersFilesCubit(),
        )
      ],
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
