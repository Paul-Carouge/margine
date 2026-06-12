import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../features/update/providers/update_providers.dart';
import '../../../features/update/ui/update_bottom_sheet.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/forge_colors.dart';
import '../../providers/app_providers.dart';

/// Settings screen — theme toggle, goal, data, about.
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _isCheckingUpdate = false;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final themeMode = ref.watch(themeModeProvider);
    final goal = ref.watch(monthlyGoalProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
        children: [
          // ── Theme ───────────────────────────────────────────────────────────
          _SectionHeader(label: 'Affichage'),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                RadioListTile<ThemeMode>(
                  value: ThemeMode.system,
                  groupValue: themeMode,
                  title: const Text('Système'),
                  subtitle: const Text('Suit les réglages de ton téléphone'),
                  activeColor: cs.primary,
                  onChanged: (v) =>
                      ref.read(themeModeProvider.notifier).state = v!,
                ),
                RadioListTile<ThemeMode>(
                  value: ThemeMode.dark,
                  groupValue: themeMode,
                  title: const Text('Sombre'),
                  subtitle: const Text('Mode nuit permanent'),
                  activeColor: cs.primary,
                  onChanged: (v) =>
                      ref.read(themeModeProvider.notifier).state = v!,
                ),
                RadioListTile<ThemeMode>(
                  value: ThemeMode.light,
                  groupValue: themeMode,
                  title: const Text('Clair'),
                  subtitle: const Text('Mode jour permanent'),
                  activeColor: cs.primary,
                  onChanged: (v) =>
                      ref.read(themeModeProvider.notifier).state = v!,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // ── Accent color ────────────────────────────────────────────────────
          _SectionHeader(label: 'Couleur du thème'),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: _AccentColorGrid(),
            ),
          ),
          const SizedBox(height: 20),

          // ── Monthly goal ────────────────────────────────────────────────────
          _SectionHeader(label: 'Objectif'),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Objectif mensuel', style: tt.titleSmall),
                  const SizedBox(height: 4),
                  Text(
                    '${goal.toStringAsFixed(0)} € de marge',
                    style: tt.headlineMedium?.copyWith(color: cs.primary),
                  ),
                  const SizedBox(height: 8),
                  Slider(
                    value: goal.clamp(0, 2000),
                    min: 0,
                    max: 2000,
                    divisions: 40,
                    activeColor: cs.primary,
                    label: '${goal.round()} €',
                    onChanged: (v) =>
                        ref.read(monthlyGoalProvider.notifier).state = v,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('0 €', style: tt.bodySmall),
                      Text('2 000 €', style: tt.bodySmall),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // ── Data ────────────────────────────────────────────────────────────
          _SectionHeader(label: 'Données'),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading:
                      Icon(Icons.file_download_outlined, color: cs.primary),
                  title: const Text('Exporter en CSV'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _exportCsv(context, ref),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // ── Mise à jour ─────────────────────────────────────────────────────
          _SectionHeader(label: 'Mise à jour'),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: Icon(Icons.system_update_rounded, color: cs.primary),
              title: const Text('Rechercher les mises à jour'),
              trailing: _isCheckingUpdate
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: cs.primary,
                      ),
                    )
                  : const Icon(Icons.chevron_right),
              onTap: _isCheckingUpdate ? null : () => _checkUpdate(context),
            ),
          ),
          const SizedBox(height: 20),

          // ── About ───────────────────────────────────────────────────────────
          _SectionHeader(label: 'À propos'),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.code, color: cs.primary),
                  title: const Text('Version'),
                  trailing: FutureBuilder<PackageInfo>(
                    future: PackageInfo.fromPlatform(),
                    builder: (context, snapshot) {
                      final version = snapshot.data?.version ?? '...';
                      return Text(version,
                          style: tt.bodyMedium
                              ?.copyWith(color: cs.onSurfaceVariant));
                    },
                  ),
                ),
                const Divider(indent: 56, height: 1, color: Color(0x1AFFFFFF)),
                const ListTile(
                  leading:
                      Icon(Icons.favorite_outline, color: Color(0xFFD94A3D)),
                  title: Text('Paul Carouge · Orion Team'),
                  subtitle: Text('Construit avec Flutter'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Future<void> _exportCsv(BuildContext context, WidgetRef ref) async {
    try {
      final dao = ref.read(productDaoProvider);
      final products = await dao.getAll();
      final buffer = StringBuffer();
      buffer.writeln(
          'Nom;Statut;Prix achat;Prix vente;Frais Vinted;Frais envoi;Frais emballage;Marge;Date achat;Date vente');
      for (final p in products) {
        final profit = p.status == 'sold' && p.salePrice != null
            ? (p.salePrice! -
                    p.purchasePrice -
                    p.vintedFees -
                    p.shippingCost -
                    p.packagingCost)
                .toStringAsFixed(2)
            : '-';
        buffer.writeln(
            '${p.name};${p.status};${p.purchasePrice};${p.salePrice ?? '-'};${p.vintedFees};${p.shippingCost};${p.packagingCost};$profit;${p.purchaseDate.toIso8601String()};${p.saleDate?.toIso8601String() ?? '-'}');
      }
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/letabli-export.csv');
      await file.writeAsString(buffer.toString());
      await Share.shareXFiles([XFile(file.path)], text: "Export L'Établi");
      HapticFeedback.mediumImpact();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Erreur lors de l'export : $e"),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  /// Vérification manuelle des mises à jour.
  ///
  /// Affiche un loader, appelle l'API GitHub, puis :
  /// - Si à jour : SnackBar "Vous êtes à jour (vX.Y.Z)"
  /// - Si mise à jour dispo : affiche le dialog de mise à jour
  /// - Si erreur : SnackBar "Impossible de vérifier les mises à jour"
  Future<void> _checkUpdate(BuildContext context) async {
    if (_isCheckingUpdate) return;
    setState(() => _isCheckingUpdate = true);

    // Capturer les références avant l'await
    final messenger = ScaffoldMessenger.of(context);
    final errorColor = Theme.of(context).colorScheme.error;

    try {
      final service = ref.read(updateServiceProvider);
      final release = await service.checkForUpdate();

      if (!mounted) return;

      if (release != null) {
        // Vérification manuelle : toujours afficher le dialog
        showUpdateSheet(this.context, release);
      } else {
        final info = await PackageInfo.fromPlatform();
        messenger.showSnackBar(
          SnackBar(
            content: Text('Vous êtes à jour (v${info.version})'),
            backgroundColor: ForgeColors.teal,
          ),
        );
      }
    } catch (_) {
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(
            content: const Text('Impossible de vérifier les mises à jour'),
            backgroundColor: errorColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isCheckingUpdate = false);
      }
    }
  }
}

/// Grille 3×2 de cercles de couleur pour choisir l'accent du thème.
/// Style Coinbase : cercles 48×48px, bordure blanche sur le sélectionné.
class _AccentColorGrid extends ConsumerWidget {
  const _AccentColorGrid();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentColor = ref.watch(accentColorProvider);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1,
      ),
      itemCount: ForgeColors.accentPresets.length,
      itemBuilder: (context, index) {
        final color = ForgeColors.accentPresets[index];
        final isSelected = color == currentColor;

        return GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            ref.read(accentColorProvider.notifier).state = color;
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? Colors.white : Colors.transparent,
                width: 3,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: color.withValues(alpha: 0.4),
                        blurRadius: 12,
                        spreadRadius: 1,
                      ),
                    ]
                  : null,
            ),
            child: isSelected
                ? const Icon(Icons.check, color: Colors.white, size: 22)
                : null,
          ),
        );
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;
  const _SectionHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: [
        Container(
            width: 3,
            height: 14,
            decoration: BoxDecoration(
                color: cs.primary,
                borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 8),
        Text(label,
            style: TextStyle(
                color: cs.onSurfaceVariant,
                fontWeight: FontWeight.w600,
                fontSize: 13)),
      ],
    );
  }
}
