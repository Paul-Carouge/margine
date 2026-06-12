# Direction Artistique — L'Établi v3 « Forge »

> **Document de design · Juin 2026 · Orion Design Team — Apex**
>
> Refonte BOLD de L'Établi. L'app passe du « Safran & Ardoise » à une identité **Premium Workshop** — l'atelier de l'artisan moderne. Dark mode first. Pas de compromis.

---

## 0. Concept : « Forge »

L'Établi n'est pas une marketplace. C'est un **atelier**. L'utilisateur est un artisan qui achète la matière brute (AliExpress), la travaille (stock, préparation), puis la vend (Vinted). Chaque article suit un cycle : matière première → produit → vente.

La nouvelle direction **Forge** incarne cette transformation :

- **Le feu** — la chaleur maîtrisée, l'énergie de l'achat et de l'investissement
- **L'acier** — la précision froide, l'outil, le calcul de marge
- **Le graphite** — l'établi lui-même, la surface de travail, sombre et mate

Visuellement : un atelier moderne, pas une forge médiévale. Des contrastes nets. Du caractère. Zero décoration inutile.

---

## 1. Palette — 3 couleurs + variantes

### 1.1 Les trois piliers

| Token | Hex | Rôle |
|-------|-----|------|
| **Crimson** | `#C0392B` | Primary — le cœur de la forge. Actions principales, sélections, accents UI majeurs. |
| **Precision Teal** | `#14B8A6` | Accent — l'outil de précision. Profit, statut « vendu », succès, liens, jauges. |
| **Warm Graphite** | `#15151C` | Background — l'établi. Fond principal dark mode. Pas de noir pur : un gris profond aux sous-tons chauds. |

### 1.2 Variantes complètes

```
PALETTE DARK (mode principal)
═══════════════════════════════════════════════════════════════

  Crimson (Primary)
  ─────────────────
  Crimson               #C0392B    • Boutons primaires, FAB, sélection active
  Crimson Bright        #D44646    • Hover / pressed sur dark bg
  Crimson Container     #C0392B26  • Chips sélectionnés, containers teintés (15% opacity)
  Crimson Surface       #C0392B12  • Surfaces subtilement teintées (7% opacity)

  Precision Teal (Accent)
  ─────────────────
  Teal                  #14B8A6    • Profit, succès, statut « vendu »
  Teal Muted            #0D9488    • Icônes secondaires, jauges remplies
  Teal Container        #14B8A61A  • Badges succès en arrière-plan (10% opacity)

  Warm Graphite (Backgrounds)
  ─────────────────
  Bg                    #15151C    • Fond d'écran principal — l'établi
  Surface               #1E1E28    • Surfaces surélevées, cartes en mode dark
  Surface Elevated      #282836    • Surfaces de plus haute élévation, hover cards
  Surface Overlay       #2A2A35    • Overlay des bottom sheets

  Text & Outlines
  ─────────────────
  Text Primary          #F0EDE5    • Texte principal — blanc chaud, pas stérile
  Text Secondary        #8A8A95    • Texte secondaire, labels
  Text Disabled         #5A5A65    • Texte désactivé, placeholders
  Outline               #2E2E3A    • Bordures, séparateurs
  Outline Strong        #3E3E4C    • Bordures accentuées, drag handles
  Outline Subtle        #252530    • Séparateurs très fins, filets de carte

  Semantic
  ─────────────────
  Error                 #D94A3D    • Erreurs, suppression, perte
  Error Container       #D94A3D1A  • Fond d'erreur (10% opacity)
  Warning               #CA8A04    • Avertissements (rare)
```

```
PALETTE LIGHT (mode secondaire — l'atelier éclairé)
═══════════════════════════════════════════════════════════════

  Bg                    #F8F6F2    • Fond — blanc cassé chaud, papier kraft clair
  Surface               #FFFFFF    • Cartes et surfaces surélevées
  Surface Elevated      #F0EDE5    • Surfaces de plus haute élévation
  Text Primary          #1A1A22    • Texte principal
  Text Secondary        #6B6B78    • Texte secondaire
  Outline               #D6D0C8    • Bordures

  Crimson               #B3302A    • Primary ajusté pour fond clair (meilleur contraste)
  Teal                  #0D9488    • Accent ajusté pour fond clair
```

