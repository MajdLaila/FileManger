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
    _loadFiles(); // Load files when the page is initialized
  }

  void _loadFiles() {
    BlocProvider.of<Getallfilecubit>(context).foldername.clear();
    BlocProvider.of<Getallfilecubit>(context)
        .listFilesinsidfolder(widget.folderPath);
    BlocProvider.of<Getallfilecubit>(context).Folderpath = widget.folderPath;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolor.prime,
      appBar: AppBar(
        backgroundColor: Appcolor.third,
        centerTitle: true,
        title: AutoSizeText(widget.folderPath.split('/').last),
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
                    // Navigate to the folder if it's a directory
                    if (isDirectory) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FolderFilesPage(
                            folderPath: file.path,
                          ),
                        ),
                      ).then((_) {
                        // Reload files when coming back
                        setState(() {
                          _loadFiles(); // تحميل الملفات عند العودة
                        });
                      });
                    } else {
                      // Handle file tap if needed
                    }
                  },
                  child: Container(
                    height: 80.h,
                    padding: EdgeInsets.all(12.h),
                    margin: EdgeInsets.all(12.h),
                    decoration: BoxDecoration(
                      color: Appcolor.second,
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(BlocProvider.of<Getallfilecubit>(context)
                            .getIconForFileType(file.path)),
                        SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: SizedBox(
                            width: 180.w,
                            child: Text(
                              file.path.split('/').last,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15.sp),
                            ),
                          ),
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
        backgroundColor: Appcolor.fourth,
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
