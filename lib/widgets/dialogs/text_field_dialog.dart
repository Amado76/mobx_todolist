import 'package:flutter/material.dart';

enum TextFieldDialogButtonType { cancel, confirm }

typedef DialogOptionBuilder = Map<TextFieldDialogButtonType, String> Function();

final titleController = TextEditingController();
final contentController = TextEditingController();

Future<List<String?>?> showTextFieldDialog({
  required BuildContext context,
  required String title,
  required String? hintTitleText,
  required String? hintContentText,
  required DialogOptionBuilder optionsBuilder,
}) {
  titleController.clear();
  final options = optionsBuilder();
  return showDialog<List<String?>>(
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
                autofocus: true,
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
                    List<String?> list = [
                      titleController.text,
                      contentController.text
                    ];
                    titleController.clear();
                    contentController.clear();
                    Navigator.of(context).pop(list);

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