### 1.3 Règles d'usage

1. **Crimson est l'unique couleur d'action.** Tout bouton primaire, tout toggle actif, toute sélection. Une seule couleur pour guider l'œil — pas de dispersion.
2. **Teal est réservé au positif.** Profit, vendu, succès. Jamais pour une action neutre (modifier, paramètres).
3. **Le fond n'est jamais noir pur.** #15151C a des sous-tons chauds qui évitent l'effet « caverne » ou « terminal ».
4. **Pas de dégradés décoratifs.** Les seuls gradients autorisés sont fonctionnels (overlay de carte photo pour lisibilité).
5. **Les statuts articles utilisent Crimson et Teal uniquement :**
   - `bought` (Stock) → Texte secondaire sur Outline Container
   - `listed` (En ligne) → Crimson Container, texte Crimson
   - `sold` (Vendu) → Teal Container, texte Teal

---

## 2. Typographie — DM Serif Display + Outfit

### 2.1 Choix

| Rôle | Police | Justification |
|------|--------|---------------|
| **Display** | **DM Serif Display** | Serif moderne, massif, taillé dans la masse. Évoque l'enseigne d'un maître-artisan. Excellente lisibilité même en petit. Contraste fort avec l'environnement dark. |
| **Body** | **Outfit** | Sans-serif géométrique avec du caractère. Pas du Inter/Roboto générique. Légèrement large, très lisible sur fond sombre. Excellentes weight variables (300–600). |

Les deux sont disponibles sur Google Fonts. Aucune licence à gérer. Aucune police système.

### 2.2 Échelle typographique

```
DISPLAY (DM Serif Display)
─────────────────────────────────────────────────────────
  displayLarge     40px  Weight 700  Letter-spacing -0.02  • Hero numbers (profit, ROI)
  displayMedium    32px  Weight 700  Letter-spacing -0.01  • Grands titres analytics
  displaySmall     26px  Weight 600  Letter-spacing -0.01  • Sous-titres hero

HEADLINE (DM Serif Display)
─────────────────────────────────────────────────────────
  headlineLarge    22px  Weight 600  • Titre de page, nom app
  headlineMedium   20px  Weight 600  • Titres de section, noms produit dans bottom sheet
  headlineSmall    17px  Weight 500  • Sous-titres

BODY (Outfit)
─────────────────────────────────────────────────────────
  titleLarge       18px  Weight 600  • Stats cockpit (valeurs)
  titleMedium      15px  Weight 600  • Labels de navigation, filtres actifs
  titleSmall       13px  Weight 600  • Chips, badges

  bodyLarge        16px  Weight 400  • Corps de texte long
  bodyMedium       14px  Weight 400  • Texte standard
  bodySmall        12px  Weight 400  • Texte secondaire, dates, légendes

LABEL (Outfit)
─────────────────────────────────────────────────────────
  labelLarge       14px  Weight 500  Letter-spacing 0.02  • Boutons, onglets
  labelMedium      12px  Weight 500  Letter-spacing 0.02  • Labels de carte
  labelSmall       11px  Weight 500  Letter-spacing 0.02  • Badges, chips petits
```

### 2.3 Règles typographiques

1. **DM Serif Display est utilisé exclusivement pour les titres et les chiffres hero.** Pas dans les composants UI (boutons, chips, labels). Le contraste entre le display serif massif et le body géométrique crée la signature visuelle.
2. **Pas de tracking négatif excessif.** -0.02 max sur les grands display. Le reste à 0 ou +0.02 pour les labels.
3. **Hauteur de ligne par défaut** : 1.3 pour display, 1.5 pour body.
4. **Pas de ALL CAPS sauf pour les badges de statut ultra-compacts** (rare).

---

## 3. Border Radius System

Système cohérent appliqué à tous les composants :

| Composant | Radius | Note |
|-----------|--------|------|
| Card (produit / stats) | `20px` | RoundedRectangleBorder |
| Button (elevated, filled) | `14px` | Cohérent avec l'existant |
| Input (TextField) | `12px` | Suffisamment rond sans être pill |
| Chip / Filter pill | `20px` | Pleinement arrondi — pill shape |
| Bottom sheet | `24px` | Top-left + top-right seulement |
| FAB | `18px` | Rounded rectangle, pas circulaire |
| Dialog / Alert | `20px` | Cohérent avec les cartes |
| SnackBar | `16px` | Flottant, légèrement arrondi |
| Image dans bottom sheet | `16px` | ClipRRect |

