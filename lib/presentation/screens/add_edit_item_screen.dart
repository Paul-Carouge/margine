import 'package:flutter/material.dart';

class AddEditItemScreen extends StatelessWidget {
  final int? id;

  const AddEditItemScreen({super.key, this.id});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEditing = id != null;
    return Center(
      child: Text(
        isEditing ? 'Edit Item #$id' : 'Add Item',
        style: theme.textTheme.headlineMedium,
      ),
    );
  }
}
