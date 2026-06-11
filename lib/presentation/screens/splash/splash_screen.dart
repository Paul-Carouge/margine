import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Animated splash screen shown on app launch.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<double> _scale;

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

    // Start animation, then navigate home
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _ctrl.forward();
    });
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) context.go('/home');
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
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
