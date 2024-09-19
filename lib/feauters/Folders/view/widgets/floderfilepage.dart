import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:files_manger/const.dart';
import 'package:files_manger/feauters/Folders/data/cubit/getallfiles/getallfilecubit.dart';
import 'package:files_manger/feauters/Folders/data/cubit/getallfiles/getallfilestate.dart';
import 'package:files_manger/feauters/Folders/view/widgets/dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FolderFilesPage extends StatefulWidget {
  final String folderPath;

  const FolderFilesPage({super.key, required this.folderPath});

  @override
  State<FolderFilesPage> createState() => _FolderFilesPageState();
}

class _FolderFilesPageState extends State<FolderFilesPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<Getallfilecubit>(context).foldername.clear();
    BlocProvider.of<Getallfilecubit>(context)
        .listFilesinsidfolder(widget.folderPath);
    BlocProvider.of<Getallfilecubit>(context).Folderpath = widget.folderPath;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Appcolor.third,
        centerTitle: true,
        title: AutoSizeText(
            widget.folderPath.split('/').last), // اسم المجلد كعنوان للصفحة
      ),
      body: BlocBuilder<Getallfilecubit, Getallfilestate>(
        builder: (context, state) {
          if (state is Getallfilestateloading) {
            return const LOAD();
          } else if (state is Getallfilestatesuccss) {
            return ListView.builder(
              itemCount: BlocProvider.of<Getallfilecubit>(context).files.length,
              itemBuilder: (context, index) {
                final file =
                    BlocProvider.of<Getallfilecubit>(context).files[index];
                final isDirectory = FileSystemEntity.isDirectorySync(file.path);

                return InkWell(
                  onTap: () {
                    if (isDirectory) {
                      // إذا كان المجلد، افتح نفس الصفحة بمسار المجلد الجديد
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FolderFilesPage(
                            folderPath: file.path, // المسار الجديد للمجلد
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
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(BlocProvider.of<Getallfilecubit>(context)
                            .getIconForFileType(
                                file.path)), // الأيقونة للمجلد أو الملف
                        SizedBox(width: 20.w),
                        Text(
                          file.path.split('/').last,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 30.w),
                        PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'rename') {
                              showAppDialog(
                                datatext: 'Rename',
                                function: () =>
                                    BlocProvider.of<Getallfilecubit>(context)
                                        .renameFolder(
                                            file.path,
                                            BlocProvider.of<Getallfilecubit>(
                                                    context)
                                                .foldername
                                                .text),
                                textEditingController:
                                    BlocProvider.of<Getallfilecubit>(context)
                                        .foldername,
                                context: context,
                              );
                            } else if (value == 'delete') {
                              BlocProvider.of<Getallfilecubit>(context)
                                  .deleteFolder(file.path);
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
            );
          } else {
            return Container();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Appcolor.fourth, // لون الـ FAB
        onPressed: () {
          showAppDialog(
              context: context,
              datatext: 'create folder',
              function: () => BlocProvider.of<Getallfilecubit>(context)
                  .addFolder(
                      widget.folderPath,
                      BlocProvider.of<Getallfilecubit>(context)
                          .foldername
                          .text),
              textEditingController:
                  BlocProvider.of<Getallfilecubit>(context).foldername);
        },
        child: const Icon(Icons.create_new_folder),
      ),
    );
  }
}
