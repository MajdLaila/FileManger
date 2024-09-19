import 'dart:developer';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:files_manger/feauters/Folders/data/cubit/getallfiles/getallfilestate.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class Getallfilecubit extends Cubit<Getallfilestate> {
  Getallfilecubit() : super(Getallfilestateinit());
  final Map<String, List<String>> fileSystem = {};
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

      fileSystem.clear();
      fileSystem.addAll(newFileSystem);

      emit(Getallfilestatesuccss(fileSystem: fileSystem));
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

      emit(Getallfilestatesuccss(fileSystem: fileSystem));
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

  Future<void> sortFoldersBySize() async {
    try {
      emit(Getallfilestateloading());

      final folderSizes = <String, int>{};

      // حساب حجم الملفات في كل مجلد
      for (var entry in fileSystem.entries) {
        final folderPath = entry.key;
        final filePaths = entry.value;
        int totalSize = 0;

        for (var filePath in filePaths) {
          final file = File(filePath);
          if (await file.exists()) {
            final fileSize = await file.length();
            totalSize += fileSize;
          }
        }

        folderSizes[folderPath] = totalSize;
      }

      final foldersWithAlphabets = <String>[];
      final foldersWithSpecialChars = <String>[];

      for (var folderPath in folderSizes.keys) {
        final folderName = folderPath.split('/').last;
        if (RegExp(r'^[a-zA-Z]').hasMatch(folderName)) {
          foldersWithAlphabets.add(folderPath);
        } else {
          foldersWithSpecialChars.add(folderPath);
        }
      }

      foldersWithAlphabets
          .sort((a, b) => folderSizes[b]!.compareTo(folderSizes[a]!));
      foldersWithSpecialChars
          .sort((a, b) => folderSizes[b]!.compareTo(folderSizes[a]!));

      // دمج القائمتين
      final newFileSystem = <String, List<String>>{};
      for (var folderPath in foldersWithAlphabets) {
        newFileSystem[folderPath] = fileSystem[folderPath]!;
      }
      for (var folderPath in foldersWithSpecialChars) {
        newFileSystem[folderPath] = fileSystem[folderPath]!;
      }

      fileSystem.clear();
      fileSystem.addAll(newFileSystem);

      emit(Getallfilestatesuccss(fileSystem: fileSystem));
    } catch (e) {
      emit(Getallfilestatefailuer(
          error: 'There was an error sorting folders by size: $e'));
    }
  }

  Future<void> sortAllFoldersByCreationDate() async {
    try {
      emit(Getallfilestateloading());

      final sortedFolders = <Map<String, dynamic>>[];

      // جمع معلومات المجلدات فقط من
      for (var folderPath in fileSystem.keys) {
        final folder = Directory(folderPath);
        if (await folder.exists()) {
          final folderStat = await folder.stat();
          sortedFolders.add({
            'path': folderPath,
            'name': folderPath.split('/').last,
            'creationDate': folderStat.changed
          });
        }
      }

      final foldersWithAlphabets = <Map<String, dynamic>>[];
      final foldersWithSpecialChars = <Map<String, dynamic>>[];

      for (var folder in sortedFolders) {
        final name = folder['name'] as String;
        if (RegExp(r'^[a-zA-Z]').hasMatch(name)) {
          // إذا كان الاسم يبدأ بحرف أبجدي
          foldersWithAlphabets.add(folder);
        } else {
          // إذا كان الاسم يبدأ بمحرف خاص
          foldersWithSpecialChars.add(folder);
        }
      }

      foldersWithAlphabets.sort((a, b) {
        final dateA = a['creationDate'] as DateTime;
        final dateB = b['creationDate'] as DateTime;
        return dateA.compareTo(dateB);
      });

      foldersWithSpecialChars.sort((a, b) {
        final dateA = a['creationDate'] as DateTime;
        final dateB = b['creationDate'] as DateTime;
        return dateA.compareTo(dateB);
      });

      final newFileSystem = <String, List<String>>{};
      for (var folder in foldersWithAlphabets) {
        final folderPath = folder['path'] as String;
        newFileSystem[folderPath] = fileSystem[folderPath]!;
      }
      for (var folder in foldersWithSpecialChars) {
        final folderPath = folder['path'] as String;
        newFileSystem[folderPath] = fileSystem[folderPath]!;
      }

      fileSystem.clear();
      fileSystem.addAll(newFileSystem);

      emit(Getallfilestatesuccss(fileSystem: fileSystem));
    } catch (e) {
      emit(Getallfilestatefailuer(
          error: 'There was an error sorting folders by creation date: $e'));
    }
  }

  Future<void> sortAllFoldersByName() async {
    try {
      emit(Getallfilestateloading());

      final sortedFolders = <Map<String, dynamic>>[];
 
 
      fileSystem.forEach((folderPath, filePaths) {
        sortedFolders.add({
          'path': folderPath,
          'name': folderPath.split('/').last,
        });
      });

      final foldersWithAlphabets = <Map<String, dynamic>>[];
      final foldersWithSpecialChars = <Map<String, dynamic>>[];

      for (var folder in sortedFolders) {
        final name = folder['name'] as String;
        if (RegExp(r'^[a-zA-Z]').hasMatch(name)) {
  
          foldersWithAlphabets.add(folder);
        } else {
   
          foldersWithSpecialChars.add(folder);
        }
      }

      foldersWithAlphabets.sort((a, b) {
        final nameA = a['name'] as String;
        final nameB = b['name'] as String;
        return nameA.compareTo(nameB);
      });

      foldersWithSpecialChars.sort((a, b) {
        final nameA = a['name'] as String;
        final nameB = b['name'] as String;
        return nameA.compareTo(nameB);
      });

      final newFileSystem = <String, List<String>>{};
      for (var folder in foldersWithAlphabets) {
        final folderPath = folder['path'] as String;
        newFileSystem[folderPath] = fileSystem[folderPath]!;
      }
      for (var folder in foldersWithSpecialChars) {
        final folderPath = folder['path'] as String;
        newFileSystem[folderPath] = fileSystem[folderPath]!;
      }

      fileSystem.clear();
      fileSystem.addAll(newFileSystem);

      emit(Getallfilestatesuccss(fileSystem: fileSystem));
    } catch (e) {
      emit(Getallfilestatefailuer(
          error: 'There was an error sorting folders by name: $e'));
    }
  }

  Future<void> addFolder(String path, String folderName) async {
    try {
      final newDirectory = Directory('$path/$folderName');
      if (!await newDirectory.exists()) {
        await newDirectory.create();
        fileSystem[path]?.add(newDirectory.path);
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
        fileSystem.remove(path);
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
      emit(Getallfilestateloading());

      final oldDirectory = Directory(oldPath);

      if (await oldDirectory.exists()) {
        final newPath = '${oldDirectory.parent.path}/$newName';
        final newDirectory = Directory(newPath);

        
        if (await newDirectory.exists()) {
          emit(Getallfilestatefailuer(
              error: 'A folder with the new name already exists.'));
          return;
        }

    
        await oldDirectory.rename(newPath);
 
        if (fileSystem.containsKey(oldDirectory.parent.path)) {
          fileSystem[oldDirectory.parent.path]?.remove(oldPath);
          fileSystem[oldDirectory.parent.path]?.add(newPath);
        }

   
        for (int i = 0; i < files.length; i++) {
          if (files[i].path == oldPath) {
            files[i] = Directory(newPath);
          }
        }

       
        await listFiles();
 
        final updatedDirectory = Directory(newPath);
        if (await updatedDirectory.exists()) {
          log("Renaming done");
          await listFiles();
          emit(Getallfilestatesuccss(fileSystem: fileSystem));
        } else {
          emit(Getallfilestatefailuer(
              error: 'The folder at $newPath does not exist after renaming.'));
        }

        foldername.clear();
      } else {
        emit(Getallfilestatefailuer(
            error: 'The folder at $oldPath does not exist.'));
      }
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