---

## 4. Layout — Nouvelle architecture des écrans

### 4.1 Home Screen — « L'Atelier »

L'écran d'accueil est entièrement repensé. Le CustomScrollView actuel est conservé pour la performance, mais chaque section gagne en respiration.

```
┌─────────────────────────────────┐
│  L'Établi              🔍 ⚙️    │  ← Header : titre en DM Serif Display
│                                 │     icônes sur fond Outline Subtle
│  ── ligne séparatrice subtile ──│     (comme le bord de l'établi)
│                                 │
│  ┌──────┐ ┌──────┐ ┌──────┐    │
│  │ DÉP. │ │ GAGNÉ│ │ MARGE│    │  ← Stats cockpit : 3 cartes
│  │ 450€ │ │ 680€ │ │+230€ │    │     alignées horizontalement
│  └──────┘ └──────┘ └──────┘    │     scroll horizontal si nécessaire
│  ┌──────┐ ┌──────┐             │
│  │ STOCK│ │ EN LG│             │     chaque carte : fond Surface,
│  │  12  │ │   5  │             │     radius 20px, icône + valeur + label
│  └──────┘ └──────┘             │
│                                 │
│  [Tout] [Stock] [En ligne] [∨] │  ← Filter pills : pill shape 20px
│                                 │     actif = fond Crimson Container
│                                 │
│  ┌───────────────────────────┐  │
│  │░░░░░░░░░░░░░░░░░░░░░░░░░░│  │
│  │░░░  PHOTO PRODUIT  ░░░░░░│  │  ← Product card : 220px height
│  │░░░░░░░░░░░░░░░░░░░░░░░░░░│  │     photo en fond + overlay gradient
│  │░░░░░░░░░░░░░░░░░░░░░░░░░░│  │     Nom en DM Serif Display
│  │  [Stock]  Nike Dunk Low  │  │     badge statut en haut à droite
│  │  Acheté 85€ · 03/06      │  │     marge affichée si vendu
│  └───────────────────────────┘  │
│                                 │
│  ┌───────────────────────────┐  │
│  │░░░░░░░░░░░░░░░░░░░░░░░░░░│  │  ← Espacement inter-cartes : 16px
│  │░░░       PHOTO      ░░░░░░│  │     (au lieu de 12px actuellement)
│  │░░░░░░░░░░░░░░░░░░░░░░░░░░│  │
│  │  [Vendu]  Carhartt WIP   │  │
│  │  +45€                     │  │
│  └───────────────────────────┘  │
│                                 │
│  ┌───────────────────────────┐  │
│  │░░░░░░░░░░░░░░░░░░░░░░░░░░│  │
│  │░░░       PHOTO      ░░░░░░│  │
│  │░░░░░░░░░░░░░░░░░░░░░░░░░░│  │
│  │  [En ligne]  Stone Island │  │
│  │  Acheté 120€ · 28/05      │  │
│  └───────────────────────────┘  │
│                                 │
│         ┌───────────────────┐   │
│         │  +  Nouvel achat  │   │  ← FAB : full-width en bas
│         └───────────────────┘   │     fond Crimson, label Outfit 600
└─────────────────────────────────┘
```

**Changements clés vs. l'existant :**

