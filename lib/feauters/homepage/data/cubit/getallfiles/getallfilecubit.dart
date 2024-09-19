import 'dart:developer';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:files_manger/feauters/homepage/data/cubit/getallfiles/getallfilestate.dart';
import 'package:path_provider/path_provider.dart';

class Getallfilecubit extends Cubit<Getallfilestate> {
  Getallfilecubit() : super(Getallfilestateinit());
  final Map<String, List<String>> _fileSystem = {};

  Future<void> listFiles() async {
    try {
      emit(Getallfilestateloading());
      final directories = [
        await getExternalStorageDirectory(),
        Directory('/storage/emulated/0'),
        // Directory('/storage/sdcard1'),
      ];

      for (var directory in directories) {
        if (directory != null && await directory.exists()) {
          // List all entities in the directory
          final dirEntities = await directory.list().toList();

          // Filter to get only directories
          final directoryList = dirEntities.whereType<Directory>().toList();

          // Iterate over each directory
          for (var dirEntity in directoryList) {
            final dirPath = dirEntity.path;
            log('Directory: $dirPath');

            // Initialize the list for files in this directory
            _fileSystem.putIfAbsent(dirPath, () => []);

            // List files in this directory
            final fileEntities = dirEntity.listSync(); // This will work now
            for (var fileEntity in fileEntities) {
              if (fileEntity is File) {
                final filePath = fileEntity.path;
                _fileSystem[dirPath]?.add(filePath);
                log('File: $filePath');
              }
            }
          }
        }
      }

      emit(Getallfilestatesuccss(fileSystem: _fileSystem));
    } catch (e) {
      emit(Getallfilestatefailuer(
          error: 'There was an error fetching files: $e'));
    }
  }

  // 1. ترتيب الملفات حسب الحجم
  void sortFilesBySize(String dirPath) {
    if (_fileSystem.containsKey(dirPath)) {
      _fileSystem[dirPath]?.sort((a, b) {
        final fileA = File(a);
        final fileB = File(b);
        return fileA.lengthSync().compareTo(fileB.lengthSync());
      });
      emit(Getallfilestatesuccss(fileSystem: _fileSystem));
    }
  }

  // 2. ترتيب الملفات حسب تاريخ آخر تعديل
  void sortFilesByDate(String dirPath) {
    if (_fileSystem.containsKey(dirPath)) {
      _fileSystem[dirPath]?.sort((a, b) {
        final fileA = File(a);
        final fileB = File(b);
        return fileA.lastModifiedSync().compareTo(fileB.lastModifiedSync());
      });
      emit(Getallfilestatesuccss(fileSystem: _fileSystem));
    }
  }

  // 3. إضافة مجلد جديد
  Future<void> addFolder(String path, String folderName) async {
    try {
      final newDirectory = Directory('$path/$folderName');
      if (!await newDirectory.exists()) {
        await newDirectory.create();
        _fileSystem[path]?.add(newDirectory.path);
        log("donnnne create");
        emit(Getallfilestatesuccss(fileSystem: _fileSystem));
      }
    } catch (e) {
      log(e.toString());
      log("Create error");
      emit(Getallfilestatefailuer(error: 'Error creating folder: $e'));
    }
  }

  // 4. حذف مجلد
  Future<void> deleteFolder(String path) async {
    try {
      final directory = Directory(path);
      if (await directory.exists()) {
        await directory.delete(recursive: true);
        _fileSystem.remove(path);
        log("remove done");
        emit(Getallfilestatesuccss(fileSystem: _fileSystem));
      }
    } catch (e) {
      emit(Getallfilestatefailuer(error: 'Error deleting folder: $e'));
    }
  }

  // 5. تعديل اسم المجلد
  Future<void> renameFolder(String oldPath, String newName) async {
    try {
      final oldDirectory = Directory(oldPath);
      if (await oldDirectory.exists()) {
        final newPath = '${oldDirectory.parent.path}/$newName';
        await oldDirectory.rename(newPath);
        _fileSystem[oldDirectory.parent.path]?.remove(oldPath);
        _fileSystem[oldDirectory.parent.path]?.add(newPath);
        log("rename done");
        emit(Getallfilestatesuccss(fileSystem: _fileSystem));
      }
    } catch (e) {
      log(e.toString());
      emit(Getallfilestatefailuer(error: 'Error renaming folder: $e'));
    }
  }
}
