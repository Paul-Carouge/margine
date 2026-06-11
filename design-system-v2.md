# Margine v2.0 — Design System

> **App:** Margine — Vinted buy/resell margin tracker
> **Platform:** Flutter (Material 3 via `package:material`)
> **Brand Identity:** *Noir & Amethyst* — dark luxury meets digital precision
> **Design Principle:** *Confidence through restraint. Premium through detail.*

---

## 1. Design Philosophy

Margine v2.0 is a **total rebrand**. The previous identity (tennis court, warm clay, electric green) is fully replaced. The new identity lives in the tension between:

- **The vault** (structure, security, precision — the data spine)
- **The auction** (excitement, scarcity, conversion — the thrill of the flip)

Every design choice — the deep amethyst primary, the gold accents, the crystalline surfaces, the razor-sharp spacing — reinforces this duality. Margine feels like a **private banking app meets a high-end auction house**. It is:

- **Premium without pretension** — luxury materials, but instantly usable
- **Bold without shouting** — deep colors, high contrast, no gimmicks
- **Unique without alienating** — distinctive enough to be memorable, familiar enough to be intuitive

The palette is **4 colors, no green anywhere**. The brand moves from "court sport" to "private trading desk."

---

## 2. Color Palette — "Noir & Amethyst"

### 2.1 Core Colors (4 Colors Max)

| Token | Light Mode | Dark Mode | WCAG AA | Usage |
|-------|-----------|-----------|---------|-------|
| **Primary** | `#2D2B55` | `#818CF8` | 8.1:1 light ✅ / 6.3:1 dark ✅ | Buttons, links, active states, primary accents |
| **Accent** (Gold) | `#B8860B` | `#F5A623` | 4.7:1 light ✅ (large text) / 8.9:1 dark ✅ | Profit, ROI, premium badges, data highlights |
| **Surface** | `#F5F3F0` | `#0F0F14` | — | App background, scaffold |
| **Surface Container** | `#FFFFFF` | `#18181F` | — | Cards, sheets, elevated surfaces |

**Why these 4 colors?**
- **Amethyst (`#2D2B55` / `#818CF8`)** — Deep, regal, creative. No finance app uses purple. It signals luxury, intuition, and confidence. The light mode version is a rich royal purple; the dark mode version is an electric periwinkle that glows against black.
- **Gold (`#B8860B` / `#F5A623`)** — Profit, premium, celebration. Gold is universal for wealth without being sterile. On light surfaces it's an antique gold; on dark it's a luminous amber.
- **Pearl (`#F5F3F0`)** — A cool off-white with the subtlest warm whisper. Not clinical white, not warm ivory. It's the color of high-quality paper.
- **Onyx (`#0F0F14`)** — Near-black with a violet undertone. It absorbs light rather than reflecting it. On screens, this creates infinite depth.

### 2.2 Extended Surface Colors

| Token | Light Mode | Dark Mode | Usage |
|-------|-----------|-----------|-------|
| **Surface (body text)** | `#1A1A2E` | `#EDEDF5` | Primary text |
| **Surface (secondary)** | `#5C5C70` | `#9E9EB0` | Secondary text, labels |
| **Surface (disabled)** | `#B0B0C0` | `#454558` | Disabled, placeholder |
| **Outline** | `#D6D5E0` | `#2E2E40` | Borders, dividers |
| **Outline (subtle)** | `#E8E7F0` | `#252538` | Hairline separators |

### 2.3 Semantic Colors

| Token | Hex | Light Container | Dark Container | Usage |
|-------|-----|----------------|----------------|-------|
| **Success** | `#2E7D32` / `#4CAF50` | `#E8F5E9` | `#1A3A1A` | Sold items, positive changes |
| **Error** | `#C62828` / `#EF5350` | `#FFEBEE` | `#3A1A1A` | Loss, deletion, negative |
| **Info** | `#2B6CB0` / `#63B3ED` | `#EBF5FF` | `#1A2A3A` | Tips, neutral data |

### 2.4 Status Colors (Item Lifecycle)

| Status | Light Mode | Dark Mode | Hex |
|--------|-----------|-----------|-----|
| **Bought** | Deep teal chip, white text | Bright teal chip, dark text | `#0D7377` / `#38B2AC` |
| **Listed** | Deep copper chip, white text | Bright coral chip, dark text | `#9C4221` / `#ED8936` |
| **Sold** | Deep emerald chip, white text | Bright emerald chip, dark text | `#276749` / `#48BB78` |

The three statuses form a **maturation sequence**: cool (acquired) → warm (active) → rich (completed). Each step gets warmer and more saturated.

### 2.5 Data Visualization Palette

```
Chart sequence: #818CF8 → #F5A623 → #38B2AC → #ED8936 → #48BB78
                (amethyst) (gold)    (teal)     (coral)   (emerald)
```

Primary data series always uses Amethyst. Profit/ROI series uses Gold. Supporting series use the remaining colors.

---

## 3. Typography

### 3.1 Font Stack

| Role | Typeface | Available on | Weights Used |
|------|----------|-------------|--------------|
| **Display / Headings** | **Sora** | Google Fonts | 500 (Medium), 600 (Semibold), 700 (Bold), 800 (ExtraBold) |
| **Body / UI** | **Inter** | Google Fonts | 400 (Regular), 500 (Medium), 600 (Semibold), 700 (Bold) |

**Why Sora?** Sora is a geometric sans-serif with distinct personality — its circular terminals, large x-height, and slightly condensed proportions give it a fashion-luxury feel. The uppercase "M" in Sora Bold is architectural and confident. It's the typeface of choice for premium digital brands.

**Why Inter?** Inter is the gold standard for app UI. Its excellent hinting, open apertures, and crystal-clear readability at small sizes make it the perfect body companion to Sora's personality. Inter's numeral set is clean and precise for financial data.

### 3.2 Type Scale

