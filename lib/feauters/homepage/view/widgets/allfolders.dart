import 'dart:io';
import 'package:files_manger/const.dart';
import 'package:files_manger/feauters/homepage/data/cubit/getallfiles/getallfilecubit.dart';
import 'package:files_manger/feauters/homepage/data/cubit/getallfiles/getallfilestate.dart';
import 'package:files_manger/feauters/homepage/view/widgets/floderfilepage.dart'; // تأكد من أن صفحة FolderFilesPage موجودة
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Allfolders extends StatelessWidget {
  const Allfolders({super.key});

  // دالة لتحديد نوع الأيقونة بناءً على الامتداد
  IconData _getIconForFileType(String filePath) {
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

              return Container(
                padding: EdgeInsets.all(12.h),
                margin: EdgeInsets.all(12.h),
                decoration: BoxDecoration(
                    color: Appcolor.second,
                    borderRadius: BorderRadius.circular(15.r)),
                child: ListTile(
                  leading: const Icon(Icons.folder),
                  title: Text(
                    dirPath.split('/').last,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            FolderFilesPage(folderPath: dirPath),
                      ),
                    );
                  },
                ),
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
