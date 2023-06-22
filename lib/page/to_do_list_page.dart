// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx_todolist/state/app_state.dart';
import 'package:mobx_todolist/widgets/dialogs/delete_to_do_dialog.dart';
import 'package:mobx_todolist/widgets/dialogs/text_field_dialog.dart';
import 'package:mobx_todolist/widgets/main_popup_menu_buttom.dart';
import 'package:provider/provider.dart';

class ToDoListPage extends StatefulWidget {
  const ToDoListPage({super.key});

  @override
  State<ToDoListPage> createState() => ToDoListPageState();
}

class ToDoListPageState extends State<ToDoListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: const Text('To Do List'),
        actions: [
          IconButton(
              onPressed: () async {
                final Map<String, String?>? toDoText =
                    await showTextFieldDialog(
                        context: context,
                        autoFocus: true,
                        title: "Add a new To Do",
                        hintTitleText: "Enter your To Do here",
                        hintContentText: "Enter the description here",
                        optionsBuilder: () => {
                              TextFieldDialogButtonType.cancel: "Cancel",
                              TextFieldDialogButtonType.confirm: "Add",
                            });
                if (toDoText == null || toDoText.isEmpty) return;
                context.read<AppState>().createToDo(
                    title: toDoText['title']!, content: toDoText['content']!);
              },
              icon: const Icon(Icons.add)),
          const MainPopupMenuButton(),
        ],
      ),
      body: const ToDoListView(),
    );
  }
}

class ToDoListView extends StatelessWidget {
  const ToDoListView({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    return Observer(
      builder: (context) {
        return ListView.builder(
            itemCount: appState.sortedToDoListList.length,
            itemBuilder: (context, index) {
              final toDo = appState.sortedToDoListList[index];
              return Observer(
                builder: (context) => CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  value: toDo.isDone,
                  onChanged: (isDone) {
                    context
                        .read<AppState>()
                        .modifyIsDone(toDo, isDone: isDone ?? false);
                    toDo.isDone = isDone ?? false;
                  },
                  title: Row(children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            toDo.title,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.secondary),
                          ),
                          Text(
                            toDo.content,
                            style: const TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        final Map<String, String?>? toDoText =
                            await showTextFieldDialog(
                                context: context,
                                title: "Edit To Do",
                                hintTitleText: "Edit Title",
                                defaultTitle: toDo.title,
                                hintContentText: "Edit Content",
                                defaultContent: toDo.content,
                                optionsBuilder: () => {
                                      TextFieldDialogButtonType.cancel:
                                          "Cancel",
                                      TextFieldDialogButtonType.confirm: "Add",
                                    });
                        if (toDoText == null || toDoText.isEmpty) return;
                        if (toDoText['title']!.isNotEmpty) {
                          context.read<AppState>().modifyTitle(
                                toDo,
                                title: toDoText['title']!,
                              );
                        }

                        context
                            .read<AppState>()
                            .modifyContent(toDo, content: toDoText['content']!);
                      },
                      icon: const Icon(Icons.edit),
                    ),
                    IconButton(
                      onPressed: () async {
                        final shouldDelete =
                            await showDeleteToDoDialog(context);
                        if (shouldDelete) {
                          context.read<AppState>().delete(toDo);
                        }
                      },
                      icon: const Icon(Icons.delete_forever),
                    ),
                  ]),
                ),
              );
            });
      },
    );
  }
}