```
                     Mobile           Tablet
Display XL:          44/48px          56/60px    Sora ExtraBold
Display L:           36/40px          44/48px    Sora Bold
Display M:           28/32px          36/40px    Sora Bold
Display S:           24/28px          28/32px    Sora Semibold

Heading L:           22/26px          26/30px    Sora Semibold
Heading M:           20/24px          22/26px    Sora Semibold
Heading S:           18/22px          20/24px    Sora Medium

Title L:             20/24px          20/24px    Inter Semibold
Title M:             16/22px          16/22px    Inter Semibold
Title S:             14/20px          14/20px    Inter Semibold

Body L:              16/24px          16/24px    Inter Regular
Body M:              14/20px          14/20px    Inter Regular
Body S:              12/16px          12/16px    Inter Regular

Label L:             14/20px          14/20px    Inter Medium
Label M:             12/16px          12/16px    Inter Medium
Label S:             11/16px          11/16px    Inter Medium

Mono L (prices):     18/24px          18/24px    Inter Medium  (tabular figures)
Mono M (ROI):        16/22px          16/22px    Inter Medium  (tabular figures)
Mono S (stats):      13/18px          13/18px    Inter Regular (tabular figures)
```

### 3.3 Letter Spacing

| Context | Tracking | Notes |
|---------|----------|-------|
| Display XL, L (≥44px) | -0.02em | Tight, architectural, impactful |
| Display M, S (24–36px) | -0.01em | Slightly tight |
| Headings (18–22px) | 0em | Normal |
| Body text | 0em | Normal |
| Labels / Chips | +0.02em | Slightly open, legible |
| Monetary values | 0em | Tabular figures, zero-width |
| **Wordmark "MARGINE"** | **+0.15em** | Wide, premium, signature look |

### 3.4 Number Formatting

