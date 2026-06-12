# Audit d'Architecture & Robustesse — L'Établi

**Date** : 12 juin 2026  
**Auditeur** : Axiom (Équipe Orion)  
**Périmètre** : `/home/atlas/margine` — 15 fichiers Dart + 2 fichiers générés  
**Stack** : Flutter 3.44, Dart 3.12, Riverpod 3.3, Drift 2.34, GoRouter 17.3

---

## Synthèse

L'application est fonctionnelle et le code est propre à l'échelle actuelle, mais **la robustesse est quasi inexistante**. Pas de tests, pas de gestion d'erreur structurée, validation d'entrée minimale, aucun mécanisme de backup, et des problèmes de nommage/incohérence à corriger. Ce rapport liste **37 améliorations concrètes**, classées par criticité.

---

## 1. Structure des fichiers — atomicité, conventions de nommage

### 1.1 ❌ Nom du package vs nom de l'app vs nom de la DB

| Emplacement | Nom utilisé | Devrait être |
|---|---|---|
| `pubspec.yaml` `name:` | `letabli` | ✅ correct |
| `main.dart` `title:` | `"L'Établi"` | ✅ correct |
| Classe `MargineTheme` | `MargineTheme` | **`EtabliTheme`** |
| Widget racine `MargineApp` | `MargineApp` | **`EtabliApp`** |
| `app_database.dart` db file | `margine.db` | **`letabli.db`** |
| `settings_screen.dart` export CSV | `margine-export.csv` | **`letabli-export.csv`** |
| `settings_screen.dart` message | `'Margine est à jour'` | **`L'Établi est à jour`** |
| Classe `MargineTheme` | `.profitGreen`, `.lossRed`, etc. | **`EtabliTheme.profitGreen`**, etc. |

> **Criticité : HAUTE** — Le nom `Margine` est l'ancien nom du projet. Il persiste dans les symboles publics, le nom du fichier DB et les fichiers exportés. Renommer est **cassant pour les utilisateurs existants** (le fichier `margine.db` sera orphelin après renommage). Une **migration avec renommage automatique** est nécessaire.

**Actions :**
1. Renommer `MargineTheme` → `EtabliTheme`
2. Renommer `MargineApp` → `EtabliApp`
3. Renommer le fichier DB : `margine.db` → `letabli.db` **avec détection automatique de l'ancien fichier** (fallback migration)
4. Renommer les exports CSV : `margine-export.csv` → `letabli-export.csv`
5. Corriger le message `'Margine est à jour'`
6. Mettre à jour les commentaires et docstrings qui mentionnent "Margine"

### 1.2 🔶 Fichiers trop volumineux

| Fichier | Lignes | Problème |
|---|---|---|
| `home_screen.dart` | 852 | 10 classes/widgets dans le même fichier |
| `analytics_screen.dart` | 560 | 7 classes/widgets |
| `app_theme.dart` | 300 | thème complet, acceptable mais manque de séparation tokens vs ThemeData |
| `add_product_screen.dart` | 429 | 11 contrôleurs de texte, logique métier inline |

**Actions :**
7. Extraire `_SwipeableCard`, `FilterPills`, `_SortBtn`, `_SortTile`, `_IconBtn`, `_EmptyState`, `_ProductDetailSheet`, `_StatusChip`, `_DetailRow`, `_PhotoPlaceholder` de `home_screen.dart` dans des fichiers séparés sous `widgets/`
8. Extraire `_StatCard`, `_HighlightCard`, `_DataRow`, `_LegendDot`, `_BestWorstSection`, `_MarginCard` de `analytics_screen.dart`
9. Séparer `app_theme.dart` en `app_colors.dart` (tokens/palette) + `app_theme.dart` (ThemeData builders)
10. Extraire la logique métier de `add_product_screen.dart` dans un `AddProductController` (Riverpod `Notifier`) — le screen ne devrait gérer que l'UI

### 1.3 🔶 Conventions de nommage

- `_IconBtn`, `_SortBtn`, `_SortTile` utilisent des abréviations — préférer `_IconButton`, `_SortButton`, `_SortListTile`
- Le fichier `app_database.dart` contient à la fois les tables, les row classes ET la classe `AppDatabase` — envisager `models/product.dart`, `models/category.dart` pour les row classes
- `_fmtDate` est dupliqué dans `home_screen.dart` (ligne 777) et `product_card.dart` (ligne 172) — créer un utilitaire `date_utils.dart`
- La fonction `profitFor()` et `marginPercent()` sont dans `app_providers.dart` — à déplacer dans `models/product.dart` comme méthodes d'extension

