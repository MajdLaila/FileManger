import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:files_manger/const.dart';
import 'package:files_manger/feauters/Folders/data/cubit/getallfiles/getallfilecubit.dart';
import 'package:files_manger/feauters/Folders/data/cubit/searchFoldersFiles/search_folders_files_cubit.dart';
import 'package:files_manger/feauters/Folders/view/widgets/dialog.dart';
import 'package:files_manger/feauters/Folders/view/widgets/floderfilepage.dart';
import 'package:files_manger/feauters/Folders/view/widgets/text_feild_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class PageSearch extends StatelessWidget {
  const PageSearch({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Search"),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 20),
          Searchbar(),
          BlocBuilder<SearchFoldersFilesCubit, SearchFoldersFilesState>(
            builder: (context, state) {
              if (state is SearchFoldersFilesInitial) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 100.h),
                    AutoSizeText(
                      'You can search here for any file',
                      style: GoogleFonts.abel(fontSize: 20.sp),
                    ),
                    SizedBox(
                      height: 300.h,
                      width: 300.w,
                      child: LottieBuilder.asset(
                        'assest/search.json',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                );
              } else if (state is SearchFoldersFilesStateLoading) {
                return const LOAD();
              } else if (state is SearchFoldersFilesStateSuccessful) {
                final searchResults =
                    BlocProvider.of<SearchFoldersFilesCubit>(context)
                        .search_folders_files;

                if (searchResults.isEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 100.h),
                      AutoSizeText(
                        'No results found',
                        style: GoogleFonts.abel(fontSize: 20.sp),
                      ),
                      SizedBox(height: 20.h),
                      SizedBox(
                        height: 300.h,
                        width: 300.w,
                        child: LottieBuilder.asset(
                          'assest/notfound.json',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  );
                }

                return SizedBox(
                  height: 800.h,
                  child: ListView.builder(
                    itemCount: searchResults.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      String path = searchResults[index];
                      final isDirectory =
                          FileSystemEntity.isDirectorySync(path);
                      return InkWell(
                        onTap: () {
                          if (isDirectory) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FolderFilesPage(
                                  folderPath: path,
                                ),
                              ),
                            );
                          } else {}
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
                                  .getIconForFileType(path)),
                              SizedBox(width: 20.w),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: SizedBox(
                                  width: 180.w,
                                  child: Text(
                                    path.split('/').last,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15.sp),
                                  ),
                                ),
                              ),
                              SizedBox(width: 30.w),
                              PopupMenuButton<String>(
                                onSelected: (value) {
                                  if (value == 'rename') {
                                    showAppDialog(
                                      datatext: 'Rename',
                                      function: () => BlocProvider.of<
                                              Getallfilecubit>(context)
                                          .renameFolder(
                                              path,
                                              BlocProvider.of<Getallfilecubit>(
                                                      context)
                                                  .foldername
                                                  .text),
                                      textEditingController:
                                          BlocProvider.of<Getallfilecubit>(
                                                  context)
                                              .foldername,
                                      context: context,
                                    );
                                  } else if (value == 'delete') {
                                    BlocProvider.of<Getallfilecubit>(context)
                                        .deleteFolder(path);
                                  }
                                },
                                itemBuilder: (context) => [
                                  const PopupMenuItem(
                                      value: 'rename', child: Text('Rename')),
                                  const PopupMenuItem(
                                      value: 'delete', child: Text('Delete')),
                                ],
                                icon: const Icon(Icons.more_vert),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              } else {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 100.h),
                    AutoSizeText(
                      'You can search here for any file',
                      style: GoogleFonts.abel(fontSize: 20.sp),
                    ),
                    SizedBox(
                      height: 300.h,
                      width: 300.w,
                      child: LottieBuilder.asset(
                        'assest/search.json',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
