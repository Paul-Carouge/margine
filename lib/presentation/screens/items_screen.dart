import 'package:flutter/material.dart';

class ItemsScreen extends StatelessWidget {
  const ItemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Text(
        'Items',
        style: theme.textTheme.headlineMedium,
      ),
    );
  }
}
