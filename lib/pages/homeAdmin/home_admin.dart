import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:Pizzeria_Guerrin/pages/homeAdmin/router.dart';
import 'package:Pizzeria_Guerrin/pages/homeAdmin/theme.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class AdminScreen extends StatelessWidget {
  static const title = 'Cargando';

  const AdminScreen({super.key});
  @override
  Widget build(BuildContext context) {
    
    return AdaptiveTheme(
      
      light: AppTheme.light,
     // dark: AppTheme.dark,
      initial: AdaptiveThemeMode.system,
      builder: (theme, darkTheme) => ResponsiveBreakpoints.builder(
        breakpoints: [
          const Breakpoint(start: 0, end: 450, name: MOBILE),
          const Breakpoint(start: 451, end: 960, name: TABLET),
          const Breakpoint(start: 961, end: double.infinity, name: DESKTOP),
        ],
        child: MaterialApp.router(
                debugShowCheckedModeBanner: false, // Agrega esta línea

          title: title,
          routerConfig: router,
          theme: theme,
          darkTheme: darkTheme,
        ),
      ),
    );
  }
}