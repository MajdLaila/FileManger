import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:files_manger/const.dart';
import 'package:files_manger/feauters/Folders/data/cubit/getallfiles/getallfilecubit.dart';
import 'package:files_manger/feauters/Folders/data/cubit/permission/getpermissioncubit.dart';
import 'package:files_manger/feauters/Folders/view/widgets/allfolders.dart';
import 'package:files_manger/feauters/Folders/view/widgets/dialog.dart';
import 'package:files_manger/feauters/homepage/data/cubit/checkBox/check_box_cubit.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<RequstPermissionCubit>(context).requestPermissions(context);
    BlocProvider.of<Getallfilecubit>(context).foldername.clear();
  }

  final TextEditingController folderNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolor.prime,
      appBar: AppBar(
          backgroundColor: Appcolor.third,
          centerTitle: true,
          title: const AutoSizeText('File Manager'),
          leading: BlocBuilder<CheckBoxCubit, CheckBoxState>(
            builder: (context, state) {
              return BlocProvider.of<CheckBoxCubit>(context).show_all_boxes
                  ? IconButton(
                      onPressed: () {
                        BlocProvider.of<CheckBoxCubit>(context)
                            .change_boxes_state();
                      },
                      icon: const Icon(Icons.cancel_outlined))
                  : const Text("");
            },
          )),
      body: Allfolders(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Appcolor.fourth, // لون الـ FAB
        onPressed: () {
          showAppDialog(
              context: context,
              datatext: 'create folder',
              function: () => BlocProvider.of<Getallfilecubit>(context)
                  .addFolder(
                      "/storage/emulated/0",
                      BlocProvider.of<Getallfilecubit>(context)
                          .foldername
                          .text),
              textEditingController:
                  BlocProvider.of<Getallfilecubit>(context).foldername);
        },
        child: const Icon(Icons.create_new_folder), // أيقونة إنشاء مجلد
      ),
    );
  }
}
