import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:files_manger/const.dart';
import 'package:files_manger/feauters/homepage/data/cubit/checkBox/check_box_cubit.dart';
import 'package:files_manger/feauters/homepage/data/cubit/getallfiles/getallfilecubit.dart';
import 'package:files_manger/feauters/homepage/data/cubit/permission/getpermissioncubit.dart';
import 'package:files_manger/feauters/homepage/view/widgets/allfolders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  }

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
      body:  Allfolders(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Appcolor.fourth, // لون الـ FAB
        onPressed: () {
          showAddFolderDialog(context);
        },
        child: const Icon(Icons.create_new_folder), // أيقونة إنشاء مجلد
      ),
    );
  }

  // دالة لإظهار نافذة حوار لإضافة مجلد جديد
  showAddFolderDialog(BuildContext context) {
    final TextEditingController folderNameController = TextEditingController();
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Add New Folder',
            style: TextStyle(fontSize: 20),
          ),
          content: SizedBox(
            width: 200,
            height: 120,
            child: TextFormField(
              controller: folderNameController,
              decoration: const InputDecoration(
                  label: Text(
                "name",
                style: TextStyle(),
              )),
            ),
          ),
          actions: [
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: const SizedBox(
                width: 100,
                height: 60,
                child: Center(
                  child: Text(
                    "No",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                BlocProvider.of<Getallfilecubit>(context).addFolder(
                    "/storage/emulated/0", folderNameController.text);
              },
              child: const SizedBox(
                width: 100,
                height: 60,
                child: Center(
                  child: Text(
                    "create",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }

  // دالة لإنشاء مجلد جديد
  // void createNewFolder(String folderName) async {
  // Get the application's document directory
  // Directory appDocDir = await getApplicationDocumentsDirectory();
  // log(appDocDir.path);

  // Create a new directory path
  //   Directory newFolder = Directory('${appDocDir.path}/$folderName');

  //   // Check if the folder already exists
  //   if (!(await newFolder.exists())) {
  //     // Create the folder
  //     await newFolder.create(recursive: true);
  //     print('Folder created: ${newFolder.path}');
  //   } else {
  //     print('Folder already exists: ${newFolder.path}');
  //   }
  // }
}
