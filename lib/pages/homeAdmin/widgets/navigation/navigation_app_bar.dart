import 'package:bbb/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import 'navigation_title.dart';

class NavigationAppBar extends StatelessWidget implements PreferredSizeWidget {
  const NavigationAppBar({Key? key}) : super(key: key);

  Future<void> signOut(BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    await authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const NavigationTitle(),
      centerTitle: false,
      elevation: 4,
      actions: [
        const Text('Administrador'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: PopupMenuButton<void>(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: const Text('Salir'),
                onTap: () {
                  signOut(context);
                },
              ),
            ],
            child: const Icon(Icons.account_circle_outlined),
          ),
        ),
        const Gap(8),
      ],
    );
  }

  @override
  Size get preferredSize => AppBar().preferredSize;
}