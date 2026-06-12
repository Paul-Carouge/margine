import 'package:flutter/material.dart';

import '../../../providers/app_providers.dart';

/// Sort button in the home header.
///
/// Opens a bottom sheet with sort options.
class SortButton extends StatelessWidget {
  final SortOption current;
  final ValueChanged<SortOption> onSelected;

  const SortButton({super.key, required this.current, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Material(
      color: cs.surfaceContainerHighest.withValues(alpha: 0.6),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => _showMenu(context),
        child: const Padding(
          padding: EdgeInsets.all(10),
          child: Icon(Icons.sort_rounded, size: 22),
        ),
      ),
    );
  }

  void _showMenu(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Container(
        padding: const EdgeInsets.fromLTRB(0, 8, 0, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: cs.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text('Trier par',
                  style: Theme.of(context).textTheme.titleMedium),
            ),
            const SizedBox(height: 8),
            _SortListTile(
              icon: Icons.schedule_rounded,
              label: 'Plus récent',
              selected: current == SortOption.dateDesc,
              onTap: () {
                onSelected(SortOption.dateDesc);
                Navigator.pop(ctx);
              },
            ),
            _SortListTile(
              icon: Icons.trending_up_rounded,
              label: 'Marge la plus élevée',
              selected: current == SortOption.profitDesc,
              onTap: () {
                onSelected(SortOption.profitDesc);
                Navigator.pop(ctx);
              },
            ),
            _SortListTile(
              icon: Icons.euro_rounded,
              label: 'Prix achat le plus élevé',
              selected: current == SortOption.priceDesc,
              onTap: () {
                onSelected(SortOption.priceDesc);
                Navigator.pop(ctx);
              },
            ),
            _SortListTile(
              icon: Icons.sort_by_alpha_rounded,
              label: 'Ordre alphabétique',
              selected: current == SortOption.nameAsc,
              onTap: () {
                onSelected(SortOption.nameAsc);
                Navigator.pop(ctx);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SortListTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _SortListTile({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ListTile(
      leading: Icon(icon,
          size: 20,
          color: selected ? cs.primary : cs.onSurfaceVariant),
      title: Text(
        label,
        style: TextStyle(
            color: selected ? cs.primary : cs.onSurface,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400),
      ),
      trailing: selected
          ? Icon(Icons.check_rounded, size: 18, color: cs.primary)
          : null,
      onTap: onTap,
    );
  }
}
