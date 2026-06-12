import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../features/update/providers/update_providers.dart';
import '../../../features/update/ui/update_bottom_sheet.dart';

/// Animated splash screen shown on app launch.
///
/// After the animation, checks for updates via GitHub API.
/// If an update is available, shows the update dialog before navigating home.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<double> _scale;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _fade = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    );
    _scale = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.1, 0.8, curve: Curves.elasticOut),
    );

    // Start animation, then check for updates before navigating
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _ctrl.forward();
    });
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) _checkUpdateAndNavigate();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _checkUpdateAndNavigate() async {
    if (_navigated) return;

    try {
      final service = ref.read(updateServiceProvider);
      final release = await service.checkForUpdate();

      if (!mounted) return;

      if (release != null) {
        // Une mise à jour est disponible — afficher le dialog
        final alreadyShown = ref.read(updateShownForVersionProvider);
        if (release.version != alreadyShown) {
          ref.read(updateShownForVersionProvider.notifier).state = release.version;
          showUpdateSheet(context, release);
        }
      }
    } catch (_) {
      // Ignorer les erreurs réseau silencieusement au splash
    }

    if (mounted && !_navigated) {
      _navigated = true;
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: Center(
        child: AnimatedBuilder(
          animation: _ctrl,
          builder: (context, child) => FadeTransition(
            opacity: _fade,
            child: ScaleTransition(
              scale: _scale,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ── Logo icon ──────────────────────────────────────────
                  Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      color: cs.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Icon(
                      Icons.workspaces_outline,
                      size: 44,
                      color: cs.primary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // ── App name ───────────────────────────────────────────
                  Text(
                    "L'Établi",
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          color: cs.onSurface,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.5,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'L\'atelier de vos reventes',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
