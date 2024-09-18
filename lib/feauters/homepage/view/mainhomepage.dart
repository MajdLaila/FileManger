import 'package:auto_size_text/auto_size_text.dart';
import 'package:files_manger/const.dart';
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
      ),
      body: const Allfolders(),

      // إضافة Floating Action Button
      floatingActionButton: FloatingActionButton(
        backgroundColor: Appcolor.fourth, // لون الـ FAB
        onPressed: () {
          _showAddFolderDialog(context);
        },
        child: const Icon(Icons.create_new_folder), // أيقونة إنشاء مجلد
      ),
    );
  }

  // دالة لإظهار نافذة حوار لإضافة مجلد جديد
  void _showAddFolderDialog(BuildContext context) {
    final TextEditingController folderNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Folder'),
          content: TextField(
            controller: folderNameController,
            decoration: const InputDecoration(hintText: 'Enter folder name'),
          ),
          actions: [
            TextButton(
              style: ButtonStyle(
                  textStyle: WidgetStatePropertyAll(
                      TextStyle(backgroundColor: Appcolor.prime)),
                  backgroundColor: WidgetStatePropertyAll(Appcolor.second)),
              onPressed: () {
                Navigator.of(context).pop(); // إغلاق النافذة
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ButtonStyle(
                  textStyle: WidgetStatePropertyAll(
                      TextStyle(backgroundColor: Appcolor.prime)),
                  backgroundColor: WidgetStatePropertyAll(Appcolor.second)),
              onPressed: () {
                String folderName = folderNameController.text;
                if (folderName.isNotEmpty) {
                  _createNewFolder(folderName); // تنفيذ منطق لإنشاء المجلد
                  Navigator.of(context).pop(); // إغلاق النافذة بعد إضافة المجلد
                }
              },
              child: const AutoSizeText('Create'),
            ),
          ],
        );
      },
    );
  }

  // دالة لإنشاء مجلد جديد
  void _createNewFolder(String folderName) {
    // منطق إنشاء المجلد هنا
    // يمكنك استخدام أي مكتبة مثل dart:io لإنشاء مجلد جديد في المسار المناسب
  }
}
