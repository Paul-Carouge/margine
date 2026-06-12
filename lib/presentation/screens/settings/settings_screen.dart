import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/forge_colors.dart';
import '../../providers/app_providers.dart';

/// Settings screen — theme toggle, goal, data, about.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                Divider(indent: 56, height: 1, color: cs.outlineVariant),
                ListTile(
                  leading: Icon(Icons.info_outline, color: cs.primary),
                  title: const Text('Vérifier les mises à jour'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _checkUpdate(context),
                ),
              ],
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
                  trailing: Text('3.0.0',
                      style: tt.bodyMedium
                          ?.copyWith(color: cs.onSurfaceVariant)),
                ),
                Divider(indent: 56, height: 1, color: cs.outlineVariant),
                ListTile(
                  leading: const Icon(Icons.favorite_outline,
                      color: Color(0xFFD94A3D)),
                  title: const Text('Paul Carouge · Orion Team'),
                  subtitle: const Text('Construit avec Flutter'),
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

  Future<void> _checkUpdate(BuildContext context) async {
    final cs = Theme.of(context).colorScheme;
    try {
      final uri = Uri.parse(
          'https://api.github.com/repos/Paul-Carouge/margine/releases/latest');
      final client = HttpClient();
      final request = await client.getUrl(uri);
      final response = await request.close();
      final body = await response.transform(utf8.decoder).join();

      if (body.contains('"tag_name"')) {
        final tag = body.split('"tag_name":"')[1].split('"')[0];
        const current = '3.0.0';
        if (tag.compareTo(current) > 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Mise à jour disponible : $tag'),
              action: SnackBarAction(
                label: 'Télécharger',
                onPressed: () => launchUrl(Uri.parse(
                    'https://github.com/Paul-Carouge/margine/releases/latest')),
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text("L'Établi est à jour"),
              backgroundColor: const Color(0xFF14B8A6),
            ),
          );
        }
      }
      client.close();
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Impossible de vérifier'),
          backgroundColor: cs.error,
        ),
      );
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
