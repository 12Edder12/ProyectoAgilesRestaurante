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
        // Agrega un padding alrededor de la columna
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PageHeader(
              title: 'Empleados',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight
                      .bold), // Aumenta el tamaño de la fuente y la hace en negrita
            ),
            const Gap(32), // Aumenta el espacio
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
                        separatorBuilder: (context, index) => const SizedBox(
                            height: 16), // Agrega espacio entre las tarjetas
                        itemBuilder: (context, index) {
                          final user = snapshot.data![index];
                          return AnimatedOpacity(
                            // Agrega una animación de opacidad
                            opacity: 1.0,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeIn,
                            child: Card(
                              child: ListTile(
                                leading: Icon(_getIconForRole(user.role)),
                                title: Text(
                                  '${user.apeUser} ${user.name}',
                                  style: theme.textTheme.bodyText1,
                                ),
                                subtitle: Text(
                                  user.role,
                                  style: theme.textTheme.caption,
                                ),
                                trailing:
                                    const Icon(Icons.more_vert),
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
