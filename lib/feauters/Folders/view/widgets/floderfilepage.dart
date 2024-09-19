import 'dart:developer';
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:files_manger/const.dart';
import 'package:flutter/material.dart';

class FolderFilesPage extends StatefulWidget {
  final String folderPath;

  const FolderFilesPage({super.key, required this.folderPath});

  @override
  State<FolderFilesPage> createState() => _FolderFilesPageState();
}

class _FolderFilesPageState extends State<FolderFilesPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    // الحصول على الملفات والمجلدات داخل المسار
    final directory = Directory(widget.folderPath);
    List<FileSystemEntity> files = [];

    try {
      files = directory.listSync(); // الحصول على الملفات والمجلدات
    } catch (e) {
      print('Error: $e');
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Appcolor.third,
        centerTitle: true,
        // title: const AutoSizeText('File Manger'),
        title: AutoSizeText(
            widget.folderPath.split('/').last), // اسم المجلد كعنوان للصفحة
      ),
      body: ListView.builder(
        itemCount: files.length,
        itemBuilder: (context, index) {
          
          final file = files[index];
          final isDirectory = FileSystemEntity.isDirectorySync(file.path);
          return ListTile(
            leading: Icon(isDirectory
                ? Icons.folder
                : Icons.insert_drive_file), // أيقونة للمجلد أو الملف
            title: Text(file.path.split('/').last),
            onTap: () {
              if (isDirectory) {
                // إذا تم الضغط على مجلد، افتح المجلد
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        FolderFilesPage(folderPath: file.path),
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}
