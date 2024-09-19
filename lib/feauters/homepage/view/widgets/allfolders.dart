import 'dart:developer';
import 'dart:io';
import 'package:files_manger/const.dart';
import 'package:files_manger/feauters/homepage/data/cubit/checkBox/check_box_cubit.dart';
import 'package:files_manger/feauters/homepage/data/cubit/getallfiles/getallfilecubit.dart';
import 'package:files_manger/feauters/homepage/data/cubit/getallfiles/getallfilestate.dart';
import 'package:files_manger/feauters/homepage/view/widgets/floderfilepage.dart'; // تأكد من أن صفحة FolderFilesPage موجودة
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Allfolders extends StatelessWidget {
  Allfolders({super.key});
  final TextEditingController textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Getallfilecubit, Getallfilestate>(
      builder: (context, state) {
        if (state is Getallfilestateloading) {
          return const LOAD();
        } else if (state is Getallfilestatesuccss) {
          return ListView.builder(
            itemCount: state.fileSystem.keys.length,
            itemBuilder: (context, index) {
              final dirPath = state.fileSystem.keys.elementAt(index);
              return Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                FolderFilesPage(folderPath: dirPath),
                          ),
                        );
                      },
                      child: Container(
                        height: 80,
                        padding: EdgeInsets.all(12.h),
                        margin: EdgeInsets.all(12.h),
                        decoration: BoxDecoration(
                            color: Appcolor.second,
                            borderRadius: BorderRadius.circular(15.r)),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 30,
                            ),
                            const Icon(Icons.folder),
                            const SizedBox(
                              width: 20,
                            ),
                            Text(
                              dirPath.split('/').last,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              width: 30,
                            ),
                            IconButton(
                              onPressed: () {
                                // BlocProvider.of<Getallfilecubit>(context)
                                //     .deleteFolder(dirPath);
                              },
                              icon: const Icon(Icons.remove_circle),
                            ),
                            const SizedBox(
                              width: 30,
                            ),
                            IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      content: SizedBox(
                                        width: 170,
                                        height: 140,
                                        child: Column(
                                          children: [
                                            TextFormField(
                                              controller: textEditingController,
                                              decoration: const InputDecoration(
                                                  label: Text("new name")),
                                            ),
                                            const SizedBox(
                                              height: 30,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                log("1");
                                                BlocProvider.of<
                                                            Getallfilecubit>(
                                                        context)
                                                    .renameFolder(
                                                        dirPath,
                                                        textEditingController
                                                            .text);
                                              },
                                              child: const SizedBox(
                                                width: 70,
                                                height: 40,
                                                child: Text("rename"),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              icon: const Icon(Icons.edit),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Expanded(
                  //   child: Container(
                  //     padding: EdgeInsets.all(12.h),
                  //     margin: EdgeInsets.all(12.h),
                  //     decoration: BoxDecoration(
                  //         color: Appcolor.second,
                  //         borderRadius: BorderRadius.circular(15.r)),
                  //     child: ListTile(
                  //       leading: const Icon(Icons.folder),
                  //       title: Text(
                  //         dirPath.split('/').last,
                  //         style: const TextStyle(fontWeight: FontWeight.bold),
                  //       ),
                  //       onTap: () {
                  //         Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //             builder: (context) =>
                  //                 FolderFilesPage(folderPath: dirPath),
                  //           ),
                  //         );
                  //       },
                  //     ),
                  //   ),
                  // ),
                ],
              );
            },
          );
        } else {
          return Container();
        }
      },
    );
  }
}

IconData getIconForFileType(String filePath) {
  if (FileSystemEntity.isDirectorySync(filePath)) {
    return Icons.folder;
  } else if (filePath.endsWith('.jpg') ||
      filePath.endsWith('.jpeg') ||
      filePath.endsWith('.png') ||
      filePath.endsWith('.gif')) {
    return Icons.image;
  } else if (filePath.endsWith('.mp3') || filePath.endsWith('.wav')) {
    return Icons.audiotrack;
  } else if (filePath.endsWith('.pdf')) {
    return Icons.picture_as_pdf;
  } else if (filePath.endsWith('.mp4') || filePath.endsWith('.avi')) {
    return Icons.movie;
  } else {
    return Icons.insert_drive_file;
  }
}
