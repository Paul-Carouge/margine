# Margine — Design System

> **App:** Margine — Vinted buy/resell margin tracker  
> **Target:** Android, Flutter (Material 3)  
> **User:** Paul Carouge, 26, Arras  
> **Design principle:** *BOLD. UNIQUE. NOT CLASSIC.*

---

## 1. Design Philosophy

Margine is not another finance app. It's a **bold, confident tool** for people who treat reselling as a craft. The visual identity lives in the tension between:

- **The court** (structure, rules, precision — the spreadsheet-like data)  
- **The ball** (energy, movement, opportunity — the thrill of a good flip)

Every design choice — the sharp geometry, the electric green, the tactile warmth of the surfaces — reinforces this duality. The app feels **premium without being cold**, **bold without being loud**, **unique without being gimmicky**.

---

## 2. Color Palette

### 2.1 Core Colors

| Token | Light Mode | Dark Mode | Usage |
|-------|-----------|-----------|-------|
| **Primary** | `#557000` | `#C5F02E` | Buttons, active states, links, primary text highlights |
| **Surface** | `#F5F0EB` | `#1C1C1E` | App background, scaffold |
| **Surface Container** | `#FCFAF7` | `#262626` | Cards, sheets, elevated surfaces |
| **On Surface (high)** | `#1C1C1E` | `#F5F0EB` | Primary body text |
| **On Surface (medium)** | `#5A5A5E` | `#B0ACA8` | Secondary body text, labels |
| **On Surface (disabled)** | `#9A9692` | `#606060` | Disabled states, placeholders |
| **Outline** | `#D4CFCA` | `#3A3A3E` | Borders, dividers |
| **Outline (subtle)** | `#E5E0DB` | `#323236` | Subtle separators |

### 2.2 Brand Green (Tennis Green)

The brand is built around a **dual-nature green** — one shade for light, one for dark. This is intentional: the green transforms between modes just as an item transforms from "bought" to "sold."

| Token | Hex | WCAG AA | Role |
|-------|-----|---------|------|
| **Tennis Green (brand)** | `#C5F02E` | 12.86:1 on dark ✅ | Logo, badges, dark mode primary, decorative accents, profit badges |
| **Tennis Green (functional)** | `#557000` | 5.01:1 on light ✅ | Light mode buttons, active states, links |
| **Tennis Green (tint)** | `#EEF9D0` | — | Light mode container backgrounds, chip fills |
| **Tennis Green (shade)** | `#2A3A00` | — | Dark mode container backgrounds, chip fills |

**Why two greens?** Pure tennis-ball green (`#C5F02E`) is visually electrifying but fails contrast on light backgrounds. Rather than compromise with a washed-out version, we use a **deep, saturated forest tennis green** (`#557000`) on light surfaces — it reads as a confident, premium dark green while keeping the yellow-green DNA. On dark surfaces, the full neon tennis green explodes with energy. The mode switch **is the brand gesture**.

### 2.3 Accent Colors

| Token | Light Mode | Dark Mode | Usage |
|-------|-----------|-----------|-------|
| **Amber (profit, warm)** | `#8C5E0A` | `#D4941A` | Profit indicators, positive ROI, warm accents, icons |
| **Plum (chart, depth)** | `#6B3FA0` | `#A882D4` | Chart series, secondary data, alternative accent |
| **Success** | `#2E7D32` | `#4CAF50` | Sold status, positive changes, confirmations |
| **Error** | `#C62828` | `#EF5350` | Loss indicators, error states, deletions |
| **Info** | `#1565C0` | `#42A5F5` | Info banners, tips, neutral data |

> **Amber is the primary accent** — it sits opposite green on the color wheel (yellow-green vs. amber), creating a natural complementary pair. Use amber for:
> - Net profit amounts (positive)  
> - Warm decorative accents on cards  
> - "Hot item" indicators  

### 2.4 Status Colors (Item Lifecycle)

Each stage in the buy/resell pipeline has a dedicated color:

| Status | Light Mode | Dark Mode | Meaning |
|--------|-----------|-----------|---------|
| **Bought** | `#1565C0` (blue) | `#42A5F5` (light blue) | Acquired, awaiting action |
| **Listed** | `#E65100` (orange) | `#FF8A65` (coral) | Active, in the market |
| **Sold** | `#2E7D32` (green) | `#66BB6A` (light green) | Completed, profit locked |

