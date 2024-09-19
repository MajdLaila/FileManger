import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class Open_File extends StatefulWidget {
  Open_File({super.key, required this.filePath});
  String filePath;
  String fileContent = "wooooow";
  @override
  State<Open_File> createState() => _Open_FileState();
}

class _Open_FileState extends State<Open_File> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> _createFile() async {
    final directory = await getApplicationDocumentsDirectory();
    widget.filePath = '${directory.path}/my_file.txt'; // Path to your file

    final file = File(widget.filePath);
    await file
        .writeAsString('Hello, this is a test file!'); // Write test content
  }

  void _openFile() async {
    final file = File(widget.filePath);
    if (await file.exists()) {
      String contents = await file.readAsString();
      setState(() {
        widget.fileContent = contents; // Display the file content
      });
      log(widget.fileContent);
    } else {
      log("exiset");
      setState(() {
        widget.fileContent = "File does not exist.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Open File Example'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _openFile,
                child: const Text('Open File'),
              ),
              const SizedBox(height: 20),
              Text(widget.fileContent),
            ],
          ),
        ),
      ),
    );
  }
}
