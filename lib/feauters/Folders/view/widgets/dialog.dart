import 'package:auto_size_text/auto_size_text.dart';
import 'package:files_manger/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void showAppDialog({
  required BuildContext context,
  required String datatext,
  required Function() function,
  required TextEditingController textEditingController,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Appcolor.prime,
        content: SizedBox(
          width: 170.w,
          height: 140.h,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: textEditingController,
                decoration: InputDecoration(label: Text(datatext)),
              ),
              SizedBox(
                height: 30.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      /// for validation

                      if (!RegExp(r'^[\u0621-\u064A0-9_a-zA-Z]+$')
                          .hasMatch(textEditingController.text)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Invalid characters in input! Only letters (Arabic and English), numbers, and underscores are allowed.",
                            ),
                          ),
                        );
                        return;
                      }

                      Navigator.of(context).pop();
                      function();
                    },
                    child: SizedBox(
                      width: 70.w,
                      height: 40.h,
                      child: const AutoSizeText("OK"),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: SizedBox(
                      width: 70.w,
                      height: 40.h,
                      child: const AutoSizeText("Cancel"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
