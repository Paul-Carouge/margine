import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../services/update_service.dart';

final updateServiceProvider = Provider<UpdateService>((ref) {
  return UpdateService(owner: 'Paul-Carouge', repo: 'letabli');
});

/// Cache la dernière vérification pour ne pas re-scanner GitHub à chaque rebuild.
final lastUpdateCheckProvider = StateProvider<GithubRelease?>((ref) => null);

/// Flag pour afficher la notification une seule fois par session.
final updateShownForVersionProvider = StateProvider<String?>((ref) => null);

/// Vérifie les mises à jour (une fois seulement, résultat mis en cache).
final updateCheckProvider = FutureProvider<GithubRelease?>((ref) async {
  final cached = ref.watch(lastUpdateCheckProvider);
  if (cached != null) return cached;

  final service = ref.watch(updateServiceProvider);
  final release = await service.checkForUpdate();
  if (release != null) {
    ref.read(lastUpdateCheckProvider.notifier).state = release;
  }
  return release;
});
