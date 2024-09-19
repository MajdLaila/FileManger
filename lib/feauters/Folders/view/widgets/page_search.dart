import 'dart:io';

import 'package:files_manger/const.dart';
import 'package:files_manger/feauters/Folders/data/cubit/getallfiles/getallfilecubit.dart';
import 'package:files_manger/feauters/Folders/data/cubit/searchFoldersFiles/search_folders_files_cubit.dart';
import 'package:files_manger/feauters/Folders/view/widgets/dialog.dart';
import 'package:files_manger/feauters/Folders/view/widgets/floderfilepage.dart';
import 'package:files_manger/feauters/Folders/view/widgets/text_feild_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PageSearch extends StatelessWidget {
  const PageSearch({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Search"),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Searchbar(),
          BlocBuilder<SearchFoldersFilesCubit, SearchFoldersFilesState>(
            builder: (context, state) {
              return state is SearchFoldersFilesStateSuccessful
                  ? Expanded(
                      child: ListView.builder(
                        itemCount:
                            BlocProvider.of<SearchFoldersFilesCubit>(context)
                                .search_folders_files
                                .length,
                        itemBuilder: (context, index) {
                          // final file =
                          //     BlocProvider.of<Getallfilecubit>(context).files[index];
                          String path =
                              BlocProvider.of<SearchFoldersFilesCubit>(context)
                                  .search_folders_files[index];
                          final isDirectory =
                              FileSystemEntity.isDirectorySync(path);

                          return InkWell(
                            onTap: () {
                              if (isDirectory) {
                                // إذا كان المجلد، افتح نفس الصفحة بمسار المجلد الجديد
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FolderFilesPage(
                                      folderPath: path, // المسار الجديد للمجلد
                                    ),
                                  ),
                                );
                              } else {
                                // تنفيذ العملية الخاصة بالملف إذا كان ملفًا وليس مجلدًا
                                // يمكنك هنا فتح الملف باستخدام مكتبة أخرى لعرض الملفات مثلاً
                              }
                            },
                            child: Container(
                              height: 80.h,
                              padding: EdgeInsets.all(12.h),
                              margin: EdgeInsets.all(12.h),
                              decoration: BoxDecoration(
                                  color: Appcolor.second,
                                  borderRadius: BorderRadius.circular(15.r)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Icon(BlocProvider.of<Getallfilecubit>(context)
                                      .getIconForFileType(
                                          path)), // الأيقونة للمجلد أو الملف
                                  SizedBox(width: 20.w),
                                  Text(
                                    path.split('/').last,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(width: 30.w),
                                  PopupMenuButton<String>(
                                    onSelected: (value) {
                                      if (value == 'rename') {
                                        showAppDialog(
                                          datatext: 'Rename',
                                          function: () => BlocProvider.of<
                                                  Getallfilecubit>(context)
                                              .renameFolder(
                                                  path,
                                                  BlocProvider.of<
                                                              Getallfilecubit>(
                                                          context)
                                                      .foldername
                                                      .text),
                                          textEditingController:
                                              BlocProvider.of<Getallfilecubit>(
                                                      context)
                                                  .foldername,
                                          context: context,
                                        );
                                      } else if (value == 'delete') {
                                        BlocProvider.of<Getallfilecubit>(
                                                context)
                                            .deleteFolder(path);
                                      }
                                    },
                                    itemBuilder: (context) => [
                                      const PopupMenuItem(
                                        value: 'rename',
                                        child: Text('Rename'),
                                      ),
                                      const PopupMenuItem(
                                        value: 'delete',
                                        child: Text('Delete'),
                                      ),
                                    ],
                                    icon: const Icon(Icons.more_vert),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : state is SearchFoldersFilesStateLoading
                      ? LOAD()
                      : Text("");
            },
          )
        ],
      ),
    );
  }
}
