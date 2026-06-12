import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

/// Résultat d'une vérification de mise à jour.
class UpdateCheckResult {
  final bool hasUpdate;
  final String currentVersion;
  final String? latestVersion;
  final String? releaseNotes;
  final String? downloadUrl;
  final String? error;

  const UpdateCheckResult({
    required this.hasUpdate,
    required this.currentVersion,
    this.latestVersion,
    this.releaseNotes,
    this.downloadUrl,
    this.error,
  });

  factory UpdateCheckResult.upToDate(String currentVersion) {
    return UpdateCheckResult(
      hasUpdate: false,
      currentVersion: currentVersion,
    );
  }

  factory UpdateCheckResult.updateAvailable({
    required String currentVersion,
    required String latestVersion,
    required String releaseNotes,
    required String downloadUrl,
  }) {
    return UpdateCheckResult(
      hasUpdate: true,
      currentVersion: currentVersion,
      latestVersion: latestVersion,
      releaseNotes: releaseNotes,
      downloadUrl: downloadUrl,
    );
  }

  factory UpdateCheckResult.error(String currentVersion, String error) {
    return UpdateCheckResult(
      hasUpdate: false,
      currentVersion: currentVersion,
      error: error,
    );
  }
}

/// Service de vérification des mises à jour via l'API GitHub.
///
/// Interroge la dernière release du dépôt [Paul-Carouge/letabli]
/// et compare la version avec la version actuelle de l'application.
class UpdateService {
  static const _apiUrl =
      'https://api.github.com/repos/Paul-Carouge/letabli/releases/latest';
  static const _dismissedKey = 'dismissed_version';

  final http.Client _client;

  UpdateService({http.Client? client}) : _client = client ?? http.Client();

  /// Récupère la version actuelle de l'application via package_info_plus.
  Future<String> getCurrentVersion() async {
    final info = await PackageInfo.fromPlatform();
    return info.version;
  }

  /// Vérifie si une mise à jour est disponible.
  ///
  /// Retourne un [UpdateCheckResult] avec les détails de la mise à jour
  /// ou une indication que l'application est à jour.
  Future<UpdateCheckResult> checkForUpdate() async {
    final currentVersion = await getCurrentVersion();

    try {
      final response = await _client.get(
        Uri.parse(_apiUrl),
        headers: {
          'Accept': 'application/vnd.github.v3+json',
          'User-Agent': 'Letabli-Updater',
        },
      );

      if (response.statusCode != 200) {
        return UpdateCheckResult.error(
          currentVersion,
          'Erreur API (${response.statusCode})',
        );
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final tagName = data['tag_name'] as String?;
      final body = data['body'] as String? ?? '';
      final assets = data['assets'] as List<dynamic>? ?? [];
      final downloadUrl = assets.isNotEmpty
          ? assets[0]['browser_download_url'] as String?
          : null;

      if (tagName == null) {
        return UpdateCheckResult.error(
          currentVersion,
          'Format de réponse invalide',
        );
      }

      final latestVersion = tagName.startsWith('v') ? tagName.substring(1) : tagName;

      if (_isNewer(latestVersion, currentVersion)) {
        return UpdateCheckResult.updateAvailable(
          currentVersion: currentVersion,
          latestVersion: latestVersion,
          releaseNotes: body,
          downloadUrl: downloadUrl ?? '',
        );
      }

      return UpdateCheckResult.upToDate(currentVersion);
    } catch (e) {
      return UpdateCheckResult.error(
        currentVersion,
        e.toString(),
      );
    }
  }

  /// Sauvegarde la version ignorée dans SharedPreferences.
  Future<void> dismissVersion(String version) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_dismissedKey, version);
  }

  /// Récupère la version ignorée depuis SharedPreferences.
  static Future<String?> getDismissedVersion() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_dismissedKey);
  }

  /// Supprime la version ignorée (pour la vérification manuelle).
  Future<void> clearDismissedVersion() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_dismissedKey);
  }

  /// Comparaison sémantique de versions.
  ///
  /// Retourne `true` si [latest] est strictement supérieure à [current].
  /// Gère correctement les cas comme 3.10.0 > 3.9.0.
  static bool _isNewer(String latest, String current) {
    final latestParts = _parseVersion(latest);
    final currentParts = _parseVersion(current);
    final maxLength = latestParts.length > currentParts.length
        ? latestParts.length
        : currentParts.length;

    for (int i = 0; i < maxLength; i++) {
      final l = i < latestParts.length ? latestParts[i] : 0;
      final c = i < currentParts.length ? currentParts[i] : 0;
      if (l > c) return true;
      if (l < c) return false;
    }
    return false;
  }

  /// Parse une chaîne de version en liste d'entiers.
  ///
  /// "3.10.0" → [3, 10, 0]
  static List<int> _parseVersion(String version) {
    return version
        .split('.')
        .map((part) => int.tryParse(part) ?? 0)
        .toList();
  }

  /// Libère les ressources du client HTTP.
  void dispose() {
    _client.close();
  }
}

/// Affiche le dialog de mise à jour.
///
/// [version] : numéro de la nouvelle version (ex: "3.1.1")
/// [releaseNotes] : notes de version (body GitHub)
/// [downloadUrl] : URL de téléchargement de l'APK
///
/// Retourne `true` si l'utilisateur clique "Mettre à jour", `false` si "Plus tard".
Future<bool?> showUpdateDialog(
  BuildContext context, {
  required String version,
  required String releaseNotes,
  required String downloadUrl,
}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) => UpdateDialog(
      version: version,
      releaseNotes: releaseNotes,
      downloadUrl: downloadUrl,
    ),
  );
}

/// Widget du dialog de mise à jour.
class UpdateDialog extends StatelessWidget {
  final String version;
  final String releaseNotes;
  final String downloadUrl;

  const UpdateDialog({
    super.key,
    required this.version,
    required this.releaseNotes,
    required this.downloadUrl,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    // Limiter les notes de version à ~500 caractères
    final notes = releaseNotes.length > 500
        ? '${releaseNotes.substring(0, 500)}...'
        : releaseNotes;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          Icon(Icons.system_update_rounded, color: cs.primary, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Mise à jour disponible v$version',
              style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (notes.isNotEmpty) ...[
              Text(
                notes,
                style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
              ),
            ] else ...[
              Text(
                'Une nouvelle version est disponible.',
                style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Plus tard'),
        ),
        FilledButton(
          onPressed: () async {
            if (downloadUrl.isNotEmpty) {
              await launchUrl(Uri.parse(downloadUrl),
                  mode: LaunchMode.externalApplication);
            }
            if (context.mounted) {
              Navigator.of(context).pop(true);
            }
          },
          child: const Text('Mettre à jour'),
        ),
      ],
    );
  }
}
