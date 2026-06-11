import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/theme/app_theme.dart';
import '../../providers/app_providers.dart';

/// Settings screen with theme toggle, about section, and data management.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          // ── Theme Section ─────────────────────────────────────────────
          Text(
            'Apparence',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.cardTheme.color,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                _ThemeOption(
                  label: 'Clair',
                  icon: Icons.light_mode_outlined,
                  selected: themeMode == ThemeMode.light,
                  onTap: () => ref.read(themeModeProvider.notifier).state =
                      ThemeMode.light,
                ),
                const Divider(height: 1),
                _ThemeOption(
                  label: 'Sombre',
                  icon: Icons.dark_mode_outlined,
                  selected: themeMode == ThemeMode.dark,
                  onTap: () => ref.read(themeModeProvider.notifier).state =
                      ThemeMode.dark,
                ),
                const Divider(height: 1),
                _ThemeOption(
                  label: 'Système',
                  icon: Icons.settings_suggest_outlined,
                  selected: themeMode == ThemeMode.system,
                  onTap: () => ref.read(themeModeProvider.notifier).state =
                      ThemeMode.system,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // ── Data Section ──────────────────────────────────────────────
          Text(
            'Données',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.cardTheme.color,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                _DataActionTile(
                  icon: Icons.file_download_outlined,
                  label: 'Exporter toutes les données (CSV)',
                  onTap: () => _exportAllData(context, ref),
                ),
                const Divider(height: 1),
                _DataActionTile(
                  icon: Icons.upload_file_outlined,
                  label: 'Importer des données',
                  subtitle: 'Bientôt',
                  enabled: false,
                ),
                const Divider(height: 1),
                _DataActionTile(
                  icon: Icons.delete_sweep_outlined,
                  label: 'Tout effacer',
                  subtitle: 'Bientôt',
                  enabled: false,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // ── About Section ─────────────────────────────────────────────
          Text(
            'À propos',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.cardTheme.color,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                // App name
                Row(
                  children: [
                    Icon(Icons.info_outline,
                        size: 20, color: colorScheme.primary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Application',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ),
                    Text(
                      'Margine',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const Divider(height: 1),
                // Version
                Row(
                  children: [
                    Icon(Icons.tag_outlined,
                        size: 20, color: colorScheme.primary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Version',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ),
                    Text(
                      '1.0.0',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const Divider(height: 1),
                // GitHub link
                InkWell(
                  onTap: () {
                    // Open GitHub URL — in a real app this would use url_launcher
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'Visit: https://github.com/paulcarouge/margine'),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Icon(Icons.code_outlined,
                            size: 20, color: colorScheme.primary),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'GitHub',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color:
                                  colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                        ),
                        Text(
                          'Voir le code',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(Icons.open_in_new,
                            size: 16, color: colorScheme.primary),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Footer
          Center(
            child: Text(
              'Made with \u2764\ufe0f for Vinted resellers',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.4),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _exportAllData(BuildContext context, WidgetRef ref) async {
    // Reuse CSV export logic from analytics
    final dao = ref.read(productDaoProvider);
    final categories = await ref.read(categoryDaoProvider).getAll();
    final products = await dao.getAll();

    if (products.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Aucune donnée à exporter.')),
        );
      }
      return;
    }

    try {
      final buffer = StringBuffer();
      buffer.writeln('Name,Category,Purchase Price,Purchase Date,Source,'
          'Status,Listing Price,Sale Price,Sale Date,Vinted Fees,'
          'Shipping Cost,Packaging Cost,Net Profit');

      for (final p in products) {
        final cat =
            categories.where((c) => c.id == p.categoryId).firstOrNull;
        final netProfit = p.salePrice != null
            ? p.salePrice! - p.purchasePrice - p.vintedFees -
                p.shippingCost - p.packagingCost
            : 0.0;
        final dateFormat = DateFormat('yyyy-MM-dd');

        buffer.writeln(
          '"${p.name.replaceAll('"', '""')}",'
          '"${(cat?.name ?? 'Uncategorized').replaceAll('"', '""')}",'
          '${p.purchasePrice.toStringAsFixed(2)},'
          '${dateFormat.format(p.purchaseDate)},'
          '"${p.source.replaceAll('"', '""')}",'
          '${p.status},'
          '${p.listingPrice?.toStringAsFixed(2) ?? ''},'
          '${p.salePrice?.toStringAsFixed(2) ?? ''},'
          '${p.saleDate != null ? dateFormat.format(p.saleDate!) : ''},'
          '${p.vintedFees.toStringAsFixed(2)},'
          '${p.shippingCost.toStringAsFixed(2)},'
          '${p.packagingCost.toStringAsFixed(2)},'
          '${netProfit.toStringAsFixed(2)}',
        );
      }

      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/margine_export.csv');
      await file.writeAsString(buffer.toString());

      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path)],
          text: 'Export Margine',
        ),
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Export failed: $e')),
        );
      }
    }
  }
}

// -----------------------------------------------------------------------------
// Theme option tile
// -----------------------------------------------------------------------------

class _ThemeOption extends StatelessWidget {
  const _ThemeOption({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: selected
                  ? colorScheme.primary
                  : colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  color: selected
                      ? colorScheme.onSurface
                      : colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ),
            if (selected)
              Icon(
                Icons.check_circle,
                size: 20,
                color: colorScheme.primary,
              ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Data action tile
// -----------------------------------------------------------------------------

class _DataActionTile extends StatelessWidget {
  const _DataActionTile({
    required this.icon,
    required this.label,
    this.subtitle,
    this.enabled = true,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String? subtitle;
  final bool enabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: enabled
                  ? colorScheme.primary
                  : colorScheme.onSurface.withValues(alpha: 0.3),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: enabled
                          ? colorScheme.onSurface
                          : colorScheme.onSurface.withValues(alpha: 0.4),
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.4),
                      ),
                    ),
                ],
              ),
            ),
            if (!enabled)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: colorScheme.outline.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Bientôt',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurface.withValues(alpha: 0.4),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