These three colors form a **traffic-light-like progression** (blue → orange → green) that gives instant visual feedback on the item's journey.

### 2.5 Data Visualization Palette

For charts, graphs, and statistics:

```
Chart sequence: #C5F02E → #D4941A → #6B3FA0 → #42A5F5 → #EF5350
                (tennis)  (amber)   (plum)    (blue)    (red)
```

Always start with Tennis Green as the primary data series.

---

## 3. Typography

### 3.1 Font Stack

| Role | Typeface | Available on | Weights |
|------|----------|-------------|---------|
| **Display / Headings** | **Unbounded** | Google Fonts | 600 (Semibold), 700 (Bold), 800 (ExtraBold) |
| **Body / UI** | **Inter** | Google Fonts | 400 (Regular), 500 (Medium), 600 (Semibold) |
| **Monospace / Numbers** | **JetBrains Mono** | Google Fonts | 400 (Regular), 500 (Medium), 700 (Bold) |

### 3.2 Why These Fonts

**Unbounded** (headings) — A geometric, slightly playful variable sans-serif. Its circular terminals and wide proportions feel distinctly **not Helvetica/not Roboto**. It has personality without sacrificing readability. The capitalized "MARGINE" in Unbounded Bold is a wordmark on its own.

**Inter** (body) — Clean, highly legible at small sizes, exceptional hinting for mobile screens. Its number glyphs are excellent for financial data. Paired with Unbounded, Inter grounds the chaotic energy of the heading font.

**JetBrains Mono** (numbers/statistics) — Used exclusively for:
- Price displays (`€45.00`)
- ROI percentages (`+32.4%`)
- Profit amounts (`+€18.50`)
- Tabular data columns

Ligatures are disabled. Tabular figures ensure perfect alignment in columns.

### 3.3 Type Scale

```
                  Mobile          Tablet
Display L:        36/44px         48/56px    Unbounded Bold
Display M:        30/38px         40/48px    Unbounded Bold
Display S:        24/32px         32/40px    Unbounded Semibold

Heading L:        22/28px         28/36px    Unbounded Semibold
Heading M:        20/26px         24/32px    Unbounded Semibold
Heading S:        18/24px         20/28px    Unbounded Semibold

Title L:          22/28px         22/28px    Inter Semibold
Title M:          16/24px         16/24px    Inter Semibold
Title S:          14/20px         14/20px    Inter Semibold

Body L:           16/24px         16/24px    Inter Regular
Body M:           14/20px         14/20px    Inter Regular
Body S:           12/16px         12/16px    Inter Regular

Label L:          14/20px         14/20px    Inter Medium
Label M:          12/16px         12/16px    Inter Medium
Label S:          11/16px         11/16px    Inter Medium

Mono L (prices):  18/24px         18/24px    JetBrains Mono Medium
Mono M (ROI):     16/22px         16/22px    JetBrains Mono Medium
Mono S (stats):   13/18px         13/18px    JetBrains Mono Regular
```

### 3.4 Letter Spacing

| Context | Tracking |
|---------|----------|
| Display sizes (≥30px) | -0.5px (tight, impactful) |
| Headings (18–28px) | 0px (normal) |
| Body text | 0px (normal) |
| Labels / Chips | +0.5px (slightly open, readable) |
| Monospace numbers | 0px (zero-width, aligned) |
| **Wordmark "MARGINE"** | **+3px** (dramatically wide, signature look) |

---

## 4. Logo Concept: "The Rising M"

### 4.1 Concept

The logo is an **asymmetrical "M"** formed by two vertical strokes of unequal height — the left leg (buy/purchase) sits lower, the right leg (sell/revenue) rises higher. The **gap between them is the margin**.

```
    ╲    ╱
     ╲  ╱
      ╲╱
      /\       ← right leg rises above left
     /  \
    /    \
   /______\
   ↑       ↑
  buy     sell
  (low)   (high) = PROFIT
```

This single mark communicates:
- **The "M"** of Margine
- **The rising trajectory** of a profitable flip
- **The margin concept** — the height difference IS the profit
- **The tennis ball** — the rounded, angled strokes suggest ball trajectory

### 4.2 Logo Variants

| Variant | Usage | Color |
|---------|-------|-------|
| **Full wordmark** | Splash screen, onboarding, empty states | Tennis Green `#C5F02E` |
| **Icon mark (standalone)** | App icon, favicon, nav bar | Tennis Green `#C5F02E` on `#1C1C1E` |
| **Monochrome** | Watermarks, light-branded contexts | `#557000` on light / `#C5F02E` on dark |
| **Small (24dp)** | Notification badges, settings | Simplified 2-stroke M |

