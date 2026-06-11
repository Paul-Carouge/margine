import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// The type of toast to display.
enum ToastType { success, error, info }

/// Shows a styled overlay toast with amethyst/gold theme, sliding up from bottom.
///
/// Automatically dismisses after 3 seconds. Includes haptic feedback:
/// - [ToastType.success]: medium impact
/// - [ToastType.error]: heavy impact
/// - [ToastType.info]: light impact
void showAppToast(
  BuildContext context, {
  required String message,
  ToastType type = ToastType.success,
}) {
  // Haptic feedback
  switch (type) {
    case ToastType.success:
      HapticFeedback.mediumImpact();
    case ToastType.error:
      HapticFeedback.heavyImpact();
    case ToastType.info:
      HapticFeedback.lightImpact();
  }

  final overlay = Overlay.of(context);
  late OverlayEntry entry;

  entry = OverlayEntry(
    builder: (context) => _AppToastOverlay(
      message: message,
      type: type,
      onDismiss: () => entry.remove(),
    ),
  );

  overlay.insert(entry);
}

/// Internal stateful widget for the toast overlay with animation lifecycle.
class _AppToastOverlay extends StatefulWidget {
  final String message;
  final ToastType type;
  final VoidCallback onDismiss;

  const _AppToastOverlay({
    required this.message,
    required this.type,
    required this.onDismiss,
  });

  @override
  State<_AppToastOverlay> createState() => _AppToastOverlayState();
}

class _AppToastOverlayState extends State<_AppToastOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    // Spring-like easing
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();

    // Auto-dismiss after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        _controller.reverse().then((_) {
          if (mounted) widget.onDismiss();
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    final (Color bgColor, Color iconColor, IconData iconData) =
        switch (widget.type) {
      ToastType.success => (
          isLight ? const Color(0xFF2D2B55) : const Color(0xFF818CF8),
          Colors.white,
          Icons.check_circle_rounded,
        ),
      ToastType.error => (
          const Color(0xFFC62828),
          Colors.white,
          Icons.error_outline_rounded,
        ),
      ToastType.info => (
          isLight ? const Color(0xFFB8860B) : const Color(0xFFF5A623),
          Colors.white,
          Icons.info_outline_rounded,
        ),
    };

    return Positioned(
      bottom: MediaQuery.of(context).padding.bottom + 16,
      left: 16,
      right: 16,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(iconData, size: 22, color: iconColor),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.message,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: iconColor,
                      ),
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
