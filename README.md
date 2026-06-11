# L'Établi

**Gérez vos achats et reventes avec précision.**

L'Établi est une application mobile Flutter qui vous permet de suivre l'intégralité de votre activité de revente : achats, ventes, marges, frais et statistiques. Conçue pour être simple et efficace, elle stocke toutes vos données localement — rien ne quitte votre téléphone.

---

## Fonctionnalités

| Catégorie | Détail |
|-----------|--------|
| **Suivi des articles** | Ajoutez des articles avec photo, prix d'achat, provenance, frais |
| **Statuts personnalisés** | En stock · En ligne · Vendu — changez le statut en un geste |
| **Calcul automatique** | Marge brute calculée automatiquement : prix de vente − achat − frais |
| **Tableau de bord** | Cockpit 2×2 : dépenses, revenus, marge, stock |
| **Statistiques détaillées** | ROI, profit moyen, meilleure/pire marge, graphique donut |
| **Export CSV** | Export de toutes vos données en un clic |
| **Objectif mensuel** | Définissez un objectif de marge et suivez votre progression |
| **Photos** | Une photo par article pour identifier vos produits au premier coup d'œil |
| **Mode sombre** | Thème clair, sombre ou automatique (suit votre téléphone) |
| **Stockage 100% local** | Aucun compte, aucun cloud — vos données vous appartiennent |

---

## Captures d'écran

*À venir — ou contribuez en soumettant vos propres captures !*

---

## Stack technique

- **Framework** : Flutter 3.44 (Dart 3.12)
- **State Management** : Riverpod 3
- **Base de données** : Drift (SQLite)
- **Navigation** : GoRouter
- **Graphiques** : fl_chart
- **Partage** : share_plus
- **Design System** : Material 3 — palette Safran & Ardoise

---

## Installation

### Depuis le Play Store
*Bientôt disponible*

### APK (Android)
[Télécharger la dernière version](https://github.com/Paul-Carouge/letabli/releases/latest)

### Compilation manuelle
```bash
git clone https://github.com/Paul-Carouge/letabli.git
cd letabli
flutter pub get
flutter build apk --release
```

L'APK compilée se trouve dans `build/app/outputs/flutter-apk/app-release.apk`.

---

## Pourquoi L'Établi ?

**L'établi** est le meuble de l'artisan — celui sur lequel on pose les objets, on les examine, on les prépare, on les répare. C'est exactement ce que fait cette application : elle vous donne un plan de travail clair pour gérer vos achats et reventes, du premier centime investi au dernier euro gagné.

---

## Licence

MIT — © Paul Carouge, 2026