### 4.3 Typography Below Logo

The wordmark uses **Unbounded ExtraBold**, uppercase, with **+3px letter-spacing**:

```
M A R G I N E
```

The wide tracking creates a **premium, fashion-brand feel** — intentional for the Vinted audience.

### 4.4 App Icon

The app icon is the "Rising M" mark in **Tennis Green `#C5F02E`** on a **deep off-black `#1C1C1E`** rounded-square background (36dp corner radius). No text. The green pops aggressively against the dark field.

---

## 5. Component Styling

### 5.1 General Shape System

All components follow a **generous, rounded** shape language:

| Component | Border Radius |
|-----------|---------------|
| Cards | 16dp (large), 12dp (small) |
| Buttons | 14dp (pill-like) |
| Chips | 20dp (full pill) |
| Bottom sheet | 20dp top corners |
| Text fields | 12dp |
| Dialogs | 20dp |
| FAB | 16dp (squircle) |

Why 16dp? It's **unmistakably not Material default** (4dp/8dp). The large radii signal premium, intentional design.

### 5.2 Elevation & Shadows

Material 3 elevation with custom tinted shadows:

| Elevation | Light Mode Shadow | Dark Mode Shadow | Usage |
|-----------|-------------------|------------------|-------|
| 0 | None | None | Surface containers |
| 1 | `#1C1C1E @ 4%`, y:1, blur:3 | `#000000 @ 12%`, y:1, blur:3 | Subtle card elevation |
| 2 | `#1C1C1E @ 6%`, y:2, blur:6 | `#000000 @ 16%`, y:2, blur:6 | Raised cards, FAB |
| 3 | `#1C1C1E @ 8%`, y:4, blur:8 | `#000000 @ 20%`, y:4, blur:8 | Modal sheets, dialogs |

In dark mode, shadow tint is **green-tinged** (`#0A1A00 @ 30%`) on primary surfaces — a subtle brand echo.

### 5.3 Buttons

| Type | Light Mode | Dark Mode | States |
|------|-----------|-----------|--------|
| **Filled (primary)** | Bg: `#557000`, Text: `#FFFFFF` | Bg: `#C5F02E`, Text: `#1C1C1E` | Hover: +10% brightness, Press: +20% brightness |
| **Filled (accent)** | Bg: `#8C5E0A`, Text: `#FFFFFF` | Bg: `#D4941A`, Text: `#1C1C1E` | Same hover/press |
| **Tonal** | Bg: `#EEF9D0`, Text: `#476300` | Bg: `#2A3A00`, Text: `#C5F02E` | Warm green tint |
| **Outline** | Border: `#557000`, Text: `#557000` | Border: `#C5F02E`, Text: `#C5F02E` | 2dp border |
| **Text (ghost)** | Text: `#557000` | Text: `#C5F02E` | No background, minimal |

Button height: 48dp (standard), 40dp (small), 56dp (large).  
Padding: Horizontal 24dp, vertical follows height.  
Font: Inter Semibold, 14px (Label L), ALL CAPS never used.

### 5.4 Cards

The primary content container. Every item in the feed is a card.

```
┌────────────────────────────────╮
│  🧥 Levi's 501 Jeans    ● Sold │  ← Status badge (top-right)
│  Bought: €25.00                │
│  Listed: €65.00                │
│  Sold:   €58.00                │
│  ─────────────────────────     │  ← Subtle divider
│  Costs:  €6.50  Revenue: €58  │
│  ═════════════════════════     │  ← Bold profit section
│  **Profit: +€26.50**   ROI │
│  **+42.3%**                   │  ← Tennis green text
│  [View Details  →]            │
└────────────────────────────────╯
```

- Background: `#FCFAF7` (light) / `#262626` (dark)
- Corner radius: 16dp
- Inner padding: 16dp
- Bottom "profit" section has a **slightly tinted background** (0.5dp above card color)
- Tap target: full card

### 5.5 Status Chips

| State | Light Chip | Dark Chip | Icon |
|-------|-----------|-----------|------|
| **Bought** | Bg: `#E3F2FD`, Text: `#1565C0` | Bg: `#1A3A5C`, Text: `#42A5F5` | `⬇` or shopping bag |
| **Listed** | Bg: `#FFF3E0`, Text: `#E65100` | Bg: `#3A1A00`, Text: `#FF8A65` | `⬆` or tag |
| **Sold** | Bg: `#E8F5E9`, Text: `#2E7D32` | Bg: `#1A3A1A`, Text: `#66BB6A` | `✓` or dollar |

