// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:mobx_todolist/state/app_state.dart';
import 'package:mobx_todolist/widgets/dialogs/logout_dialog.dart';
import 'package:provider/provider.dart';

enum MenuAction { logout }

class MainPopupMenuButton extends StatelessWidget {
  const MainPopupMenuButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MenuAction>(
      onSelected: (value) async {
        switch (value) {
          case MenuAction.logout:
            final shouldLogOut = await showLogOutDialog(context);
            if (shouldLogOut) {
              context.read<AppState>().logout();
            }
            break;
        }
      },
      itemBuilder: (context) {
        return [
          const PopupMenuItem<MenuAction>(
            value: MenuAction.logout,
            child: Text('Log out'),
          ),
        ];
      },
    );
  }
}