**Actions :**
11. Renommer `_IconBtn` → `_IconButton`, `_SortBtn` → `_SortButton`, `_SortTile` → `_SortListTile`
12. Extraire `_fmtDate` dans `lib/core/utils/date_utils.dart`
13. Déplacer `profitFor()` et `marginPercent()` comme extensions sur `Product`

### 1.4 🔶 Fichier `app_database.g.dart` non versionné ?

Le fichier généré fait 1961 lignes. Normalement il est dans `.gitignore`. Vérifier qu'il ne traîne pas dans le repo.

---

## 2. Base de données — nom, migrations, fallback, seed data

### 2.1 ❌ Nom du fichier DB incorrect

```dart
// app_database.dart:224
final file = File(p.join(dbFolder.path, 'margine.db'));
```

Doit devenir `letabli.db`. **Ajouter une logique de migration automatique** : si `margine.db` existe mais pas `letabli.db`, renommer le fichier avant d'ouvrir.

```dart
static LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final newFile = File(p.join(dbFolder.path, 'letabli.db'));
    final oldFile = File(p.join(dbFolder.path, 'margine.db'));
    if (await oldFile.exists() && !await newFile.exists()) {
      await oldFile.rename(newFile.path);
    }
    return NativeDatabase(newFile);
  });
}
```

**Actions :**
14. Renommer `margine.db` → `letabli.db` avec fallback sur l'ancien fichier

### 2.2 🔶 Schéma de migration fragile

```dart
onUpgrade: (Migrator m, int from, int to) async {
  if (from < 2) {
    await m.addColumn(products, products.quantity);
  }
},
```

Problèmes :
- Une seule migration (v1 → v2), pas de stratégie pour les migrations futures
- Pas de `onDowngrade` — si un utilisateur downgrade l'app, la DB sera incompatible
- Pas de vérification `wasCreated` dans `beforeOpen` pour autre chose que le seed

**Actions :**
15. Structurer les migrations avec un pattern plus solide (switch sur `from`/`to`)
16. Ajouter `onDowngrade` qui supprime et recrée (ou refuse le downgrade avec un message clair)
17. Ajouter `beforeOpen` avec `pragma foreign_keys = on`

### 2.3 🔶 Seed data non idempotent

La seed est appelée dans `beforeOpen` quand `details.wasCreated`. C'est correct MAIS :
- Si la seed échoue partiellement (crash), les catégories seront incomplètes au prochain lancement
- Pas de vérification que les catégories existent déjà (cas où `wasCreated` est true mais le seed a déjà été partiellement fait)

**Actions :**
18. Rendre le seed idempotent : vérifier `SELECT COUNT(*) FROM categories` avant d'insérer

### 2.4 🔶 Pas de mécanisme de corruption recovery

Si la DB est corrompue, l'app crash. Drift ne tente pas de réparer.

**Actions :**
19. Ajouter un `try/catch` autour de `NativeDatabase(file)` avec fallback : suppression du fichier corrompu + recréation
20. Logger les erreurs SQL (utiliser `sqflite_common_ffi` ou un intercepteur Drift)

### 2.5 🔶 `categoryId` dans Products a `onDelete: SET NULL` mais `NOT NULL` en base

```dart
IntColumn get categoryId =>
    integer().references(Categories, #id, onDelete: KeyAction.setNull)();
```

Contradiction : la colonne est `NOT NULL` (pas de `.nullable()`) mais la FK dit `ON DELETE SET NULL`. Si on supprime une catégorie, SQLite va tenter de mettre `NULL`, ce qui violera la contrainte `NOT NULL`.

**Actions :**
21. Rendre `categoryId` nullable (`integer().nullable()`) **OU** changer `onDelete` en `KeyAction.cascade` **OU** en `KeyAction.restrict`

---

## 3. Providers Riverpod — réactivité, cache, gestion d'erreur

### 3.1 🔶 Pas de gestion d'état de chargement/erreur dans les providers

```dart
final productsStreamProvider = StreamProvider<List<Product>>((ref) {
  return ref.watch(productDaoProvider).watchAll();
});
```