Shape: Full pill (20dp radius).  
Padding: Horizontal 12dp, vertical 4dp.  
Font: Inter Medium, 12px.  
Leading icon: 14dp, same color as text.

### 5.6 Bottom Navigation

Minimal, icon-only with labels:

- **Dashboard** (home icon) — Overview, total profit, stats
- **Items** (box/package icon) — All items list  
- **Add** (FAB + icon in center) — New item entry  
- **Analytics** (chart icon) — Charts, trends, CSV export  
- **Settings** (gear icon) — Preferences, about

Active indicator: Tennis green underline + icon fill.  
Inactive: `#5A5A5E` (light) / `#606060` (dark) outline icons.  
Background: Matches surface color — **no top border**, uses subtle elevation shadow.

### 5.7 Data Display (Prices, Stats)

All monetary values use JetBrains Mono Medium:

| Element | Size | Color |
|---------|------|-------|
| Purchase price | Body M | On Surface (medium) |
| Sale price | Title M | On Surface (high) |
| **Profit** | **Title L** | **Tennis Green** if positive, **Error** if negative |
| ROI badge | Label L | Tennis Green bg (`#EEF9D0` / `#2A3A00`) with `#557000` / `#C5F02E` text |

Profit is always **bold and prominent** — it's the hero number on every card.

### 5.8 Empty States

When the user has no items:

```
    ╲    ╱
     ╲  ╱      ← Logo mark (large, 80dp)
      ╲╱
      
   **No items yet**
   
   Start tracking your Vinted margins.
   Add your first purchase to see your profit.
   
   [  + Add First Item  ]  ← Filled button
```

Illustration: A subtle, minimal line-art of a rising arrow using Tennis Green (`#557000` light / `#C5F02E` dark).

---

## 6. Light & Dark Mode

### 6.1 Light Mode — "Warm Court"

```
Surface:  #F5F0EB  ← warm ivory, like sunlight on clay
Primary:  #557000  ← deep forest tennis green
Text:     #1C1C1E  ← charcoal, not pure black
Accent:   #8C5E0A  ← dark amber
```

The light mode evokes a **sunlit tennis court** — warm, grounded, natural. The off-white is never clinical; it has a slight ochre tint that makes it feel lived-in.

### 6.2 Dark Mode — "Night Match"

```
Surface:  #1C1C1E  ← off-black with a whisper of green
Primary:  #C5F02E  ← explosive tennis ball green
Text:     #F5F0EB  ← warm off-white, not pure white
Accent:   #D4941A  ← glowing amber
```

The dark mode is **not a typical dark theme**. The off-black `#1C1C1E` has a barely perceptible green undertone (`hsl(140, 2%, 11%)`), and the neon tennis green creates an **electric, club-like atmosphere**. It's bold, nocturnal, premium.

### 6.3 Mode Toggle

A manual toggle in Settings (not following system). The mode switch should be **celebrated** — a subtle animation where the cards "turn over" from warm clay to cool dark, and the green shifts from deep to neon.

---

## 7. Motion & Animation

### 7.1 Duration & Easing

| Movement | Duration | Easing | Context |
|----------|----------|--------|---------|
| Micro-interactions | 150ms | Fast Out, Linear In | Hover, press, chip toggle |
| Transitions | 300ms | Standard | Page transitions, mode switch |
| Emphasis | 500ms | Emphasized | Hero animations, logo reveal |

### 7.2 Characteristic Motions

- **Card swipe** for status progression: Swipe right = "Mark as Listed", swipe right again = "Mark as Sold". A green glow follows the finger.
- **Profit counter**: When a card appears, the profit number "counts up" from 0 to its value (300ms, eased).
- **Mode switch**: The entire UI slowly rotates its hue over 500ms — surfaces warm up (going to light) or cool down (going to dark), and the green jumps between deep and bright.

---

## 8. Illustration & Iconography

### 8.1 Icon Style

- **Sharp, outline-only icons** — 2dp stroke, rounded caps, rounded joins
- No filled icons except in active navigation
- Use **Material Symbols** (outlined, custom weight 400)
- Icon set: `mdi` or matching Material outlines

### 8.2 Illustration Style

