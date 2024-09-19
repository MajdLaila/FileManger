import 'dart:developer';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:files_manger/feauters/Folders/data/cubit/getallfiles/getallfilestate.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class Getallfilecubit extends Cubit<Getallfilestate> {
  Getallfilecubit() : super(Getallfilestateinit());
  final Map<String, List<String>> _fileSystem = {};
  TextEditingController foldername = TextEditingController();
  late String Folderpath;
  Future<void> listFiles() async {
    try {
      emit(Getallfilestateloading());
      final directories = [
        await getExternalStorageDirectory(),
        Directory('/storage/emulated/0'),
      ];

      final newFileSystem = <String, List<String>>{};

      for (var directory in directories) {
        if (directory != null && await directory.exists()) {
          final dirEntities = await directory.list().toList();
          final directoryList = dirEntities.whereType<Directory>().toList();

          for (var dirEntity in directoryList) {
            final dirPath = dirEntity.path;
            newFileSystem.putIfAbsent(dirPath, () => []);

            final fileEntities = dirEntity.listSync();
            for (var fileEntity in fileEntities) {
              if (fileEntity is File) {
                final filePath = fileEntity.path;
                newFileSystem[dirPath]?.add(filePath);
              }
            }
          }
        }
      }

      _fileSystem.clear();
      _fileSystem.addAll(newFileSystem);

      emit(Getallfilestatesuccss(fileSystem: _fileSystem));
    } catch (e) {
      emit(Getallfilestatefailuer(
          error: 'There was an error fetching files: $e'));
    }
  }

  List<FileSystemEntity> files = [];
  Future<void> listFilesinsidfolder(String path) async {
    try {
      emit(Getallfilestateloading());
      final directory = Directory(path);

      files = directory.listSync();

      emit(Getallfilestatesuccss(fileSystem: _fileSystem));
    } catch (e) {
      emit(Getallfilestatefailuer(
          error: 'There was an error fetching files: $e'));
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

  Future<void> addFolder(String path, String folderName) async {
    try {
      final newDirectory = Directory('$path/$folderName');
      if (!await newDirectory.exists()) {
        await newDirectory.create();
        _fileSystem[path]?.add(newDirectory.path);
        log("donnnne create");
        await listFiles();
        await listFilesinsidfolder(path);
        foldername.clear();
      }
    } catch (e) {
      log(e.toString());
      log("Create error");
      foldername.clear();
      emit(Getallfilestatefailuer(error: 'Error creating folder: $e'));
    }
  }

  Future<void> deleteFolder(String path) async {
    try {
      final directory = Directory(path);
      if (await directory.exists()) {
        await directory.delete(recursive: true);
        _fileSystem.remove(path);
        log("remove done");
        await listFiles();
        files.removeWhere((file) => file.path == path);
        // await listFilesinsidfolder(path);
        foldername.clear();
      }
    } catch (e) {
      foldername.clear();
      emit(Getallfilestatefailuer(error: 'Error deleting folder: $e'));
    }
  }

  Future<void> renameFolder(String oldPath, String newName) async {
    try {
      emit(Getallfilestateloading()); // عرض حالة التحميل
      final oldDirectory = Directory(oldPath);
      late final String newpath;
      if (await oldDirectory.exists()) {
        final newPath = '${oldDirectory.parent.path}/$newName';
        newpath = newPath;
        await oldDirectory.rename(newPath);

        _fileSystem[oldDirectory.parent.path]?.remove(oldPath);
        _fileSystem[oldDirectory.parent.path]?.add(newPath);
        for (int i = 0; i < files.length; i++) {
          if (files[i].path == oldPath) {
            files[i] = Directory(newPath); // تعديل المسار إلى المسار الجديد
            break;
          }
        }
        log("Renaming done");
      }
      await listFiles();
      await listFilesinsidfolder(Folderpath);
      foldername.clear();
    } catch (e) {
      log(e.toString());
      foldername.clear();
      emit(Getallfilestatefailuer(error: 'Error renaming folder: $e'));
    }
  }

  Future<List<String>> getFilesInDirectory(String dirPath) async {
    final files = <String>[];
    try {
      final directory = Directory(dirPath);
      if (await directory.exists()) {
        final fileEntities = directory.listSync();
        for (var fileEntity in fileEntities) {
          if (fileEntity is File) {
            files.add(fileEntity.path);
          }
        }
      }
    } catch (e) {
      log('Error getting files in directory: $e');
    }
    return files;
  }
}