Le `StreamProvider` expose `AsyncValue<List<Product>>` (data/loading/error), ce qui est bien, mais :
- Aucun retry possible depuis l'UI
- Aucun cache si le stream échoue
- Pas de distinction entre "pas de données" et "erreur"

**Actions :**
22. Ajouter des mécanismes de retry sur les `StreamProvider` avec `.autoDispose` et des stratégies de fallback
23. Logger les erreurs des providers (intercepter avec un `ProviderObserver`)

### 3.2 🔶 `dashboardStatsProvider` et `monthlyStatsProvider` sont inefficaces

```dart
final dashboardStatsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  ref.watch(productsStreamProvider); // recycle tout le calcul à chaque changement
  return ref.watch(productDaoProvider).getStats();
});
```

`getStats()` appelle `select(products).get()` et recalcule tout en Dart. Pour 1000+ produits, ça devient lent.

**Actions :**
24. Remplacer `getStats()` par des requêtes SQL agrégées (SUM, COUNT) plutôt que du calcul Dart
25. Ajouter `selectOnly` ou `customSelect` dans Drift pour les stats

### 3.3 🔶 Pas de `autoDispose` sur les providers

Aucun provider n'utilise `.autoDispose`. Le `databaseProvider` est gardé en vie indéfiniment. Les streams continuent d'écouter même si personne ne les écoute.

