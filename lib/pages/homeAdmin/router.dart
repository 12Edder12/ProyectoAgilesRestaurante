import 'package:Pizzeria_Guerrin/pages/homeAdmin/features/users/list_users.dart';
import 'package:Pizzeria_Guerrin/pages/homeAdmin/features/users/user.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'features/dashboard/dashbord_page.dart';
import 'features/users/user_page.dart';
import 'features/users/users_page.dart';
import 'widgets/widgets.dart';

part 'router.g.dart';

const routerInitialLocation = '/users';

final router = GoRouter(
  routes: $appRoutes,
  debugLogDiagnostics: kDebugMode,
  initialLocation: routerInitialLocation,
);

@TypedStatefulShellRoute<ShellRouteData>(
  branches: [
    TypedStatefulShellBranch(
      routes: [
        TypedGoRoute<DashboardRoute>(
          path: routerInitialLocation,
        ),
      ],
    ),
    TypedStatefulShellBranch(
      routes: [
        TypedGoRoute<UsersPageRoute>(
          path: '/users',
          routes: [
            TypedGoRoute<UserPageRoute>(
              path: ':userId',
            ),
          ],
        ),
      ],
    ),
  ],
)
class ShellRouteData extends StatefulShellRouteData {
  const ShellRouteData();

  @override
  Widget builder(
    BuildContext context,
    GoRouterState state,
    StatefulNavigationShell navigationShell,
  ) {
    return SelectionArea(
      child: ScaffoldWithNavigation(
        navigationShell: navigationShell,
      ),
    );
  }
}

class DashboardRoute extends GoRouteData {
  const DashboardRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return  DashBoardPage();
  }
}

class UsersPageRoute extends GoRouteData {
  const UsersPageRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const UsersPage();
  }
}

class UserPageRoute extends GoRouteData {
  const UserPageRoute({required this.userId});

  final String userId;

@override
Widget build(BuildContext context, GoRouterState state) {
  return StreamBuilder<List<User>>(
    stream: getUsers(),
    builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
      if (snapshot.hasData) {
        final user = snapshot.data!.firstWhereOrNull((e) => e.userId == userId);
        return user == null
            ? const UsersPage()
            : UserPage(user: user);
      } else if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      } else {
        return const CircularProgressIndicator();
      }
    },
  );
}
}