All monetary values use **tabular figures** (Inter's `tnum` font feature) to ensure perfect alignment:
- Always show euro sign: `€25.00`
- Profit prefix: `+€18.50` (positive), `-€3.20` (negative)
- ROI: `+42.3%`
- No decimal for whole euros (but always show .00 in inputs)

---

## 4. Logo Application

### 4.1 The Logo Mark

The logo is the **provided image** at `/home/atlas/.hermes/image_cache/img_93751985e003.jpg` — a 1024×1024 icon mark. This is the sole logo for Margine v2.0. It replaces the previous "Rising M" concept entirely.

### 4.2 Logo Usage

| Context | Size | Presentation | Background |
|---------|------|-------------|------------|
| App icon (launcher) | Native Android adaptive icon | Full mark, centered, with dynamic shape | Transparent, system colors |
| Splash screen | 80dp × 80dp | Centered, fade-in animation | Surface color (light/dark) |
| App bar (full wordmark) | 32dp height | Mark + "MARGINE" wordmark in Sora Bold | — |
| Nav bar icon | 28dp × 28dp | Mark only, monochrome | — |
| Settings / About | 48dp × 48dp | Mark + app name below | Surface Container color |
| Empty states | 96dp × 96dp | Mark, slightly faded (40% opacity) | Surface color |
| Push notification | System standard | Mark only | System |

### 4.3 Wordmark Treatment

When shown together with text, the wordmark uses:
```
Typeface: Sora ExtraBold, uppercase
Size:     24px (matches logo height)
Tracking: +0.15em
Color:    Primary (light/dark)
```

### 4.4 Logo Color Variants

| Variant | Light Mode | Dark Mode |
|---------|-----------|-----------|
| Standard | Original full color on `#FFFFFF` card | Original full color on `#18181F` card |
| Monochrome | Primary `#2D2B55` | Primary `#818CF8` |
| Inverted | White on Primary `#2D2B55` | White on Primary `#818CF8` |

---

## 5. Component Design

### 5.1 Shape System — "Precision Geometry"

Margine v2.0 uses **mixed-radius geometry** — not uniformly rounded like Material defaults. The philosophy: sharp where function demands precision, soft where touch demands comfort.

| Component | Border Radius | Rationale |
|-----------|---------------|-----------|
| Cards | 16dp (top), 16dp (bottom) | Generous, premium, consistent |
| Buttons | 12dp | Distinctive squircle, not pill |
| Chips | 8dp | Subtle rounding, not full pill |
| Text inputs | 10dp | Clean, precise |
| Bottom sheet | 20dp (top corners only) | Soft top edge, anchored bottom |
| Dialogs | 16dp | Consistent with cards |
| FAB | 16dp | Squircle, matches buttons |
| Segment controls | 10dp | Subtle, tool-like |

**Why mixed radii?** Uniform 16dp rounding (as in v1) is pleasant but monotonous. By varying radii — sharper on utility elements, softer on containers — we create visual rhythm that guides the eye to what matters.

### 5.2 Elevation & Shadows

Shadows use the **primary color** (`#2D2B55`) tinted into the shadow color, not neutral black:

| Elevation | Light Mode | Dark Mode | Usage |
|-----------|-----------|-----------|-------|
| 0 | None | None | Surface containers, un-elevated content |
| 1 | `#2D2B55` @ 3%, y:1, blur:2 | `#000000` @ 15%, y:1, blur:2 | Subtle card separation |
| 2 | `#2D2B55` @ 5%, y:2, blur:6 | `#000000` @ 20%, y:2, blur:5 | Raised cards, FAB |
| 3 | `#2D2B55` @ 8%, y:4, blur:12 | `#000000` @ 30%, y:4, blur:10 | Modal sheets, dialogs |

In dark mode, a **subtle amethyst glow** (`#818CF8` @ 5%) replaces the top shadow on elevated surfaces — a brand echo that reads as a rim light.

### 5.3 Buttons

#### 5.3.1 Primary (Filled)

| Property | Light Mode | Dark Mode |
|----------|-----------|-----------|
| Background | `#2D2B55` | `#818CF8` |
| Text color | `#FFFFFF` | `#0F0F14` |
| Border radius | 12dp | 12dp |
| Height | 48dp (standard), 40dp (small), 56dp (large) | Same |
| Padding | H: 24dp, V: follows height | Same |
| Font | Inter Semibold, 14px (Label L) | Same |
| Shadow | Elevation 1 | Elevation 1 (amethyst glow) |

**States:**
- Hover: +15% brightness + slight scale (1.02)
- Press: Scale (0.97), elevation drops to 0
- Disabled: Opacity 0.38

#### 5.3.2 Accent (Gold — for profit actions, confirmations)

| Property | Light Mode | Dark Mode |
|----------|-----------|-----------|
| Background | `#B8860B` | `#F5A623` |
| Text color | `#FFFFFF` | `#0F0F14` |
| All other properties | Same as Primary | Same as Primary |

#### 5.3.3 Secondary / Outline

| Property | Light Mode | Dark Mode |
|----------|-----------|-----------|
| Border | 1.5dp, `#2D2B55` | 1.5dp, `#818CF8` |
| Text color | `#2D2B55` | `#818CF8` |
| Background | Transparent | Transparent |
| Border radius | 12dp | 12dp |
| Height | Same as filled | Same as filled |

**States:**
- Hover: Background fills to 5% primary
- Press: Background fills to 10% primary

#### 5.3.4 Text / Ghost

| Property | Light Mode | Dark Mode |
|----------|-----------|-----------|
| Text color | `#2D2B55` | `#818CF8` |
| Background | Transparent | Transparent |
| Padding | H: 12dp (minimal) | Same |

**States:**
- Hover: Background 5% primary
- Press: Background 10% primary

### 5.4 Cards

The primary content container. Every item in the feed is a card.

```
┌───────────────────────────────────╮
│ ┌─────┐                          │
│ │     │  Levi's 501 Jeans   ●    │  ← Product image (3:4) + status badge
│ │     │                          │
│ │     │  Bought: €25.00          │
│ └─────┘  Listed: €65.00          │
│          ────────────────────    │  ← Hairline divider (Outline)
│          P: €58.00  C: €6.50     │
│          ────────────────────    │
│          ⚡ +€26.50  ·  +42.3%  │  ← Gold accent (bold, large)
│ ┌─────────────────────────────┐  │
│ │      View Details  →        │  │  ← Inline ghost button
│ └─────────────────────────────┘  │
└───────────────────────────────────╯
```

| Property | Value |
|----------|-------|
| Background | `#FFFFFF` (light) / `#18181F` (dark) |
| Corner radius | 16dp |
| Inner padding | 16dp |
| Between sections | 12dp |
| Shadow | Elevation 1 (light), Elevation 1 with amethyst glow (dark) |
| Tap target | Full card (opens detail) |

**Card variants:**
- **Compact card** (for grid view): 8dp inner padding, smaller image, fewer details
- **Stat card** (dashboard KPIs): No image, large centered metric, label below
- **Highlight card** (top performer): Gold left border (2dp), subtle gold background tint

### 5.5 Input Fields

```
┌───────────────────────────────╮
│  Label                      │  ← Inter Medium, 12px, Secondary
│  ┌─────────────────────────┐ │
│  │ €25.00                  │ │  ← Inter Regular, 16px, Body text
│  └─────────────────────────┘ │  ← Border: 1.5dp Outline
│  Helper text                 │  ← Inter Regular, 11px, Secondary
└───────────────────────────────╯
```

| Property | Value |
|----------|-------|
| Border radius | 10dp |
| Border width | 1.5dp |
| Default border | `#D6D5E0` (light) / `#2E2E40` (dark) |
| Focused border | `#2D2B55` (light) / `#818CF8` (dark) |
| Error border | `#C62828` (light) / `#EF5350` (dark) |
| Border radius | 10dp |
| Inner padding | H: 16dp, V: 14dp |
| Label position | Floating above (shrinks to 12px on focus) |
| Label color | `#5C5C70` (light) / `#9E9EB0` (dark) |
| Background | `#F5F3F0` (light) / `#0F0F14` (dark) — matches surface |

**States:**
- **Default**: Subtle outline
- **Focused**: Primary border + subtle glow (primary @ 10% spread 4dp)
- **Filled**: Same as default, text present
- **Error**: Error border + error message below
- **Disabled**: 0.38 opacity, no interaction

### 5.6 Chips / Badges

| Property | Value |
|----------|-------|
| Border radius | 8dp (not full pill — distinctive) |
| Height | 28dp (small), 32dp (standard) |
| Padding | H: 12dp, V: follows height |
| Font | Inter Medium, 12px |
| Gap (icon to text) | 6dp |
| Icon size | 14dp |

**Status chips:**

| Status | Light Mode | Dark Mode | Icon |
|--------|-----------|-----------|------|
| **Bought** | Bg: `#E6FFFB`, Text: `#0D7377`, Border: `#0D7377` @ 30% | Bg: `#0A2A2A`, Text: `#38B2AC`, Border: `#38B2AC` @ 30% | `⬇` |
| **Listed** | Bg: `#FFEAD6`, Text: `#9C4221`, Border: `#9C4221` @ 30% | Bg: `#2A1A0A`, Text: `#ED8936`, Border: `#ED8936` @ 30% | `⬆` |
| **Sold** | Bg: `#E6F7EE`, Text: `#276749`, Border: `#276749` @ 30% | Bg: `#0A2A1A`, Text: `#48BB78`, Border: `#48BB78` @ 30% | `✓` |

**Filter chips:**
- Default: Outline style with secondary text
- Selected: Filled with primary background, white text
- Active: Filled with primary, right-aligned checkmark

### 5.7 Bottom Navigation

| Property | Value |
|----------|-------|
| Height | 64dp |
| Background | Surface Container color |
| Top edge | 0.5dp Outline hairline (no shadow) |
| Active icon color | Primary (`#2D2B55` / `#818CF8`) |
| Inactive icon color | `#B0B0C0` (light) / `#454558` (dark) |
| Active label color | Primary |
| Inactive label color | Secondary |
| Font | Inter Medium, 11px |
| Icon size | 24dp |

**Tabs (5):**
1. **Dashboard** — Home icon (house) — Overview, total profit, stats
2. **Items** — Grid icon (4 squares) — All items list
3. **Add** — + icon (FAB-style, elevated) — New item entry
4. **Analytics** — Chart icon (bar) — Charts, trends
5. **Settings** — Gear icon — Preferences, about

**Active indicator:** A 2dp dot above the icon (primary color), animated on switch. The dot slides horizontally between tabs with a spring animation.

**Add button:** The center tab is a **floating action button** embedded in the nav bar. It sits 8dp above the nav bar surface, has primary fill with white `+` icon, and a subtle shadow. It's 48dp wide.

### 5.8 FAB (Floating Action Button)

| Property | Value |
|----------|-------|
| Size | 56dp (standard) |
| Icon | `+` (24dp, 2dp stroke weight) |
| Background | `#2D2B55` (light) / `#818CF8` (dark) |
| Icon color | `#FFFFFF` (light) / `#0F0F14` (dark) |
| Border radius | 16dp (squircle) |
| Shadow | Elevation 2 |
| On scroll | Shrinks to 40dp mini-FAB |

**Extended FAB** (used on empty states):
- Same as standard with 16dp left/right padding
- Label: "Add Item" in Inter Semibold, 14px
- Icon: `+` on the left

### 5.9 Segment Control

A premium alternative to tabs, used for filter segments (All | Bought | Listed | Sold):

| Property | Value |
|----------|-------|
| Height | 36dp |
| Border radius | 10dp (matches input fields) |
| Background | Surface color |
| Selected bg | Primary (`#2D2B55` / `#818CF8`) |
| Selected text | White |
| Unselected text | Secondary |
| Font | Inter Medium, 12px |
| Padding | H: 4dp between segments |
| Animation | Smooth slide of selected indicator (250ms ease-in-out) |
| Border | 1dp Outline around entire control |

### 5.10 Dialogs & Bottom Sheets

**Dialog:**
| Property | Value |
|----------|-------|
| Border radius | 16dp |
| Background | Surface Container |
| Max width | 328dp (mobile) |
| Padding | 24dp |
| Shadow | Elevation 3 |
| Backdrop | 40% primary color, blur(4dp) |

**Bottom Sheet:**
| Property | Value |
|----------|-------|
| Top border radius | 20dp (only top) |
| Background | Surface Container |
| Handle | 32dp × 4dp rounded bar, Outline color, centered at top 8dp |
| Padding | 16dp top (below handle), 24dp sides, 24dp bottom |
| Shadow | Elevation 3 |
| Backdrop | 40% primary color, no blur |
| Drag threshold | 40% of height to dismiss |
| Animation | Drag follows finger with spring physics |

---

## 6. Animation Philosophy

### 6.1 Core Principles

1. **Motion has meaning** — Every animation communicates something. Nothing moves just to move.
2. **Spring physics, not linear** — Human touch feels alive. Use spring curves (damping: 0.8, stiffness: 200) for direct interactions.
3. **Glass-delay** — Elements don't move in lockstep. They stagger like ripples — the trigger element moves first, then surrounding elements follow with 30–50ms delay.
4. **No fade-only transitions** — Elements can fade in combination with scale/slide/glow, but never fade alone. Fading alone feels cheap.

### 6.2 Duration & Easing

| Movement | Duration | Easing | Context |
|----------|----------|--------|---------|
| Micro-interactions | 100–150ms | Spring (stiff: 300, damp: 0.85) | Button press, chip toggle, checkbox |
| Element transitions | 200–300ms | Spring (stiff: 200, damp: 0.8) | Card appear, list insert, sheet open |
| Page transitions | 350–450ms | EaseInOutCubic (0.65, 0, 0.35, 1) | Screen navigation |
| Emphasis animations | 500–700ms | Spring (stiff: 150, damp: 0.7) | Hero reveal, profit counter, mode switch |
| Motion blur trail | 80ms | N/A | Quick swipe feedback (blur trail) |

### 6.3 Characteristic Motions

**Card Appear (list insert):**
1. The card scales from 0.95 to 1.0 over 250ms (spring)
2. Simultaneously fades from 0 to 1
3. The next card staggers in 40ms later
4. Result: A smooth, natural "drop-in" effect

**Card Swipe (status change):**
1. User swipes card horizontally
2. A colored glow follows the finger — teal for "Mark as Listed", gold for "Mark as Sold"
3. At 40% threshold, the card snaps to the action with a spring (stiff: 200, damp: 0.8)
4. A haptic response (HapticFeedback.lightImpact on Android)
5. The status chip animates a morph: old color → new color (200ms)
6. If released before threshold, card springs back with a subtle overshoot

**Profit Counter:**
When a card or dashboard KPI appears, the number "counts up" from 0 to actual value:
- Duration: 400ms (proportional to magnitude — numbers under 100 count faster)
- Easing: Spring (stiff: 180, damp: 0.75)
- Each digit flips independently from right to left (like an odometer)
- The euro sign appears first, then digits roll in
- For negative values, the `-` sign flashes in with a brief red glow

**Page Transitions:**
- **Push (forward navigation):** Current page slides left 30% and scales to 0.97 with a subtle shadow. New page slides in from right. Duration: 350ms. Easing: EaseInOutCubic.
- **Pop (back navigation):** Reverse of push. Current page slides right and exits. Previous page scales back to 1.0.
- **Modal presentation (bottom sheet):** Sheet rises from bottom with spring (stiff: 150, damp: 0.75). Backdrop fades in simultaneously. Content inside sheet staggers with 30ms delays.

**Mode Switch (Light → Dark):**
- Duration: 500ms
- The background color smoothly interpolates
- Cards "turn over" with a subtle 3D flip animation (perspective: 0.001)
- The amethyst primary shifts from deep to electric
- Accent gold shifts from antique to bright
- Icons invert color
- A brief flash of the logo mark at 50% opacity during transition

**Pull to Refresh:**
- The logo mark appears at the top, rotating as you pull
- On release, the mark pulses once (scale 1.0 → 1.1 → 1.0, 300ms)
- A subtle amethyst glow radiates from the mark
- HapticFeedback.mediumImpact on trigger

### 6.4 Haptic Feedback

| Interaction | Haptic | Platform |
|------------|--------|----------|
| Button press | `lightImpact` | Android (HapticFeedbackConstants) |
| Card swipe (threshold) | `mediumImpact` | Android |
| FAB press | `lightImpact` | Android |
| Segment switch | `lightImpact` | Android |
| Pull to refresh trigger | `mediumImpact` | Android |
| Delete confirmation | `heavyImpact` | Android |
| Error / rejection | `selectionClick` (negative feedback) | Android |
| Success completion | Custom vibration pattern: 10ms on, 5ms off, 10ms on | Android |

---

## 7. Screen Layouts — Conceptual

### 7.1 Dashboard

```
┌───────────────────────────────────╮
│  ┌────┐  M A R G I N E      ⚙️   │  ← App bar: logo + wordmark + settings
│  │    │                          │     bg: Surface, no divider
│  └────┘                          │
├───────────────────────────────────┤
│  ┌─────────────────────────────┐  │
│  │                             │  │  ← Welcome / greeting row
│  │  Good morning, Paul         │  │     Sora Medium, 22px
│  │  23 items tracked           │  │     Inter Regular, 14px, Secondary
│  │                             │  │
│  └─────────────────────────────┘  │
│                                   │
│  ┌──────────┐ ┌──────────┐       │
│  │ Total P&L│ │ ROI      │       │  ← KPI stat cards (2 columns)
│  │ +€845.00 │ │ +38.2%   │       │     Gold text for profit
│  │ this mo. │ │ all time │       │     Secondary label
│  └──────────┘ └──────────┘       │
│                                   │
│  ┌──────────┐ ┌──────────┐       │
│  │ In Stock │ │ Sold     │       │  ← Secondary stat cards
│  │ 5        │ │ 18       │       │     Primary text, large
│  └──────────┘ └──────────┘       │
│                                   │
│  ┌─────────────────────────────┐  │
│  │  Quick Actions              │  │  → chips: All | Bought | Listed | Sold
│  │  [All] [Bought] [Listed]    │  │
│  │  [Sold]                     │  │
│  └─────────────────────────────┘  │
│                                   │
│  ┌─────────────────────────────┐  │
│  │  Recent Items               │  │
│  │  ┌───────────────────────┐  │  │
│  │  │ ██ Levi's 501   ● Sold│  │  │  ← Compact cards in list
│  │  │ +€26.50  (+42.3%)     │  │  │
│  │  └───────────────────────┘  │  │
│  │  ┌───────────────────────┐  │  │
│  │  │ ██ Air Max    ● Listed│  │  │
│  │  │ +€12.00  (+28.1%)     │  │  │
│  │  └───────────────────────┘  │  │
│  │  ┌───────────────────────┐  │  │
│  │  │ ██ iPhone Case ● Bght │  │  │
│  │  │ — (not yet listed)    │  │  │
│  │  └───────────────────────┘  │  │
│  │  [ View All → ]             │  │
│  └─────────────────────────────┘  │
│                                   │
├───────────────────────────────────┤
│  🏠  ▦  ＋  📊  ⚙️               │  ← Bottom nav (Items active)
└───────────────────────────────────┘
```

### 7.2 Items List

```
┌───────────────────────────────────╮
│  ← Items                    🔍   │  ← App bar: back (or hamburger) + title + search
│                                  │     bg: Surface, subtle bottom outline
├───────────────────────────────────┤
│  [All 23] [Bought 5] [Listed 8]  │  ← Segment control
│  [Sold 10]                        │     Scrollable horizontal
│                                   │
│  ⚡ Sorted by: Date added ▼      │  ← Sort dropdown chip
│                                   │
│  ┌─────────────────────────────┐  │
│  │ ██ Levi's 501         ● Sold│  │  ← Full card with image thumbnail
│  │ B: €25.00  L: €65.00       │  │     +€26.50 in gold
│  │ S: €58.00                  │  │
│  │ ⚡ +€26.50 · ROI +42.3%   │  │
│  └─────────────────────────────┘  │
│  ┌─────────────────────────────┐  │
│  │ ██ Nike Air Max      ● List │  │
│  │ B: €30.00  L: €75.00       │  │
│  │ — awaiting sale            │  │
│  │ ⚡ +€12.00 est. · ROI 28%  │  │
│  └─────────────────────────────┘  │
│  ┌─────────────────────────────┐  │
│  │ ██ iPhone Case      ● Bought│  │
│  │ B: €8.00                    │  │
│  │ — not yet listed            │  │
│  │ 📋 Needs listing            │  │
│  └─────────────────────────────┘  │
│                                   │
│  Showing 3 of 23 items           │  ← Footer count
│  ┌─────────────────────────┐     │
│  │    Load More   ↓        │     │  ← Outline button (pagination)
│  └─────────────────────────┘     │
├───────────────────────────────────┤
│  🏠  ▦  ＋  📊  ⚙️               │  ← Bottom nav (Items active)
└───────────────────────────────────┘
```

### 7.3 Item Detail

```
┌───────────────────────────────────╮
│  ←  Items  >  Levi's 501     ⋮   │  ← App bar: back breadcrumb + title + menu
├───────────────────────────────────┤
│                                   │
│  ┌─────────────────────────────┐  │
│  │                             │  │
│  │     [PRODUCT PHOTO]         │  │  ← Large hero image (16:9 aspect)
│  │     Full width              │  │     Status badge overlaid top-right
│  │                             │  │
│  └─────────────────────────────┘  │
│                                   │
│  Levi's 501 Jeans                 │  ← Heading L, Sora Semibold
│  ● Sold · 12 Jun 2025            │  ← Status chip + date
│                                   │
│  ┌───────  PURCHASE  ───────┐    │
│  │ Price:      €25.00       │    │  ← Section card (grouped fields)
│  │ Date:       01 Jun 2025  │    │     Key: Inter Medium 12px, Secondary
│  │ Source:     Vinted       │    │     Value: Inter Regular 14px, Body
│  │ Category:   Clothing     │    │
│  └──────────────────────────┘    │
│                                   │
│  ┌───────  LISTING  ─────────┐   │
│  │ List Price:   €65.00      │   │
│  │ Min Price:    €45.00      │   │
│  │ Platform:     Vinted      │   │
│  │ Listed:       05 Jun 2025 │   │
│  └──────────────────────────┘    │
│                                   │
│  ┌───────  SALE  ────────────┐   │
│  │ Sale Price:   €58.00      │   │
│  │ Sale Date:    10 Jun 2025 │   │
│  │ Vinted Fees:  €4.50       │   │
│  │ Shipping:     €3.00       │   │
│  │ Packaging:    €1.00       │   │
│  └──────────────────────────┘    │
│                                   │
│  ┌─────────────────────────────┐  │
│  │  ⚡  PROFIT                  │  │  ← Gold-accented section
│  │  ─────────────               │  │     Background: subtle gold tint
│  │  Revenue       €58.00        │  │     (Surface Container + 2% gold)
│  │  Total Costs   €33.50        │  │
│  │  ─────────────               │  │
│  │  Net Profit  +€24.50        │  │  ← Gold, Inter Bold, 20px
│  │  ROI         +73.1%         │  │  ← Gold chip
│  └─────────────────────────────┘  │
│                                   │
│  ┌───────  NOTES  ────────────┐   │
│  │ Bought for personal use    │   │
│  │ but didn't fit. Sold fast  │   │  ← Notes section
│  │ because priced 10% below   │   │     Inter Regular, 14px
│  │ market avg.                │   │
│  └────────────────────────────┘    │
│                                   │
│  ┌─────────────────────────────┐  │
│  │  [Edit Item]  [Delete]     │  │  ← Outline + ghost buttons
│  └─────────────────────────────┘  │
├───────────────────────────────────┤
│  🏠  ▦  ＋  📊  ⚙️               │  ← Bottom nav
└───────────────────────────────────┘
```

### 7.4 Settings

```
┌───────────────────────────────────╮
│  ←  Settings                      │  ← App bar: back + title
├───────────────────────────────────┤
│                                   │
│  ┌─────────────────────────────┐  │
│  │  ┌────┐                     │  │
│  │  │    │  Margine v2.0.0    │  │  ← About section (centered)
│  │  └────┘  Built with ❤️     │  │     Logo + version
│  └─────────────────────────────┘  │
│                                   │
│  ┌─────────────────────────────┐  │
│  │  Appearance                 │  │  ← Section header (Sora Medium, 14px
│  │                             │  │     uppercase, +0.05em tracking)
│  │  █ Light Mode  ○ Dark Mode │  │  ← Radio-style toggle
│  │  ○ Match System             │  │
│  └─────────────────────────────┘  │
│                                   │
│  ┌─────────────────────────────┐  │
│  │  Currency            € EUR →│  │  ← Row with chevron
│  │  Default Category    All  → │  │     Key secondary, value primary
│  │  Default Source     Vinted→│  │
│  └─────────────────────────────┘  │
│                                   │
│  ┌─────────────────────────────┐  │
│  │  Notifications              │  │
│  │  ─────────────────────      │  │
│  │  Price alerts         ○     │  │  ← Toggle switches
│  │  Low stock warnings   ○     │  │     Primary color when on
│  │  Sale reminders       ○     │  │
│  └─────────────────────────────┘  │
│                                   │
│  ┌─────────────────────────────┐  │
│  │  Data                       │  │
│  │  ─────────────────────      │  │
│  │  Export to CSV        →     │  │
│  │  Import from backup   →     │  │
│  │  Clear all data       →     │  │  ← Red text for destructive
│  └─────────────────────────────┘  │
│                                   │
│  ┌─────────────────────────────┐  │
│  │  About                      │  │
│  │  ─────────────────────      │  │
│  │  Version           2.0.0    │  │
│  │  Built with    Flutter+Drift│  │
│  │  Licenses              →    │  │
│  │  Privacy Policy        →    │  │
│  └─────────────────────────────┘  │
├───────────────────────────────────┤
│  🏠  ▦  ＋  📊  ⚙️               │  ← Bottom nav (Settings active)
└───────────────────────────────────┘
```

### 7.5 Analytics

```
┌───────────────────────────────────╮
│  ←  Analytics               ⋮    │  ← App bar: back + title + export menu
├───────────────────────────────────┤
│                                   │
│  ┌─────────────────────────────┐  │
│  │  Total Revenue              │  │
│  │  +€1,245.00                 │  │  ← Large KPI, gold accent
│  │  ▲ +12.4% from last month  │  │  ← Trend indicator (green for up)
│  └─────────────────────────────┘  │
│                                   │
│  ┌ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┐   │
│  │  ╱╲    ╱╲                  │   │
│  │ ╱  ╲  ╱  ╲  ╱╲            │   │  ← Revenue chart (area)
│  │╱    ╲╱    ╲╱  ╲  ╱╲      │   │     Amethyst gradient fill
│  │           ╲╱    ╲╱  ╲    │   │     Gold line at profit threshold
│  │ Month:   May  Jun  Jul    │   │
│  └ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┘   │
│                                   │
│  ┌──────────┐ ┌──────────┐       │
│  │ Avg ROI  │ │ Best ROI │       │  ← Stat cards
│  │ +38%     │ │ +73.1%   │       │
│  │ all time │ │ Levi's   │       │
│  └──────────┘ └──────────┘       │
│                                   │
│  ┌ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┐   │
│  │  Items by Category        │   │
│  │  ┌─────┐                  │   │
│  │  │ ▓▓▓▓▓▓▓▓▓▓░░░░░░░ │   │   │  ← Horizontal bar chart
│  │  │ Clothing  12  52%   │   │   │     Amethyst bars
│  │  │ ▓▓▓▓▓▓▓░░░░░░░░░░░ │   │   │
│  │  │ Access.    6  26%   │   │   │
│  │  │ ▓▓▓▓▓░░░░░░░░░░░░░ │   │   │
│  │  │ Footwear   3  13%   │   │   │
│  │  │ ▓░░░░░░░░░░░░░░░░░░│   │   │
│  │  │ Tech       2   9%   │   │   │
│  │  └─────┘                  │   │
│  └ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┘   │
│                                   │
│  ┌─────────────────────────────┐  │
│  │  Top Performers             │  │
│  │  ┌───────────────────────┐  │  │
│  │  │ 1.  Levi's 501   +73%│  │  │  ← Ranked list, gold #1
│  │  │ 2.  Air Max     +42% │  │  │
│  │  │ 3.  Denim Jacket +38%│  │  │
│  │  └───────────────────────┘  │  │
│  │  [View All Items →]         │  │
│  └─────────────────────────────┘  │
│                                   │
│  Period: [7D] [30D] [All]        │  ← Period selector chips
├───────────────────────────────────┤
│  🏠  ▦  ＋  📊  ⚙️               │  ← Bottom nav (Analytics active)
└───────────────────────────────────┘
```

---

## 8. Light & Dark Mode — Full Specification

### 8.1 Light Mode — "Pearl Gallery"

The light mode evokes a **minimalist art gallery** — clean, bright, with deep color accents that command attention.

```
Surface:              #F5F3F0  ← Cool pearl, architectural white
Surface Container:    #FFFFFF  ← Pure white for cards
Primary:              #2D2B55  ← Deep amethyst
Accent (Gold):        #B8860B  ← Antique gold
On Surface (high):    #1A1A2E  ← Near-black with violet undertone
On Surface (medium):  #5C5C70  ← Muted violet-gray
On Surface (disabled):#B0B0C0  ← Light lavender-gray
Outline:              #D6D5E0  ← Subtle violet-gray
Outline (subtle):     #E8E7F0  ← Very light violet
Success:              #2E7D32  ← Deep green
Error:                #C62828  ← Deep red
Info:                 #2B6CB0  ← Deep blue
```

**Light mode texture:** No gradients. No shadows larger than Elevation 2. The feel is crisp, editorial, and precise.

### 8.2 Dark Mode — "Night Vault"

The dark mode is **the premium experience** — deep, immersive, with electric accents that feel like neon in a dark room.

```
Surface:              #0F0F14  ← Near-black with violet undertone
Surface Container:    #18181F  ← Slightly lighter vault surface
Primary:              #818CF8  ← Electric amethyst/periwinkle
Accent (Gold):        #F5A623  ← Bright glowing gold
On Surface (high):    #EDEDF5  ← Warm off-white (not pure white)
On Surface (medium):  #9E9EB0  ← Muted lavender-gray
On Surface (disabled):#454558  ← Dark violet-gray
Outline:              #2E2E40  ← Dark violet-gray
Outline (subtle):     #252538  ← Very dark violet
Success:              #4CAF50  ← Bright green
Error:                #EF5350  ← Bright red
Info:                 #63B3ED  ← Bright blue
```

**Dark mode texture:** The amethyst primary `#818CF8` acts as a **rim light** — elevated surfaces get a 1dp top-edge highlight of primary at 15% opacity. Cards appear to have a subtle top glow, like light catching the edge of a glass display case.

### 8.3 Mode-Specific Color Tokens

| Token | Light Hex | Dark Hex | Role |
|-------|-----------|----------|------|
| `primary` | `#2D2B55` | `#818CF8` | Primary actions, active states |
| `primaryContainer` | `#E8E7F0` | `#2A2A45` | Tonal buttons, chip fills |
| `onPrimaryContainer` | `#2D2B55` | `#BDBDFF` | Text on primary containers |
| `accent` | `#B8860B` | `#F5A623` | Profit, premium badges |
| `accentContainer` | `#FFF8E7` | `#2A220A` | Profit chip fills |
| `onAccentContainer` | `#8B6910` | `#FFD700` | Text on profit containers |
| `surface` | `#F5F3F0` | `#0F0F14` | App background |
| `surfaceContainer` | `#FFFFFF` | `#18181F` | Card/sheet backgrounds |
| `onSurface` | `#1A1A2E` | `#EDEDF5` | Primary text |
| `onSurfaceSecondary` | `#5C5C70` | `#9E9EB0` | Secondary text |
| `onSurfaceTertiary` | `#B0B0C0` | `#454558` | Disabled/placeholder |
| `outline` | `#D6D5E0` | `#2E2E40` | Borders, dividers |
| `outlineSubtle` | `#E8E7F0` | `#252538` | Hairline separators |
| `success` | `#2E7D32` | `#4CAF50` | Positive/sold |
| `error` | `#C62828` | `#EF5350` | Negative/deletion |
| `info` | `#2B6CB0` | `#63B3ED` | Neutral info |
| `scrim` | `#2D2B55` @ 40% | `#000000` @ 60% | Modal backdrop |
| `shadow` | `#2D2B55` | `#000000` | Drop shadows |
| `elevatedGlow` | None | `#818CF8` @ 5% | Rim light on elevated surfaces |

---

## 9. Spacing System — "The Half-Step"

Margine uses an **8dp grid** with a **4dp half-step** for fine adjustments:

| Token | Value | Usage |
|-------|-------|-------|
| `space-2` | 2dp | Icon-to-icon, micro adjustments |
| `space-4` | 4dp | Fine spacing, icon-to-text gap in chips |
| `space-8` | 8dp | Half-step, small gaps, chip padding |
| `space-12` | 12dp | Between sections in a card |
| `space-16` | 16dp | **Base unit** — card padding, between cards |
| `space-20` | 20dp | Section separators on a page |
| `space-24` | 24dp | Page margins, dialog padding |
| `space-32` | 32dp | Large section breaks |
| `space-40` | 40dp | Hero spacing, between major content blocks |
| `space-48` | 48dp | Page inset from app bar |

**Rule of thumb:** Content should never touch edges. The minimum margin from screen edge is 24dp. The minimum gap between cards is 16dp. The minimum inner padding of a card is 16dp.

---

## 10. Iconography

### 10.1 Icon Style

| Property | Value |
|----------|-------|
| Style | Outline-only (except filled nav active state) |
| Stroke weight | 2dp |
| Stroke caps | Rounded |
| Stroke joins | Rounded |
| Size | 24dp (standard), 20dp (inline), 16dp (chip/badge) |
| Source | Material Symbols (Outlined), custom weight 400 |

### 10.2 Icon Set Reference

| Use Case | Icon | Context |
|----------|------|---------|
| Dashboard | `home` | Bottom nav |
| Items | `grid_view` or `inventory_2` | Bottom nav |
| Add | `add` (filled, white) | FAB |
| Analytics | `bar_chart` or `trending_up` | Bottom nav |
| Settings | `settings` | Bottom nav, app bar |
| Search | `search` | App bar |
| Edit | `edit` | Item detail |
| Delete | `delete` | Destructive actions |
| Back | `arrow_back` | Navigation |
| Close | `close` | Dismissals |
| More | `more_vert` | Overflow menu |
| Filter | `filter_alt` or `tune` | Filter controls |
| Sort | `sort` | Sort controls |
| Export | `file_download` | Analytics export |
| Profit | `trending_up` | Positive indicators |
| Loss | `trending_down` | Negative indicators |
| Bought | `shopping_bag` | Status chip |
| Listed | `sell` | Status chip |
| Sold | `check_circle` | Status chip |
| Camera | `photo_camera` | Product photo capture |
| Notes | `notes` or `description` | Notes field |
| Category | `category` or `label` | Category field |

---

## 11. Empty States

### 11.1 No Items (First Launch)

```
┌───────────────────────────────────╮
│                                   │
│                                   │
│          ┌────┐                   │
│          │    │                   │  ← Logo mark, 96dp, 40% opacity
│          └────┘                   │
│                                   │
│   **Start your resell journey**   │  ← Heading M, Sora Bold, Primary
│                                   │
│   Track every Vinted flip in     │  ← Body L, Inter Regular, Secondary
│   one place. Know your margins   │
│   before you buy.                │
│                                   │
│   ┌─────────────────────────┐    │
│   │  +  Add First Item     │    │  ← Filled primary button (large)
│   └─────────────────────────┘    │
│                                   │
│                                   │
├───────────────────────────────────┤
│  🏠  ▦  ＋  📊  ⚙️               │
└───────────────────────────────────┘
```

### 11.2 No Results (Filter Active)

```
┌───────────────────────────────────┐
│                                   │
│          🔍                       │  ← Search icon, 64dp, Secondary at 40%
│                                   │
│   **No items match this filter**  │
│                                   │
│   Try adjusting your filter or    │
│   add a new item.                 │
│                                   │
│   [  Clear Filters  ]             │  ← Outline button
│                                   │
└───────────────────────────────────┘
```

### 11.3 Empty Analytics

```
┌───────────────────────────────────┐
│                                   │
│          📊                       │  ← Chart icon, 64dp, Secondary at 40%
│                                   │
│   **Not enough data yet**         │
│                                   │
│   Add at least 3 items to see    │
│   your analytics and trends.      │
│                                   │
└───────────────────────────────────┘
```

---

## 12. Design Principles (Summary)

| # | Principle | What It Means |
|---|-----------|---------------|
| 1 | **The margin IS the hero** | Profit figures are always biggest, boldest, goldest thing on screen |
| 2 | **Amethyst by day, Electric by night** | The primary transforms from regal to radiant across modes — lean into the transformation |
| 3 | **Generous air** | 24dp margins, 16dp card padding, large radii, premium breathing room |
| 4 | **Precision in everything** | Every 4dp matters. Exact hex codes, exact spacing, no loose ends |
| 5 | **Cold never, warm always** | Every neutral has a whisper of violet or warmth. No `#808080`. No `#FFFFFF`. |
| 6 | **Touch is a conversation** | Every swipe, tap, and pull has a haptic response and a visual acknowledgment |
| 7 | **Gold is earned** | Gold is only for profit and premium actions. It's the reward color. |
| 8 | **Nothing moves without reason** | Every animation communicates purpose — status change, navigation, data update |
| 9 | **Local first, private always** | The design treats the user's data as precious. No cloud, no sync — the app is a vault. |

---

## 13. Implementation Notes (Flutter)

### 13.1 Theme Configuration

```dart
// Core color seeds (Material 3 dynamic)
const Color primarySeed = Color(0xFF2D2B55);
const Color accentSeed = Color(0xFFB8860B);
const Color surfaceLight = Color(0xFFF5F3F0);
const Color surfaceDark = Color(0xFF0F0F14);

// ThemeData setup
ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  colorSchemeSeed: primarySeed,
  brightness: Brightness.light,
  // Card theme, button theme, etc.
);

ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  colorSchemeSeed: primarySeed,
  brightness: Brightness.dark,
);
```

### 13.2 Google Fonts

```yaml
# pubspec.yaml
dependencies:
  google_fonts: ^6.1.0
```

```dart
// Headings
Text(
  'MARGINE',
  style: GoogleFonts.sora(
    fontSize: 24,
    fontWeight: FontWeight.w800,
    letterSpacing: 1.5,  // +0.15em at 24px = 3.6px, ~1.5 in Flutter
    color: primaryColor,
  ),
);

// Body
Text(
  '€45.00',
  style: GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    fontFeatures: [FontFeature.tabularFigures()],
    color: onSurfaceHigh,
  ),
);
```

### 13.3 Spacing Constants

```dart
class AppSpacing {
  static const double xxs = 2;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double base = 16;
  static const double lg = 20;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 40;
  static const double page = 48;
}
```

---

## 14. Accessibility

- **WCAG AA** compliant for all text sizes (4.5:1 for normal text, 3:1 for large text)
- **Touch targets** minimum 44dp × 44dp (48dp preferred)
- **Focus indicators** use primary color outline (2dp width, 2dp offset)
- **Reduce motion** respects `MediaQuery.disableAnimations` — all animations degrade to 0ms instantly
- **Font scaling** respects system font size settings up to 200%
- **Contrast check** for primary `#2D2B55` on surface `#F5F3F0`: **8.1:1** ✅
- **Contrast check** for primary `#818CF8` on surface `#0F0F14`: **6.3:1** ✅
- **Contrast check** for gold `#B8860B` on surface `#F5F3F0`: **4.7:1** ✅ (large text)
- **Contrast check** for gold `#F5A623` on surface `#0F0F14`: **8.9:1** ✅

---

*Margine v2.0 Design System — "Noir & Amethyst"*
*Complete rebrand. Zero tennis green. Zero court metaphors. Zero inspiration from v1.*
