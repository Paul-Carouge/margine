import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../core/theme/forge_colors.dart';
import '../services/update_service.dart';
import '../providers/update_providers.dart';
import '../../../presentation/providers/app_providers.dart';

/// Dialog élégant de mise à jour — centré, sans conflit avec la BottomNavBar.
class UpdateDialog extends ConsumerStatefulWidget {
  final GithubRelease release;

  const UpdateDialog({super.key, required this.release});

  @override
  ConsumerState<UpdateDialog> createState() => _UpdateDialogState();
}

class _UpdateDialogState extends ConsumerState<UpdateDialog> {
  double _progress = 0;
  bool _isDownloading = false;
  String? _error;
  bool _installReady = false;

  @override
  Widget build(BuildContext context) {
    final accent = ref.watch(accentColorProvider);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          color: ForgeColors.surfaceOverlay,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 32,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _installReady
                        ? Icons.check_circle_rounded
                        : Icons.system_update_rounded,
                    color: _installReady
                        ? const Color(0xFF22C55E)
                        : accent,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 20),

                // Title
                Text(
                  _installReady
                      ? 'Téléchargement terminé'
                      : 'Mise à jour disponible',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: ForgeColors.textPrimary,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 8),

                // Version info
                FutureBuilder<PackageInfo>(
                  future: PackageInfo.fromPlatform(),
                  builder: (context, snapshot) {
                    final current = snapshot.data?.version ?? '...';
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: ForgeColors.surface,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'v$current',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: ForgeColors.textSecondary,
                              fontFamily: 'monospace',
                              letterSpacing: -0.3,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Icon(
                              Icons.arrow_forward_rounded,
                              size: 18,
                              color: accent,
                            ),
                          ),
                          Text(
                            'v${widget.release.version}',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: accent,
                              fontFamily: 'monospace',
                              letterSpacing: -0.3,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),

                // Changelog
                if (!_installReady &&
                    widget.release.changelog != null &&
                    widget.release.changelog!.isNotEmpty) ...[
                  Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(maxHeight: 200),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: ForgeColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: ForgeColors.outline),
                    ),
                    child: SingleChildScrollView(
                      child: _buildChangelog(widget.release.changelog!, accent),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                // Install ready message
                if (_installReady) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF22C55E).withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                          color: const Color(0xFF22C55E).withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle_rounded,
                            color: Color(0xFF22C55E), size: 22),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'La mise à jour v${widget.release.version} '
                            'est prête à être installée.',
                            style: const TextStyle(
                              fontSize: 14,
                              color: ForgeColors.textPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                // Progress
                if (_isDownloading && !_installReady) ...[
                  Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: _progress > 0 ? _progress : null,
                          minHeight: 8,
                          backgroundColor: ForgeColors.outline,
                          valueColor: AlwaysStoppedAnimation<Color>(accent),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.download_rounded,
                              size: 16, color: ForgeColors.textSecondary),
                          const SizedBox(width: 6),
                          Text(
                            _progress > 0
                                ? 'Téléchargement… ${(_progress * 100).toStringAsFixed(0)}%'
                                : 'Préparation du téléchargement…',
                            style: const TextStyle(
                              fontSize: 13,
                              color: ForgeColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],

                // Error
                if (_error != null) ...[
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: ForgeColors.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: ForgeColors.error.withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline_rounded,
                            color: ForgeColors.error, size: 20),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            _error!,
                            style: const TextStyle(
                              color: ForgeColors.error,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: (_isDownloading || _installReady)
                            ? null
                            : () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: ForgeColors.textPrimary,
                          side: const BorderSide(color: ForgeColors.outline),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text('Plus tard'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _isDownloading
                            ? null
                            : (_installReady
                                ? _installNow
                                : _downloadAndInstall),
                        icon: _isDownloading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Icon(
                                _installReady
                                    ? Icons.install_mobile_rounded
                                    : Icons.download_rounded,
                                size: 20,
                              ),
                        label: Text(
                          _installReady
                              ? 'Installer'
                              : _isDownloading
                                  ? 'En cours…'
                                  : 'Mettre à jour',
                          style: const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 15),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _installReady
                              ? const Color(0xFF22C55E)
                              : accent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),

                // Footnote
                const Text(
                  'Application ouverte après installation',
                  style: TextStyle(
                    fontSize: 11,
                    color: ForgeColors.textDisabled,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Construit un rendu riche du changelog markdown.
  Widget _buildChangelog(String body, Color accent) {
    final lines =
        body.split('\n').where((l) => l.trim().isNotEmpty).toList();

    if (lines.isEmpty) return const SizedBox.shrink();

    final children = <Widget>[];
    int i = 0;

    while (i < lines.length) {
      final line = lines[i].trim();

      // Divider ---
      if (line.startsWith('---')) {
        children.add(Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: const Divider(
            color: ForgeColors.outline,
            height: 1,
            thickness: 1,
          ),
        ));
        i++;
        continue;
      }

      // Section header ##
      if (line.startsWith('## ')) {
        final title = line.substring(3).trim();
        final icon = _sectionIcon(title);
        final label = _sectionLabel(title);
        children.add(Padding(
          padding: const EdgeInsets.only(top: 4, bottom: 6),
          child: Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: 16, color: accent),
                const SizedBox(width: 8),
              ],
              Text(
                label,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: ForgeColors.textPrimary,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
        ));
        i++;
        continue;
      }

      // Subsection ###
      if (line.startsWith('### ')) {
        final title = line.substring(4).trim();
        children.add(Padding(
          padding: const EdgeInsets.only(top: 2, bottom: 4),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: ForgeColors.textSecondary,
              letterSpacing: -0.2,
            ),
          ),
        ));
        i++;
        continue;
      }

      // Bullet point
      if (line.startsWith('- ') || line.startsWith('* ')) {
        final content = line.substring(2).trim();
        children.add(_buildBulletPoint(content, accent));
        i++;
        continue;
      }

      // Numbered list
      if (RegExp(r'^\d+\. ').hasMatch(line)) {
        final content = line.replaceFirst(RegExp(r'^\d+\. '), '');
        children.add(_buildBulletPoint(content, accent, prefix: '•'));
        i++;
        continue;
      }

      // Regular paragraph
      children.add(Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: _buildRichText(line),
      ));
      i++;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  /// Construit un point de liste avec support gras.
  Widget _buildBulletPoint(String content, Color accent,
      {String prefix = '•'}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2, right: 8),
            child: Text(
              prefix,
              style: TextStyle(
                fontSize: 12,
                color: accent,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(child: _buildRichText(content)),
        ],
      ),
    );
  }

  /// Construit un texte enrichi avec support **gras**.
  Widget _buildRichText(String text) {
    final spans = <InlineSpan>[];
    final regex = RegExp(r'\*\*(.+?)\*\*');
    int lastEnd = 0;

    for (final match in regex.allMatches(text)) {
      // Texte avant le gras
      if (match.start > lastEnd) {
        spans.add(TextSpan(
          text: text.substring(lastEnd, match.start),
          style: const TextStyle(
              fontSize: 13, color: ForgeColors.textSecondary, height: 1.5),
        ));
      }
      // Texte en gras
      spans.add(TextSpan(
        text: match.group(1),
        style: const TextStyle(
          fontSize: 13,
          color: ForgeColors.textPrimary,
          fontWeight: FontWeight.w600,
          height: 1.5,
        ),
      ));
      lastEnd = match.end;
    }

    // Reste du texte
    if (lastEnd < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastEnd),
        style: const TextStyle(
            fontSize: 13, color: ForgeColors.textSecondary, height: 1.5),
      ));
    }

    return RichText(
      text: TextSpan(children: spans),
    );
  }

  /// Retourne l'icône associée à un titre de section.
  IconData? _sectionIcon(String title) {
    final lower = title.toLowerCase();
    if (lower.contains('nouveaut') || lower.contains('ajout') ||
        lower.contains('feature') || lower.contains('✨')) {
      return Icons.auto_awesome_rounded;
    }
    if (lower.contains('corrig') || lower.contains('fix') ||
        lower.contains('bug') || lower.contains('🐛') ||
        lower.contains('répar')) {
      return Icons.bug_report_rounded;
    }
    if (lower.contains('technique') || lower.contains('amélior') ||
        lower.contains('perf') || lower.contains('refactor') ||
        lower.contains('🔧')) {
      return Icons.tune_rounded;
    }
    if (lower.contains('sécurité') || lower.contains('🔒')) {
      return Icons.security_rounded;
    }
    if (lower.contains('interface') || lower.contains('ui') ||
        lower.contains('design') || lower.contains('🎨')) {
      return Icons.palette_rounded;
    }
    return null;
  }

  /// Nettoie le titre de section (enlève les émojis de début).
  String _sectionLabel(String title) {
    return title.replaceFirst(RegExp(r'^[^\w\s]{1,3}\s*'), '').trim();
  }

  Future<void> _downloadAndInstall() async {
    HapticFeedback.mediumImpact();

    setState(() {
      _isDownloading = true;
      _error = null;
    });

    final service = ref.read(updateServiceProvider);
    final filePath = await service.downloadApk(
      widget.release.apkUrl,
      widget.release.apkName,
      onProgress: (p) {
        if (mounted) setState(() => _progress = p);
      },
    );

    if (filePath == null) {
      if (mounted) {
        setState(() {
          _isDownloading = false;
          _error = 'Impossible de télécharger la mise à jour.\n'
              'Vérifiez votre connexion Internet et l\'espace de stockage disponible.';
        });
      }
      return;
    }

    // Install ready — l'APK est téléchargé, on demande à l'utilisateur
    setState(() {
      _isDownloading = false;
      _installReady = true;
    });

    HapticFeedback.heavyImpact();
  }

  Future<void> _installNow() async {
    HapticFeedback.mediumImpact();

    final service = ref.read(updateServiceProvider);
    final filePath = service.lastDownloadedPath;
    if (filePath == null) return;

    final success = await service.installApk(filePath);
    if (mounted) {
      if (success) {
        Navigator.pop(context);
      } else {
        setState(() {
          _error = 'Impossible de lancer l\'installation. '
              'Ouvrez manuellement le fichier APK téléchargé.';
        });
      }
    }
  }
}

/// Affiche le dialog de mise à jour (centré, au-dessus de tout).
void showUpdateSheet(BuildContext context, GithubRelease release) {
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withValues(alpha: 0.6),
    builder: (_) => UpdateDialog(release: release),
  );
}