- Stats cockpit : fini le conteneur 2×2 fade. Trois cartes distinctes par ligne (2 lignes max), chaque carte ayant son propre fond Surface (#1E1E28) avec une icône subtile en Crimson ou Teal.
- Les filtres sont des pills ronds (20px), pas des chips carrés.
- Espacement inter-cartes : 16px au lieu de 12px. Les cartes respirent.
- Le FAB reste full-width en bas — c'est l'action principale.
- La ligne sous le header crée une ancre visuelle (comme le bord avant d'un établi).

### 4.2 Analytics Screen — « LaComptabilité »

L'écran analytics conserve sa structure mais adopte la nouvelle palette :

- **Hero number** : le résultat net en DM Serif Display 40px, en Teal si positif, Crimson si négatif.
- **Cartes de stats** : 3 cartes en ligne (Ventes / En ligne / Stock) — fond Surface, radius 20px, valeur en DM Serif Display.
- **ROI card** : highlight avec une barre latérale Crimson ou Teal de 4px.
- **Graphiques** (fl_chart) : adaptés à la palette. Courbes en Teal, axes en Outline, grille en Outline Subtle.
- **Meilleures/pires marges** : cartes côte à côte avec fond Teal Container (meilleure) ou Error Container (pire).

### 4.3 Add/Edit Product Screen — « Nouvel Achat »

- **AppBar** transparente, titre en DM Serif Display.
- **Photo picker** : zone de drop en pointillés Outline, radius 16px, icon Crimson.
- **Champs** : InputDecorationTheme avec fond Surface (#1E1E28), bordure Outline, focus Crimson.
- **Bouton Enregistrer** : fond Crimson, full-width, radius 14px.
- Transition : slide-up custom (déjà existante, conservée).

### 4.4 Settings Screen — « Réglages »

- **Sections** : header avec une barre verticale Crimson de 3px (déjà existant, conservé).
- **Cartes** : fond Surface, radius 20px, sans elevation.
- **RadioListTile** : activeColor = Crimson, pas de ripple.
- **Slider** : activeColor = Crimson, thumb = Crimson.

---

## 5. Composants — Description visuelle précise

### 5.1 Product Card (carte produit)

```
┌──────────────────────────────────────┐
│  ┌────────────────────────────────┐  │
│  │                                │  │  ← Photo en fond (BoxFit.cover)
│  │         PHOTO                  │  │     height: 220px
│  │                                │  │
│  │  ░░░░░░░░░░░░░░░░░░░░░░░░░░░  │  │  ← Overlay gradient :
│  │  ░░  [Stock]      +45€  ░░░░░  │  │     transparent → #15151C à 70%
│  │  ░░  Nike Dunk Low       ░░░░  │  │     (pas noir, le fond Graphite)
│  │  ░░  Acheté 85€ · 03/06 ░░░░  │  │
│  └────────────────────────────────┘  │
└──────────────────────────────────────┘

Spécifications :
  • height: 220px
  • border-radius: 20px
  • fond : Surface (#1E1E28) quand pas de photo
  • overlay gradient : LinearGradient topCenter → bottomCenter
    - 0% : transparent
    - 100% : Bg (#15151C) à 70% opacity
  • box-shadow : elevation 0, ombre unique :
    - color: Bg avec 40% opacity
    - blur: 16px, offset: (0, 6)
  • pas de bordure
  • nom produit : DM Serif Display, 17px, Weight 500, blanc
  • badge statut : position top-right, 12px du bord
    - fond : selon statut (cf. règles §1.3)
    - texte : Outfit 11px Weight 600, blanc
    - radius : 8px
  • prix : Outfit 14px Weight 600, blanc 80% opacity, top-right
  • marge (si vendu) : Outfit 18px Weight 700, Teal ou Error, bottom-right
  • date achat : Outfit 12px Weight 400, blanc 70% opacity
```

**Évolution vs. existant :** Le gradient overlay utilise désormais la couleur de fond `#15151C` au lieu de noir pur. Le nom est en DM Serif Display. L'ombre est simplifiée à une seule ombre portée subtile. La hauteur passe de 200px à 220px.

### 5.2 Stats Cockpit (home)

```
┌──────────────┐  ┌──────────────┐  ┌──────────────┐
│  💰          │  │  📈          │  │  📊          │
│  450 €       │  │  680 €       │  │  +230 €      │
│  Dépensé     │  │  Gagné       │  │  Marge        │
└──────────────┘  └──────────────┘  └──────────────┘

┌──────────────┐  ┌──────────────┐
│  📦          │  │  🏷️          │
│  12          │  │  5           │
│  En stock    │  │  En ligne    │
└──────────────┘  └──────────────┘

Spécifications :
  • Chaque carte : fond Surface (#1E1E28), radius 20px, padding 16px
  • Icône : 20px, Crimson (sauf Gagné/Marge en Teal)
  • Valeur : Outfit titleLarge 18px Weight 700, Text Primary
  • Label : Outfit bodySmall 12px Weight 400, Text Secondary
  • Les cartes sont disposées en Wrap ou Row avec wrap
  • Espacement inter-cartes : 10px horizontal, 10px vertical
  • Pas de conteneur englobant (fini le fond Outline)
  • Les cartes Marge et Gagné prennent la couleur Teal pour l'icône et la valeur
```

### 5.3 Filter Pills

```
[Tout]  [Stock]  [En ligne]  [Vendu]

Spécifications :
  • Pill shape : radius 20px
  • Inactif : fond Surface (#1E1E28), texte Text Secondary
  • Actif : fond Crimson Container (#C0392B26), texte Crimson
  • Padding : horizontal 16px, vertical 10px
  • Texte : Outfit 13px Weight 600
  • Animation : 200ms AnimatedContainer sur le changement d'état
  • Scroll horizontal si overflow
```

### 5.4 Navigation & FAB

```
Bottom bar FAB :
┌─────────────────────────────────────┐
│         ┌───────────────────────┐   │
│         │  +  Nouvel achat      │   │
│         └───────────────────────┘   │
└─────────────────────────────────────┘

Spécifications FAB :
  • Position : bottomNavigationBar, full-width avec padding 20px
  • Fond : Crimson (#C0392B)
  • Texte : Outfit 15px Weight 600, blanc (#F0EDE5)
  • Icône : Icons.add_rounded 22px, blanc
  • Radius : 14px
  • Height : 54px
  • Elevation : 0
  • Haptic : HapticFeedback.mediumImpact() au tap

Header action buttons :
  • Fond : Surface (#1E1E28) à 60% opacity
  • Icône : 22px, Text Secondary
  • Radius : 14px
  • Padding : 10px
  • Pas d'élévation
```

### 5.5 Bottom Sheet (détail produit)

```
┌────────────────────────────────────┐
│         ═══════                    │  ← Drag handle : 36×4px, Outline Strong
│                                    │
│  ┌──────────────────────────────┐  │
│  │                              │  │  ← Photo : radius 16px, height 220px
│  │           PHOTO              │  │     padding horizontal 20px
│  │                              │  │
│  └──────────────────────────────┘  │
│                                    │
│  Nike Dunk Low          [Stock]   │  ← Nom en DM Serif Display headlineMedium
│                                    │     Badge statut à droite
│  +45 €                            │  ← Marge en DM Serif Display displayMedium
│                                    │     Teal si positif
│  ─────────────────────────────    │
│  Acheté le        03/06/2026     │  ← Détails en rows espacés
│  Prix d'achat     85,00 €        │
│  Provenance       Vinted         │
│  Quantité         x1             │
│  Prix de vente    130,00 €       │
│  ─────────────────────────────    │
│  Notes : "Bon état, poches..."   │
│                                    │
│  ┌──────────────────────────────┐  │
│  │  ✓  Marquer comme vendu     │  │  ← Bouton Crimson, full-width
│  └──────────────────────────────┘  │
│  ┌──────────────────────────────┐  │
│  │     Modifier                 │  │  ← Outlined, Outline border
│  └──────────────────────────────┘  │
│  ┌──────────────────────────────┐  │
│  │     Supprimer                │  │  ← TextButton, Error color
│  └──────────────────────────────┘  │
└────────────────────────────────────┘

Spécifications :
  • Sheet radius : 24px (top-left + top-right)
  • Fond : Surface (#1E1E28)
  • Drag handle : 36×4px, Outline Strong, radius 2px, margin top 10px
  • Photo : ClipRRect radius 16px, height 220px, BoxFit.cover
  • Nom produit : DM Serif Display, 20px, Weight 600
  • Marge : DM Serif Display, 32px, Weight 700, Teal ou Error
  • Détails : Row avec label Text Secondary 14px, valeur Text Primary 14px Weight 600
  • Séparateur : Divider 1px Outline Subtle
  • Boutons : espacement 8px entre chaque, padding horizontal 20px
  • Supprimer : pas de dialogue — bottom sheet de confirmation dédiée
```

### 5.6 Swipe to Mark Sold

```
État normal :           Swipe en cours :
┌──────────────────┐    ┌───────────┬──────┐
│  Photo + overlay │    │  Photo    │ ✓    │
│  Nike Dunk Low   │ ←  │  Nike..   │ VENDU│
└──────────────────┘    └───────────┴──────┘
                               ↑ fond Teal

Spécifications :
  • DismissDirection : endToStart (inchangé)
  • Background : fond Precision Teal (#14B8A6), radius 20px
  • Icône : check_circle_rounded 28px, blanc
  • Label : "Vendu", Outfit 12px Weight 600, blanc
  • Animation : la carte slide avec une courbe easeOutCubic, le fond Teal
    apparaît avec un très léger décalage (50ms) pour l'effet de découverte
  • Confirmation : bottom sheet au lieu du AlertDialog actuel
  • Haptic : heavyImpact au moment du dismiss
```

---

## 6. Animations & Micro-interactions

### 6.1 Transitions entre écrans

| Transition | Animation | Courbe | Durée |
|-----------|-----------|--------|-------|
| Home → Ajout/Modif | Slide up + fade | easeOutCubic | 350ms |
| Home → Analytics | Slide up + fade | easeOutCubic | 350ms |
| Home → Settings | Slide up + fade | easeOutCubic | 350ms |
| Retour arrière | Slide down + fade | easeInCubic | 250ms |
| Ouverture bottom sheet | Sheet monte | easeOutCubic | 300ms |
| Fermeture bottom sheet | Sheet descend | easeInCubic | 200ms |

Ces transitions sont déjà en place via GoRouter (CustomTransitionPage). On affine les durées :

```dart
// Actuel
begin: Offset(0, 0.08)  // → Offset(0, 0.12) pour plus d'amplitude
durée aller : 350ms  // → plus perceptible
durée retour : 200ms // → plus rapide, donne l'impression de « snap back »
```

### 6.2 Micro-interactions

**Carte produit — apparition**
- Les cartes apparaissent avec un **staggered fade-in + slide-up** (AnimatedList ou équivalent).
- Décalage de 50ms entre chaque carte.
- Courbe : easeOutCubic, 300ms.
- Offset de départ : (0, 20).

**Filter pill — changement d'état**
- AnimatedContainer, 200ms.
- Le fond passe de Surface → Crimson Container.
- Le texte passe de Text Secondary → Crimson.
- Pas de scale (évite l'effet « jouet »).

**FAB — pression**
- Scale 1.0 → 0.97 → 1.0, spring, 150ms.
- HapticFeedback.mediumImpact() synchronisé avec le scale minimum.

**Swipe to mark sold**
- Fond Teal : opacity 0 → 1.0, 200ms easeOut.
- Carte : translateX 0 → -screenWidth, 300ms easeOutCubic.
- Au moment du dismiss : HapticFeedback.heavyImpact().
- Confirmation : bottom sheet qui monte 100ms après le dismiss.

**Bottom sheet — ouverture**
- Sheet monte avec easeOutCubic, 300ms.
- Overlay (scrim) : opacity 0 → 0.5, 200ms easeOut.
- Drag handle apparaît avec un très léger fade-in (150ms).

**SnackBar**
- Apparition : slide up + fade, 200ms easeOutCubic.
- Disparition : fade out, 150ms easeIn.
- Position : bottom, 16px du bas, margin horizontal 16px.

### 6.3 Feedback haptique

| Action | Haptic |
|--------|--------|
| Tap sur carte produit | `lightImpact()` |
| Swipe mark sold (dismiss) | `heavyImpact()` |
| Tap FAB "Nouvel achat" | `mediumImpact()` |
| Sauvegarde article | `mediumImpact()` |
| Suppression article | `heavyImpact()` |
| Changement de filtre | pas de haptic |
| Changement de tri | `lightImpact()` |

### 6.4 Ce qu'on ne fait PAS

- Pas de parallax sur les photos.
- Pas de particules, pas de bloom, pas de fog.
- Pas de skeleton loaders complexes — un simple shimmer sur fond Surface.
- Pas d'animations de transition entre light/dark mode (le switch est instantané).
- Pas d'animations au scroll (la galerie est statique, le scroll est standard).

---

## 7. Grille d'espacement

Système cohérent sur tous les écrans :

| Token | Valeur | Usage |
|-------|--------|-------|
| `xxs` | 4px | Icône↔texte dans chips, espacement interne badge |
| `xs` | 8px | Entre filter pills, padding interne chips |
| `sm` | 12px | Inter-cartes stats, padding contenu |
| `md` | 16px | Inter-cartes produit, padding cartes |
| `lg` | 20px | Marges écran (horizontal) |
| `xl` | 24px | Sections analytics |
| `xxl` | 40px | Fin de scroll, espacement sections majeures |

---

## 8. Implémentation Flutter — Recommandations

### 8.1 Structure du thème

Le fichier `app_theme.dart` actuel (300 lignes, classe `MargineTheme`) est renommé et restructuré :

```
lib/core/theme/
  app_theme.dart          → Classe ForgeTheme (ex-MargineTheme)
  app_colors.dart         → Tokens de couleur extraits (ForgeColors)
  app_typography.dart     → Échelle typographique extraite (ForgeTypography)
```

### 8.2 Google Fonts

Ajouter au `pubspec.yaml` :
```yaml
google_fonts: ^6.2.1  # déjà présent
```

Les deux polices sont chargées via `GoogleFonts.dmSerifDisplay()` et `GoogleFonts.outfit()`.

### 8.3 Migration depuis l'actuel

1. Remplacer toutes les références à `MargineTheme` par `ForgeTheme`.
2. Remplacer `MargineTheme.profitGreen` → `ForgeColors.teal`.
3. Remplacer `MargineTheme.lossRed` → `ForgeColors.error`.
4. Remplacer `MargineTheme.statusBought` → `ForgeColors.textSecondary`.
5. Remplacer `MargineTheme.statusListed` → `ForgeColors.crimson`.
6. Remplacer `MargineTheme.statusSold` → `ForgeColors.teal`.
7. Les polices : `GoogleFonts.sora()` → `GoogleFonts.dmSerifDisplay()`, `GoogleFonts.inter()` → `GoogleFonts.outfit()`.

---

## 9. Comparaison Avant / Après

| Aspect | Avant (Safran & Ardoise) | Après (Forge) |
|--------|--------------------------|---------------|
| **Ambiance** | Chaleureuse, dorée, conventionnelle | Brute, précise, atelier moderne |
| **Primary** | Safran #D4A74D | Crimson #C0392B |
| **Accent** | Ardoise #7A8FAF + Vert #3A8A6C | Precision Teal #14B8A6 (unique) |
| **Fond** | #0D0D12 (presque noir) | #15151C (graphite chaud) |
| **Display** | Sora (sans-serif géométrique) | DM Serif Display (serif massif) |
| **Body** | Inter (générique) | Outfit (géométrique distinctif) |
| **Stats** | 2×2 dans un conteneur grisé | Cartes distinctes Surface, icônes |
| **Filtres** | Chips 12px radius | Pills 20px radius |
| **Cartes** | 200px, gradient noir | 220px, gradient Graphite |
| **Swipé** | Fond vert, AlertDialog confirm | Fond Teal, bottom sheet confirm |
| **Personnalité** | Correcte, sans aspérité | Distinctive, mémorable |

---

## 10. Validation Design

### Ce que Forge apporte :

- ✅ **Identité immédiate** — DM Serif Display + Crimson n'existent dans aucune autre app de suivi achat/revente.
- ✅ **Dark mode natif** — la palette est conçue pour le dark, le light est dérivé.
- ✅ **Hiérarchie claire** — Crimson = action, Teal = positif, Graphite = surface. L'utilisateur sait toujours où regarder.
- ✅ **Respiration** — 16px entre les cartes, 20px de marges, les stats ne sont plus compressées.
- ✅ **Cohérence** — Chaque élément a une règle. Pas d'exception. Pas de cas spécial.
- ✅ **Bold mais sobre** — Le caractère vient des choix typographiques et chromatiques, pas de décorations superflues.

### Ce que Forge n'est PAS :

- ❌ Un thème spatial / cosmique (pas de violet dominant, pas de gradients infinis).
- ❌ Un thème « dark mode OLED » (pas de fond noir pur, le graphite chaud évite la fatigue visuelle).
- ❌ Un thème mode/éphémère (DM Serif Display est intemporel, le crimson est une couleur historique).
- ❌ Un thème compliqué à implémenter (3 couleurs, 2 polices, zéro artwork custom).

---

> **Document rédigé par Apex (Orion Design Team) pour Paul Carouge.**
>
> Prochaine étape : implémentation de `ForgeTheme` dans `lib/core/theme/` en suivant cette spec au pixel près.
>
> *« Un bon outil n'a pas besoin d'être beau. Mais un grand outil l'est toujours. »*
