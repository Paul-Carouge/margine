import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/services/update_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../../providers/app_providers.dart';
import '../../widgets/app_toast.dart';

/// Settings screen — apparence, données, and à propos sections.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final themeMode = ref.watch(themeModeProvider);
    final monthlyGoal = ref.watch(monthlyGoalProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          // ── Apparence Section ───────────────────────────────────────────
          _SectionHeader(title: 'Apparence', colorScheme: colorScheme),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(4),
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
                  onTap: () {
                    HapticFeedback.lightImpact();
                    ref.read(themeModeProvider.notifier).state =
                        ThemeMode.light;
                  },
                ),
                const Divider(height: 1, indent: 52),
                _ThemeOption(
                  label: 'Sombre',
                  icon: Icons.dark_mode_outlined,
                  selected: themeMode == ThemeMode.dark,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    ref.read(themeModeProvider.notifier).state =
                        ThemeMode.dark;
                  },
                ),
                const Divider(height: 1, indent: 52),
                _ThemeOption(
                  label: 'Système',
                  icon: Icons.settings_suggest_outlined,
                  selected: themeMode == ThemeMode.system,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    ref.read(themeModeProvider.notifier).state =
                        ThemeMode.system;
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // ── Données Section ─────────────────────────────────────────────
          _SectionHeader(title: 'Données', colorScheme: colorScheme),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: theme.cardTheme.color,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                _DataActionTile(
                  icon: Icons.file_download_outlined,
                  label: 'Exporter en CSV',
                  onTap: () {
                    HapticFeedback.lightImpact();
                    _exportAllData(context, ref);
                  },
                ),
                const Divider(height: 1, indent: 52),
                // Monthly goal row
                _DataActionTile(
                  icon: Icons.flag_outlined,
                  label: 'Objectif de profit mensuel',
                  trailing: '\u20ac${monthlyGoal.toStringAsFixed(0)}',
                  onTap: () => _editMonthlyGoal(context, ref, monthlyGoal),
                ),
                const Divider(height: 1, indent: 52),
                _DataActionTile(
                  icon: Icons.upload_file_outlined,
                  label: 'Importer des données',
                  subtitle: 'Bientôt',
                  enabled: false,
                ),
                const Divider(height: 1, indent: 52),
                _DataActionTile(
                  icon: Icons.delete_sweep_outlined,
                  label: 'Effacer les données',
                  subtitle: 'Bientôt',
                  enabled: false,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // ── À propos Section ────────────────────────────────────────────
          _SectionHeader(title: 'À propos', colorScheme: colorScheme),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: theme.cardTheme.color,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                _AboutRow(
                  icon: Icons.info_outline,
                  label: 'Application',
                  value: 'Margine',
                  theme: theme,
                  colorScheme: colorScheme,
                ),
                const Divider(height: 1, indent: 52),
                _AboutRow(
                  icon: Icons.tag_outlined,
                  label: 'Version',
                  value: '1.3.0',
                  theme: theme,
                  colorScheme: colorScheme,
                ),
                const Divider(height: 1, indent: 52),
                _AboutGitHubRow(theme: theme, colorScheme: colorScheme),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // ── Mise à jour Section ──────────────────────────────────────────
          _SectionHeader(title: 'Mise à jour', colorScheme: colorScheme),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: theme.cardTheme.color,
              borderRadius: BorderRadius.circular(16),
            ),
            child: _UpdateRow(
              onTap: () => _checkForUpdate(context),
            ),
          ),
          const SizedBox(height: 32),

          // ── Footer ──────────────────────────────────────────────────────
          Center(
            child: Text(
              'Margine v1.3.0 · Suivi de revente Vinted',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.4),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _checkForUpdate(BuildContext context) {
    HapticFeedback.lightImpact();
    // Read version from the context — or use a hardcoded constant
    const currentVersion = '1.4.0';
    UpdateService.checkForUpdate(currentVersion).then((update) {
      if (!context.mounted) return;
      if (update != null) {
        UpdateService.showUpdateDialog(
          context,
          update['version']!,
          update['url']!,
        );
      } else {
        showAppToast(context, message: 'Vous êtes à jour', type: ToastType.info);
      }
    });
  }

  void _editMonthlyGoal(BuildContext context, WidgetRef ref, double currentGoal) {
    final controller = TextEditingController(text: currentGoal.toStringAsFixed(0));
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Objectif mensuel'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Montant (€)',
            prefixText: '€ ',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              final value = double.tryParse(controller.text.replaceAll(',', '.'));
              if (value != null && value > 0) {
                ref.read(monthlyGoalProvider.notifier).state = value;
                Navigator.of(ctx).pop();
                showAppToast(context, message: 'Objectif mis à jour', type: ToastType.success);
              }
            },
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );
  }

  Future<void> _exportAllData(BuildContext context, WidgetRef ref) async {
    final dao = ref.read(productDaoProvider);
    final categories = await ref.read(categoryDaoProvider).getAll();
    final products = await dao.getAll();

    if (products.isEmpty) {
      if (context.mounted) {
        showAppToast(context, message: 'Aucune donnée à exporter.', type: ToastType.info);
      }
      return;
    }

    try {
      final buffer = StringBuffer();
      buffer.writeln('Nom,Catégorie,Prix d\'achat,Date d\'achat,Source,'
          'Statut,Prix annoncé,Prix de vente,Date de vente,Frais Vinted,'
          'Frais de port,Emballage,Profit net');

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
          '"${(cat?.name ?? 'Non catégorisé').replaceAll('"', '""')}",'
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
        showAppToast(context, message: 'Échec de l\'export : $e', type: ToastType.error);
      }
    }
  }
}

