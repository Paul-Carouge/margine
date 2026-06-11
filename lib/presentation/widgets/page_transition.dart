import 'package:flutter/material.dart';

/// A slide-up page transition mimicking iOS navigation push.
///
/// The new page slides up from slightly below the viewport (15% offset)
/// while fading in, producing a natural, premium feel.
///
/// Returns a [Route] — use with [Navigator.push].
Route slideUpRoute(Widget page) => PageRouteBuilder(
      pageBuilder: (_, _, _) => page,
      transitionsBuilder: (_, animation, _, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.15),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
            reverseCurve: Curves.easeInCubic,
          )),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
      transitionDuration: const Duration(milliseconds: 350),
      reverseTransitionDuration: const Duration(milliseconds: 250),
    );

/// A custom [Page] that applies the slide-up + fade transition.
///
/// Use this with GoRouter's [pageBuilder] to get iOS-style animations.
class SlideUpPage extends Page<dynamic> {
  final Widget child;

  const SlideUpPage({super.key, required this.child, super.name, super.arguments, super.restorationId});

  @override
  Route<dynamic> createRoute(BuildContext context) {
    return slideUpRoute(child);
  }
}

/// Returns a [SlideUpPage] for use with GoRouter's [pageBuilder].
SlideUpPage slideUpPage(Widget page, {LocalKey? key}) {
  return SlideUpPage(key: key, child: page);
}

/// A fade-only page transition for modals or simple page changes.
class FadeUpPage extends Page<dynamic> {
  final Widget child;

  const FadeUpPage({super.key, required this.child, super.name, super.arguments, super.restorationId});

  @override
  Route<dynamic> createRoute(BuildContext context) {
    return PageRouteBuilder(
      pageBuilder: (_, _, _) => child,
      transitionsBuilder: (_, animation, _, child) {
        return FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 250),
    );
  }
}

/// Returns a [FadeUpPage] for use with GoRouter's [pageBuilder].
FadeUpPage fadeUpPage(Widget page, {LocalKey? key}) {
  return FadeUpPage(key: key, child: page);
}
