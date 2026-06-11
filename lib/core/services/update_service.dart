import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Service for checking and downloading app updates from GitHub releases.
class UpdateService {
  static const String _githubApi =
      'https://api.github.com/repos/Paul-Carouge/margine/releases/latest';

  /// Checks GitHub for a newer release than [currentVersion].
  ///
  /// Returns a map with `version` and `url` keys if a newer version exists,
  /// or `null` if already up-to-date or on error.
  static Future<Map<String, String>?> checkForUpdate(
    String currentVersion,
  ) async {
    try {
      final client = HttpClient();
      client.userAgent = 'margine-update-checker';

      final request = await client.getUrl(Uri.parse(_githubApi));
      request.headers.set('Accept', 'application/vnd.github+json');
      request.headers.set('User-Agent', 'margine-update-checker');

      final response = await request.close();

      if (response.statusCode != 200) return null;

      final body = await response.transform(utf8.decoder).join();
      final json = jsonDecode(body) as Map<String, dynamic>;

      final tagName = json['tag_name'] as String?;
      final assets = json['assets'] as List<dynamic>?;

      if (tagName == null || assets == null || assets.isEmpty) return null;

      // Parse GitHub tag version (e.g. "v1.4.0") and strip "v" prefix
      final latestVersion = tagName.startsWith('v')
          ? tagName.substring(1)
          : tagName;

      if (!_isNewer(latestVersion, currentVersion)) return null;

      // Get the first APK asset's download URL
      final apkUrl = (assets[0] as Map<String, dynamic>)['browser_download_url']
          as String?;

      if (apkUrl == null) return null;

      return {'version': latestVersion, 'url': apkUrl};
    } catch (_) {
      return null;
    }
  }

  /// Opens [url] in an external browser to start the download.
  static Future<void> openDownload(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  /// Shows a dialog asking the user if they want to download [version].
  ///
  /// "Plus tard" dismisses, "Télécharger" opens the [apkUrl] in-browser.
  static void showUpdateDialog(
    BuildContext context,
    String version,
    String apkUrl,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Mise à jour disponible'),
        content: Text('La version $version est disponible. Télécharger ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Plus tard'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              openDownload(apkUrl);
            },
            child: const Text('Télécharger'),
          ),
        ],
      ),
    );
  }

  /// Compares two semantic version strings (e.g. "1.4.0" vs "1.3.0").
  ///
  /// Returns `true` if [latest] is strictly greater than [current].
  static bool _isNewer(String latest, String current) {
    final latestParts = latest.split('.');
    final currentParts = current.split('.');

    final maxLen = latestParts.length > currentParts.length
        ? latestParts.length
        : currentParts.length;

    for (int i = 0; i < maxLen; i++) {
      final l = i < latestParts.length ? int.tryParse(latestParts[i]) ?? 0 : 0;
      final c =
          i < currentParts.length ? int.tryParse(currentParts[i]) ?? 0 : 0;

      if (l > c) return true;
      if (l < c) return false;
    }

    return false;
  }
}
