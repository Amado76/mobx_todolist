import 'package:flutter/material.dart' show BuildContext;
import 'package:mobx_todolist/widgets/dialogs/generic_dialog.dart';

Future<bool> showDeleteToDoDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Delete To Do',
    content:
        'Are you sure you want to delete this to do? You cannot undo this action!',
    optionsBuilder: () => {
      'Cancel': false,
      'Delete': true,
    },
  ).then(
    (value) => value ?? false,
  );
}
