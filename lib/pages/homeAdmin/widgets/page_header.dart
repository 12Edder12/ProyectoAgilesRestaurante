import 'package:flutter/material.dart';

class PageHeader extends StatelessWidget {
  const PageHeader({super.key, required this.title, required TextStyle style});

  final String title;


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.headlineMedium!.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        
      ],
    );
  }
}