When illustrations are needed (onboarding, empty states, celebrations):

- **Minimal, geometric line art**
- 2dp strokes in Tennis Green (`#557000` or `#C5F02E` depending on mode)
- Single accent color (Tennis Green + an amber dot/highlight)
- Abstract representations of: items in boxes, rising arrows, tennis balls, tag/price symbols

No photorealism. No gradients. No flat fills.

---

## 9. Dashboard Layout (Reference)

```
┌────────────────────────────────┐
│  M A R G I N E            ⚙️   │  ← App bar: wordmark + settings
├────────────────────────────────┤
│  ┌──────────────┬──────────┐  │
│  │ **Total Profit** │ **ROI** │  │  ← KPI cards
│  │ **+€845.00**    │ **+38%** │  │
│  └──────────────┴──────────┘  │
│  ┌──────────────────────────┐  │
│  │  Items: 23 │ Sold: 18   │  │  ← Stats row
│  │  Active: 5 │ Pending: 0 │  │
│  └──────────────────────────┘  │
│                                │
│  Recent Items:                 │
│  ┌─────────────────────────┐   │
│  │ 🧥 Levi's 501    ● Sold │   │  ← Item card (repeated)
│  │ +€26.50  (+42.3%)       │   │
│  └─────────────────────────┘   │
│  ┌─────────────────────────┐   │
│  │ 👟 Nike Air Max  ● Listed│   │
│  │ +€12.00  (+28.1%)       │   │
│  └─────────────────────────┘   │
│  ┌─────────────────────────┐   │
│  │ 📱 iPhone Case  ● Bought│   │
│  │ — (not yet listed)      │   │
│  └─────────────────────────┘   │
├────────────────────────────────┤
│  📊 ▫️ 📦 ▫️ ＋  ▫️ 📈 ▫️ ⚙️   │  ← Bottom nav
└────────────────────────────────┘
```

---

## 10. Design Principles (Summary)

| # | Principle | What It Means |
|---|-----------|---------------|
| 1 | **The margin IS the hero** | Profit figures are always the biggest, boldest, greenest thing on screen |
| 2 | **One green, two lives** | The same tennis DNA manifests differently in light and dark — embrace the transformation |
| 3 | **Generous air** | Large padding, large radii, large type. Nothing cramped. Breathe. |
| 4 | **Data is decoration** | Numbers aren't just content — they're visual elements. Use typographic hierarchy to make stats beautiful. |
| 5 | **No flat neutrals** | Every "gray" has a subtle warmth or coolness. Nothing is `#808080`. Nothing is `#FFFFFF`. |
| 6 | **Gestures over menus** | Swipe to progress. Tap to expand. Minimize dialogs. |

---

## 11. Implementation Notes (Flutter / Material 3)

### 11.1 Theme Configuration

```dart
// Core color scheme (Material 3)
MaterialColor tennisGreen = MaterialColor(0xFF557000, {
  50: Color(0xFFEEF9D0),
  100: Color(0xFFD4ED9E),
  200: Color(0xFFB8E069),
  300: Color(0xFF9AD32E),
  400: Color(0xFF7B9E0A),
  500: Color(0xFF557000),
  600: Color(0xFF476300),
  700: Color(0xFF3A5400),
  800: Color(0xFF2E4500),
  900: Color(0xFF1C2B00),
});
```

### 11.2 Google Fonts

```yaml
# pubspec.yaml
dependencies:
  google_fonts: ^6.1.0
```

```dart
// Usage
Text(
  'MARGINE',
  style: GoogleFonts.unbounded(
    fontSize: 36,
    fontWeight: FontWeight.w800,
    letterSpacing: 3.0,
    color: tennisGreen,
  ),
);

Text(
  '€45.00',
  style: GoogleFonts.jetBrainsMono(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: onSurfaceHigh,
  ),
);

// Body default
Text(
  'Purchase price',
  style: GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: onSurfaceMedium,
  ),
);
```

### 11.3 Shape Scheme

```dart
final shapeScheme = ShapeScheme(
  small: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  medium: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  large: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
);
```

### 11.4 Key Packages

- `google_fonts` — Typefaces
- `material_color_utilities` (bundled with M3) — Tone-based surface colors
- `fl_chart` — Charts (style per data viz palette)
- `animations` — Page transitions

---

*Designed for Paul Carouge, Arras. June 2026.*
*"BOLD. UNIQUE. NOT CLASSIC."*
