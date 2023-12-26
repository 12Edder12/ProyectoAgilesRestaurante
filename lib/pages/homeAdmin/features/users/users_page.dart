import 'package:bbb/constants/colors.dart';
import 'package:bbb/constants/globals.dart';
import 'package:bbb/pages/homeAdmin/features/users/listUsers.dart';
import 'package:bbb/pages/homeAdmin/features/users/user.dart';
import 'package:bbb/pages/homeAdmin/router.dart';
import 'package:flutter/material.dart';

import 'package:gap/gap.dart';

import '../../widgets/widgets.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    globalContext = context;
    final theme = Theme.of(context);
    return ContentView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PageHeader(
              title: 'Empleados',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: kPrimaryColor), // Cambia el color del título a azul
            ),
            const Gap(32),
            Expanded(
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: StreamBuilder<List<User>>(
                stream: getUsers(),
                  builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
    
                      return ListView.separated(
                        itemCount: snapshot.data!.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final user = snapshot.data![index];
                          return AnimatedOpacity(
                            opacity: 1.0,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeIn,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0), // Añade bordes redondeados a las tarjetas
                                side: BorderSide(color: Colors.grey[300]!), // Añade un borde a las tarjetas
                              ),
                              child: ListTile(
                                leading: Icon(
                                  _getIconForRole(user.role),
                                  color: kPrimaryColor, // Cambia el color de los iconos a azul
                                ),
                                title: Text(
                                  '${user.apeUser} ${user.name}',
                                  style: theme.textTheme.bodyText1,
                                ),
                                subtitle: Text(
                                  user.role,
                                  style: theme.textTheme.caption,
                                ),
                                trailing:
                                    const Icon(Icons.more_vert, color: black), // Cambia el color del icono a azul
                                onTap: () {
                                  UserPageRoute(userId: user.userId)
                                      .go(context);
                                },
                              ),
                            ),
                          );
                        },
                      );

                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

IconData _getIconForRole(String role) {
  switch (role) {
    case 'admin':
      return Icons.admin_panel_settings;
    case 'Mesero':
      return Icons.restaurant_menu;
    case 'Cocinero':
      return Icons.kitchen;
    default:
      return Icons.person;
  }
}
