import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:version/version.dart';
import 'package:open_filex/open_filex.dart';

class GithubRelease {
  final String tagName;
  final String version;
  final String apkUrl;
  final String apkName;
  final String? changelog;

  GithubRelease({
    required this.tagName,
    required this.version,
    required this.apkUrl,
    required this.apkName,
    this.changelog,
  });
}

class UpdateService {
  final Dio _dio;
  final String _owner;
  final String _repo;

  /// Chemin du dernier APK téléchargé (utilisé pour l'installation).
  String? lastDownloadedPath;

  UpdateService({required String owner, required String repo})
      : _owner = owner,
        _repo = repo,
        _dio = Dio(BaseOptions(connectTimeout: const Duration(seconds: 10)));

  /// Vérifie si une mise à jour est disponible sur GitHub.
  /// Retourne la release si une version plus récente existe.
  Future<GithubRelease?> checkForUpdate() async {
    try {
      final response = await _dio.get(
        'https://api.github.com/repos/$_owner/$_repo/releases/latest',
        options: Options(
          headers: {'Accept': 'application/vnd.github.v3+json'},
        ),
      );

      final data = response.data as Map<String, dynamic>;
      final tagName = data['tag_name'] as String;
      final remoteVersion = tagName.replaceFirst(RegExp(r'^v'), '');

      // Comparer les versions
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = Version.parse(packageInfo.version);
      final latestVersion = Version.parse(remoteVersion);

      if (latestVersion <= currentVersion) return null;

      // Trouver l'asset APK
      final assets = (data['assets'] as List?)?.cast<Map<String, dynamic>>() ?? [];
      final apkAsset = _findApkAsset(assets);
      if (apkAsset == null) return null;

      return GithubRelease(
        tagName: tagName,
        version: remoteVersion,
        apkUrl: apkAsset['browser_download_url'] as String,
        apkName: apkAsset['name'] as String,
        changelog: data['body'] as String?,
      );
    } catch (_) {
      return null;
    }
  }

  Map<String, dynamic>? _findApkAsset(List<Map<String, dynamic>> assets) {
    // Chercher un APK universel ou app-release
    for (final name in ['universal', 'app-release', 'letabli-']) {
      for (final asset in assets) {
        final assetName = asset['name'] as String? ?? '';
        if (assetName.contains(name) && assetName.endsWith('.apk')) {
          return asset;
        }
      }
    }
    // Fallback : premier APK
    for (final asset in assets) {
      if ((asset['name'] as String?)?.endsWith('.apk') == true) return asset;
    }
    return null;
  }

  /// Télécharge l'APK avec progression.
  Future<String?> downloadApk(
    String url,
    String fileName, {
    void Function(double progress)? onProgress,
  }) async {
    try {
      final dir = await getExternalStorageDirectory();
      if (dir == null) return null;

      // Utiliser le cache externe (accessible par le Package Installer)
      final parentPath = dir.parent.path; // remonte de Android/data/.../files
      final cacheDir = Directory('$parentPath/cache');
      if (!await cacheDir.exists()) {
        await cacheDir.create(recursive: true);
      }

      final filePath = '${cacheDir.path}/$fileName';

      await _dio.download(
        url,
        filePath,
        onReceiveProgress: (received, total) {
          if (total > 0 && onProgress != null) {
            onProgress(received / total);
          }
        },
      );

      lastDownloadedPath = filePath;
      return filePath;
    } catch (_) {
      return null;
    }
  }

  /// Ouvre l'APK avec l'installateur Android.
  /// Priorise le platform channel direct (plus fiable), fallback sur open_filex.
  Future<bool> installApk(String filePath) async {
    try {
      const channel = MethodChannel('com.letabli.app/installer');
      await channel.invokeMethod('installApk', {'filePath': filePath});
      return true;
    } on MissingPluginException {
      // Fallback sur open_filex si le channel natif n'est pas enregistré
      try {
        await OpenFilex.open(
          filePath,
          type: 'application/vnd.android.package-archive',
        );
        return true;
      } catch (_) {
        return false;
      }
    } catch (_) {
      return false;
    }
  }
}
