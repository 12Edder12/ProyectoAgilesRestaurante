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
    final theme = Theme.of(context);
    return ContentView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PageHeader(
            title: 'Empleados',
          ),
          const Gap(16),
          Expanded(
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: FutureBuilder<List<User>>(
                future: getUsers(),
                builder:
                    (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.separated(
                      itemCount: snapshot.data!.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        final user = snapshot.data![index];
                        return ListTile(
                          title: Text(
                            user.name,
                            style: theme.textTheme.bodyMedium!
                                .copyWith(fontWeight: FontWeight.w600),
                            ),
                          subtitle: Text(
                            user.role,
                            style: theme.textTheme.labelMedium,
                          ),
                          trailing: const Icon(Icons.navigate_next_outlined),
                          onTap: () {
                            UserPageRoute(userId: user.userId).go(context);
                          },
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