**Actions :**
26. Ajouter `autoDispose` sur `productsStreamProvider`, `categoriesStreamProvider`, `productsByStatusProvider`
27. Garder `databaseProvider` en singleton (sans autoDispose — c'est la racine)

### 3.4 🔶 `productByIdProvider` non réactif

```dart
final productByIdProvider = FutureProvider.family<Product?, int>((ref, id) async {
  return ref.watch(productDaoProvider).getById(id);
});
```

Ce provider ne se met pas à jour quand le produit est modifié. L'écran de modification charge les données une fois et ne réagit pas aux changements externes.

**Actions :**
28. Utiliser `watchById(id)` (à créer dans le DAO) ou invalider manuellement le provider après une sauvegarde

### 3.5 🔶 `SortOption`, `statusLabel`, `statusColorValue` dans le mauvais fichier

Ces enum/fonctions sont dans `app_providers.dart` alors qu'elles ne sont pas des providers. Ce sont des utilitaires métier.

**Actions :**
29. Déplacer `SortOption` et les helpers de statut dans `lib/core/models/` ou `lib/data/models/`

---

## 4. Navigation GoRouter — robustesse, deep links

### 4.1 🔶 Pas de gestion d'erreur sur le parsing d'ID

```dart
path: '/article/:id/modifier',
pageBuilder: (context, state) => _slideUp(
  AddProductScreen(
    productId: int.parse(state.pathParameters['id']!),
  ),
  state,
),
```

Si `id` n'est pas un entier valide, `int.parse` throw une `FormatError` → crash.

**Actions :**
30. Ajouter un `redirect` ou une factory de page qui valide le paramètre :
```dart
redirect: (context, state) {
  final id = int.tryParse(state.pathParameters['id'] ?? '');
  if (id == null) return '/home';
  return null;
},
```

### 4.2 🔶 Pas de support deep links

Aucune configuration de deep links (pas de `AndroidManifest` intent filter, pas d'`apple-app-site-association`). Les URL `/article/ajouter` etc. ne sont accessibles que depuis l'app.

**Actions :**
31. Ajouter la configuration deep links pour Android et iOS
32. Ajouter un `redirect` pour les routes inconnues (404 screen)

### 4.3 🔶 `context.go('/home')` dans le splash screen

```dart
Future.delayed(const Duration(milliseconds: 2000), () {
  if (mounted) context.go('/home');
});
```

`context.go()` remplace toute la stack. Si un deep link a amené l'utilisateur ailleurs, le splash va écraser cette navigation.

**Actions :**
33. Utiliser `context.go` uniquement si l'utilisateur est bien à `/`. Sinon, ne rien faire.

---

## 5. Gestion d'erreur — try/catch, messages utilisateur

### 5.1 ❌ Aucune gestion d'erreur sur les opérations DB

```dart
// home_screen.dart:270
void _quickMarkSold(int id) {
  final dao = ref.read(productDaoProvider);
  dao.updateProduct(...); // pas de try/catch, pas de await
  HapticFeedback.heavyImpact();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: const Text('Marqué comme vendu ✓'), ...),
  );
}
```

Si `updateProduct` échoue, le SnackBar affiche "succès" alors que l'opération a échoué.

```dart
// add_product_screen.dart:104
Future<void> _save() async {
  if (!_formKey.currentState!.validate()) return;
  ...
  if (_isEditing) {
    await dao.updateProduct(companion); // pas de try/catch
  } else {
    await dao.insert(companion);        // pas de try/catch
  }
  HapticFeedback.mediumImpact();
  if (mounted) context.pop();
}
```

**Actions :**
34. Wrapper toutes les opérations DB dans un `try/catch` avec SnackBar d'erreur
35. Créer un `ErrorHandler` utilitaire qui log + affiche un message utilisateur
36. Distinguer les erreurs "réseau" (path_provider) des erreurs "métier"

### 5.2 🔶 `_exportCsv` dupliqué avec `try/catch` manquant

La fonction `_exportCsv` existe en **deux copies identiques** :
- `analytics_screen.dart` lignes 304-319
- `settings_screen.dart` lignes 160-176

Aucune n'a de `try/catch`. Si `getTemporaryDirectory()` échoue ou l'écriture de fichier échoue, l'app crash.

**Actions :**
37. Extraire `_exportCsv` dans un service partagé (`lib/data/services/export_service.dart`)
38. Ajouter `try/catch` avec message d'erreur utilisateur

### 5.3 🔶 `_checkUpdate` a une gestion d'erreur silencieuse

```dart
} catch (_) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: const Text('Impossible de vérifier'), backgroundColor: cs.error),
  );
}
```

L'erreur est mangée. Pas de log, pas de distinction entre "pas de réseau" et "timeout" ou "API error".

**Actions :**
39. Ajouter un log de l'erreur réelle
40. Distinguer les types d'erreur (timeout, pas de réseau, parsing error)

---

## 6. Validation d'entrée — formulaire d'ajout de produit

### 6.1 🔶 Validation minimale

Le formulaire `add_product_screen.dart` valide uniquement :
- `name` : non vide
- `price` : non vide + parseable en double

Manquants :
- **Pas de limite de longueur** sur `name` (peut saturer la DB)
- **Pas de validation de prix négatif** (on peut entrer `-50.00` sans être bloqué)
- **Pas de validation que `salePrice` > 0** lors d'une vente
- **Pas de validation de cohérence temporelle** (`saleDate` peut être antérieure à `purchaseDate`)
- **Pas de limite sur les champs texte** (`description`, `notes`, `source`)

**Actions :**
41. Ajouter `maxLength` sur `name` (100 caractères max)
42. Valider que `purchasePrice > 0`
43. Valider que `salePrice > 0` si le statut est `sold`
44. Valider que `saleDate >= purchaseDate` si renseignée
45. Ajouter `maxLength` sur `description` (500), `notes` (1000), `source` (50)
46. Afficher les erreurs de validation **en rouge près du champ** (pas seulement le `validator` par défaut)

### 6.2 🔶 Pas de confirmation avant fermeture

Si l'utilisateur a rempli le formulaire et appuie sur "back", toutes les données sont perdues sans avertissement.

**Actions :**
47. Ajouter un `WillPopScope` (ou `PopScope` en Flutter 3.12) qui vérifie si le formulaire est "dirty" et demande confirmation

### 6.3 🔶 Pas de feedback pendant la sauvegarde

Le bouton "Enregistrer" n'a pas d'état de chargement. Si la DB est lente (gros fichier), l'utilisateur peut double-tap.

**Actions :**
48. Ajouter un `_isSaving` state avec un `CircularProgressIndicator` dans le bouton pendant la sauvegarde
49. Désactiver le bouton et le formulaire pendant la sauvegarde

---

## 7. Tests — ce qu'il faut tester, par où commencer

### 7.1 ❌ Aucune couverture de test

Le seul test existant (`widget_test.dart`) vérifie que `MargineApp` se monte sans erreur. C'est un test vide.

```dart
testWidgets('L\'Établi app renders without error', (WidgetTester tester) async {
  await tester.pumpWidget(const ProviderScope(child: MargineApp()));
  expect(find.byType(MargineApp), findsOneWidget);
});
```

Même ce test est probablement cassé car il tente d'ouvrir une vraie DB.

**Actions — Par où commencer :**

#### Phase 1 : Tests unitaires (priorité maximale)
50. Tester `ProductDao` avec une DB in-memory
    - `getStats()` retourne les bons agrégats
    - `getMonthlyStats()` groupe correctement
    - `getByDateRange()` filtre correctement
    - `insert()` + `getById()` roundtrip
    - `updateProduct()` modifie bien
    - `deleteProduct()` supprime
51. Tester `CategoryDao`
    - CRUD basique
    - Le seed data est correctement inséré
52. Tester les helpers métier
    - `profitFor()` calcule correctement
    - `marginPercent()` gère les cas limites (prix = 0, profit négatif)
    - `statusLabel()` et `statusColorValue()`

#### Phase 2 : Tests de providers
53. Tester `dashboardStatsProvider` avec une DB mockée
54. Tester `monthlyStatsProvider`
55. Tester les providers de filtrage et tri

#### Phase 3 : Tests de widget
56. `AddProductScreen` : validation de formulaire, sauvegarde, chargement pour édition
57. `HomeScreen` : affichage liste vide, filtrage, tri, swipe-to-sell
58. `AnalyticsScreen` : affichage avec données, affichage vide
59. `SettingsScreen` : changement de thème, slider d'objectif

#### Phase 4 : Tests d'intégration
60. Flux complet : ajouter un produit → le voir dans la liste → le marquer comme vendu → voir les stats mises à jour

**Infrastructure nécessaire :**
- Ajouter `drift/native.dart` avec `NativeDatabase.memory()` pour les tests
- Créer un `TestAppDatabase` qui surcharge `_openConnection()` pour utiliser une DB in-memory
- Mock/override le `databaseProvider` dans les tests Riverpod

---

## 8. Backup/export — données utilisateur

### 8.1 ❌ Pas de backup automatique

L'utilisateur peut perdre toutes ses données si :
- L'app est désinstallée
- Le téléphone est réinitialisé
- Le fichier DB est corrompu

**Actions :**
61. Ajouter un export JSON (en plus du CSV existant) qui inclut TOUTES les données (catégories, produits) pour une restauration complète
62. Ajouter un import JSON (restauration)
63. Proposer un backup automatique périodique (hebdomadaire) avec `workmanager` ou au minimum une notification de rappel
64. Ajouter un export vers Google Drive / iCloud (via `share_plus` ou intégration native)

### 8.2 🔶 Export CSV incomplet

L'export CSV n'inclut pas :
- La catégorie du produit (juste l'ID)
- La description
- Les notes
- Le `listingPrice` / `minPrice`
- Les catégories elles-mêmes

**Actions :**
65. Compléter l'export CSV avec toutes les colonnes
66. Ajouter un séparateur qui échappe correctement les virgules dans les noms (utiliser un vrai CSV encoder)

### 8.3 🔶 Pas d'export des catégories personnalisées

Si l'utilisateur crée des catégories personnalisées, elles ne survivent pas à une réinstallation.

**Actions :**
67. Inclure les catégories dans l'export/import
68. Permettre la réinitialisation aux catégories par défaut

---

## 9. Performance — rebuild count, const widgets

### 9.1 🔶 Rebuilds excessifs dans `HomeScreen`

```dart
final statsAsync = ref.watch(dashboardStatsProvider);
final filter = ref.watch(filterStatusProvider);
final searchQuery = ref.watch(searchQueryProvider);
final showSearch = ref.watch(showSearchProvider);
final sortOption = ref.watch(sortOptionProvider);
final productsAsync = filter == 'all'
    ? ref.watch(productsStreamProvider)
    : ref.watch(productsByStatusProvider(filter));
```

6 providers regardés → rebuild complet à chaque changement. Quand l'utilisateur tape dans la barre de recherche, le `HomeScreen` entier se rebuild.

**Actions :**
69. Isoler la barre de recherche dans un widget séparé qui ne rebuild que lui-même
70. Isoler les `FilterPills` pour qu'ils ne rebuild pas la liste
71. Utiliser `select` pour ne rebuild que sur certaines propriétés des providers
72. Sortir le `CustomScrollView` dans un widget `const` séparé

### 9.2 🔶 Widgets non-const

Parcouru le code, plusieurs widgets pourraient être `const` :

- `_StatusChip`, `_StatusBadge`, `_DetailRow`, `_StatCell`, `_LegendDot` : leurs constructeurs devraient être `const` (ils le sont déjà pour la plupart, bien)
- Les `Padding`, `SizedBox`, `Divider`, `Icon` dans les `build()` ne sont pas tous marqués `const`
- `TextStyle` créés inline dans les `build()` (ex: ligne 518, 845) — pas de `const` possible car dépendent de `isSelected` mais pourraient être extraits

**Actions :**
73. Faire une passe `flutter analyze` avec la règle `prefer_const_constructors` activée
74. Extraire les `TextStyle` récurrents dans des constantes de classe

### 9.3 🔶 `_buildTheme` recrée le TextTheme à chaque appel

```dart
static ThemeData _buildTheme(...) {
  return ThemeData(
    textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme).copyWith(
      displayLarge: GoogleFonts.sora(...),
      displayMedium: GoogleFonts.sora(...),
      // ... 15 styles
    ),
  );
}
```

`GoogleFonts.interTextTheme()` est appelé à chaque changement de thème (switch light/dark). Les polices Google Fonts téléchargent potentiellement à chaque fois.

**Actions :**
75. Mettre en cache les `TextTheme` light et dark — les construire une fois
76. Utiliser `GoogleFonts.config.allowRuntimeFetching = false` en production et bundler les polices

### 9.4 🔶 `product_card.dart` : `_GradientBg` n'est pas `const`

```dart
class _GradientBg extends StatelessWidget {
  final ColorScheme cs;
  const _GradientBg(this.cs);
```

Le constructeur est `const` mais le widget est recréé à chaque fois car il dépend de `cs`. Pourrait être optimisé en extrayant le gradient dans une constante par thème.

### 9.5 🔶 `getStats()` et `getMonthlyStats()` en O(n)

Les calculs de stats parcourent tous les produits en mémoire à chaque appel. Pour 10 000 produits, c'est lent.

**Actions :**
77. Remplacer par des requêtes SQL agrégées : `SELECT SUM(purchase_price), COUNT(*) FROM products WHERE status = 'sold'`
78. Ajouter des index sur `status` (existe déjà via `@TableIndex`) et `purchaseDate` pour les filtres temporels

---

## Récapitulatif des actions par criticité

### 🔴 CRITIQUE (bloquant pour la v1.0 publique)
| # | Action | Fichier |
|---|---|---|
| 14 | Renommer `margine.db` → `letabli.db` avec fallback | `app_database.dart` |
| 34 | try/catch sur toutes les opérations DB | multi-fichiers |
| 38 | try/catch export CSV | `analytics_screen.dart`, `settings_screen.dart` |
| 21 | Résoudre contradiction FK `NOT NULL` + `ON DELETE SET NULL` | `app_database.dart` |
| 30 | Valider `int.parse` dans GoRouter | `app_router.dart` |

### 🟠 HAUTE
| # | Action |
|---|---|
| 1-6 | Renommer tout `Margine*` → `Etabli*` |
| 41-46 | Validation d'entrée complète sur le formulaire |
| 50-52 | Tests unitaires DAO |
| 61-64 | Mécanisme de backup/export |
| 47 | Confirmation avant fermeture du formulaire dirty |

### 🟡 MOYENNE
| # | Action |
|---|---|
| 7-10 | Découpage des fichiers volumineux |
| 11-13 | Conventions de nommage |
| 22-23 | Gestion d'erreur dans les providers |
| 24-25 | Requêtes SQL agrégées pour les stats |
| 15-17 | Migration strategy robuste |
| 69-72 | Optimisation rebuilds HomeScreen |

### 🟢 BASSE
| # | Action |
|---|---|
| 26-27 | autoDispose sur les providers |
| 28 | Réactivité productByIdProvider |
| 31-33 | Deep links, 404 screen |
| 48-49 | État de chargement pendant sauvegarde |
| 73-76 | const widgets, cache des polices |

---

## Conclusion

L'Établi a une **base saine** : architecture claire (data/core/presentation), choix technos cohérents, code propre et lisible. Mais la **robustesse est le maillon faible**. L'application est fragile face aux erreurs, n'a aucune couverture de test, et porte encore le nom de l'ancien projet `Margine` dans des endroits critiques.

**Recommandation prioritaire** : attaquer d'abord les 5 points 🔴 CRITIQUE, puis les tests unitaires DAO (🟠), puis la validation d'entrée (🟠). Le renommage complet `Margine` → `Etabli` doit être fait AVANT la publication publique pour éviter une migration douloureuse plus tard.

**Estimation d'effort** : ~5-7 jours pour les points critiques + hauts, ~3-4 jours supplémentaires pour les points moyens et bas.
