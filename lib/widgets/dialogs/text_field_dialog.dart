import 'package:flutter/material.dart';

enum TextFieldDialogButtonType { cancel, confirm }

typedef DialogOptionBuilder = Map<TextFieldDialogButtonType, String> Function();

Future<Map<String, String?>?> showTextFieldDialog({
  required BuildContext context,
  required String title,
  required String? hintTitleText,
  required String? hintContentText,
  required DialogOptionBuilder optionsBuilder,
  String? defaultTitle,
  String? defaultContent,
  bool autoFocus = false,
}) {
  final titleController = TextEditingController(text: defaultTitle);
  final contentController = TextEditingController(text: defaultContent);

  final options = optionsBuilder();

  return showDialog<Map<String, String?>?>(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: SizedBox(
          height: 100,
          child: Column(
            children: [
              TextField(
                autofocus: autoFocus,
                controller: titleController,
                decoration: InputDecoration(
                  hintText: hintTitleText,
                ),
              ),
              TextField(
                autofocus: false,
                controller: contentController,
                decoration: InputDecoration(
                  hintText: hintContentText,
                ),
              ),
            ],
          ),
        ),
        actions: options.entries.map(
          (option) {
            return TextButton(
              onPressed: () {
                switch (option.key) {
                  case TextFieldDialogButtonType.cancel:
                    titleController.clear();
                    contentController.clear();
                    Navigator.of(context).pop();
                    break;
                  case TextFieldDialogButtonType.confirm:
                    Map<String, String?>? map = {
                      'title': titleController.text,
                      'content': contentController.text
                    };
                    titleController.clear();
                    contentController.clear();
                    Navigator.of(context).pop(map);

                    break;
                }
              },
              child: Text(
                option.value,
              ),
            );
          },
        ).toList(),
      );
    },
  );
}