// -----------------------------------------------------------------------------
// Section header
// -----------------------------------------------------------------------------

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.colorScheme,
  });

  final String title;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 2,
          decoration: BoxDecoration(
            color: colorScheme.primary,
            borderRadius: BorderRadius.circular(1),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
        ),
      ],
    );
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
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: selected
                    ? colorScheme.primary.withValues(alpha: 0.1)
                    : colorScheme.outline.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 20,
                color: selected
                    ? colorScheme.primary
                    : colorScheme.onSurface.withValues(alpha: 0.5),
              ),
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
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  size: 14,
                  color: Colors.white,
                ),
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
    this.trailing,
    this.enabled = true,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String? subtitle;
  final String? trailing;
  final bool enabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: enabled
                    ? colorScheme.primary.withValues(alpha: 0.1)
                    : colorScheme.outline.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 20,
                color: enabled
                    ? colorScheme.primary
                    : colorScheme.onSurface.withValues(alpha: 0.3),
              ),
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
                    const SizedBox(height: 2),
                  if (subtitle != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        subtitle!,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inter',
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (enabled || trailing != null)
              trailing != null
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        trailing!,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inter',
                          color: colorScheme.primary,
                        ),
                      ),
                    )
                  : Icon(
                      Icons.chevron_right,
                      size: 20,
                      color: colorScheme.onSurface.withValues(alpha: 0.3),
                    ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// About row
// -----------------------------------------------------------------------------

class _AboutRow extends StatelessWidget {
  const _AboutRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.theme,
    required this.colorScheme,
  });

  final IconData icon;
  final String label;
  final String value;
  final ThemeData theme;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              size: 20,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// About GitHub row
// -----------------------------------------------------------------------------

class _AboutGitHubRow extends StatelessWidget {
  const _AboutGitHubRow({
    required this.theme,
    required this.colorScheme,
  });

  final ThemeData theme;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showAppToast(context, message: 'https://github.com/paulcarouge/margine', type: ToastType.info);
      },
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFF333333).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.code_outlined,
                size: 20,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'GitHub',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
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
            Icon(
              Icons.open_in_new,
              size: 16,
              color: colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Update check row
// -----------------------------------------------------------------------------

class _UpdateRow extends StatelessWidget {
  const _UpdateRow({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.system_update_outlined,
                size: 20,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Vérifier les mises à jour',
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '1.4.0',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Inter',
                  color: colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.chevron_right,
              size: 20,
              color: colorScheme.onSurface.withValues(alpha: 0.3),
            ),
          ],
        ),
      ),
    );
  }
}
