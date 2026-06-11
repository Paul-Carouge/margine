import 'package:flutter/material.dart';

class ItemDetailScreen extends StatelessWidget {
  final int id;

  const ItemDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Text(
        'Item #$id',
        style: theme.textTheme.headlineMedium,
      ),
    );
  }
}
