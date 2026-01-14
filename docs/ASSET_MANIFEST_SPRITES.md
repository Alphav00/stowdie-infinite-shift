# 🎨 Sprite Asset Manifest

**Project:** StowOrDie: Infinite Shift  
**Art Style:** "Corporate Decay Pixel Art"  
**Base Resolution:** 16-bit (4x integer scaling to 1080p)  
**Palette:** Hyper-saturated corporate → desaturated horror  
**Animation:** Limited (3-4 frames) for uncanny effect  
**Date:** January 13, 2026

---

## 📋 Table of Contents

1. [Characters](#characters)
2. [Environment](#environment)
3. [Items](#items)
4. [UI Elements](#ui-elements)
5. [Effects](#effects)
6. [Technical Specifications](#technical-specifications)

---

## 👥 CHARACTERS

### **CHAR-001: Associate (Player Character)**
**File:** `char_associate_idle.png`  
**Size:** 32x64px  
**Frames:** 2 (idle breathing animation)  
**Colors:** Safety vest yellow (#FFD700), gray uniform (#4A4A5A), brown skin tone

**Description:**
Warehouse worker in safety vest and hard hat. Neutral expression showing exhaustion. Visible ID badge on chest. Standing upright with slight slouch.

**States Needed:**
- `char_associate_idle_01.png` - Breathing frame 1
- `char_associate_idle_02.png` - Breathing frame 2
- `char_associate_walk_01.png` - Walk cycle frame 1
- `char_associate_walk_02.png` - Walk cycle frame 2
- `char_associate_walk_03.png` - Walk cycle frame 3

**Animation:** Alternate idle frames every 0.5s for breathing effect

---

### **CHAR-002: Lyon (Boss - Normal Form)**
**File:** `char_lyon_patrol.png`  
**Size:** 48x96px (larger than player to show authority)  
**Frames:** 4 per state  
**Colors:** Corporate suit gray (#2B2B3A), white shirt, red tie, pale skin

**Description:**
Middle manager in business casual. Stern expression, clipboard in hand. Clean-cut appearance in PATROL state. Visible corporate ID badge.

**States Needed:**

#### PATROL State:
- `char_lyon_patrol_walk_01.png` - Walk frame 1 (facing left)
- `char_lyon_patrol_walk_02.png` - Walk frame 2
- `char_lyon_patrol_walk_03.png` - Walk frame 3
- `char_lyon_patrol_walk_04.png` - Walk frame 4

#### AUDIT State:
- `char_lyon_audit_stand.png` - Standing still, arms crossed
- `char_lyon_audit_point.png` - Pointing at player
- `char_lyon_audit_clipboard.png` - Looking at clipboard

#### STARE Behavior (PATROL substory):
- `char_lyon_stare_front.png` - Facing camera (4th wall break)
- `char_lyon_stare_side.png` - Profile stare

**Animation:** 
- PATROL: Loop walk cycle at 8fps
- AUDIT: Hold stand, cycle to point/clipboard every 1.5s
- STARE: Hold front stare for 1.5-2.5s

---

### **CHAR-003: Lyon (Boss - Demon Form)**
**File:** `char_lyon_demon.png`  
**Size:** 96x96px (larger than normal, imposing)  
**Frames:** 4  
**Colors:** Black (#0A0A0F), glowing eyes red (#FF0000), distorted proportions

**Description:**
Corrupted manager form. Elongated limbs, hunched posture. Glowing red eyes. Suit torn and disheveled. Shadow trails from body. Face partially obscured. Menacing silhouette.

**Demon State Needed:**
- `char_lyon_demon_idle_01.png` - Breathing/pulsing frame 1
- `char_lyon_demon_idle_02.png` - Breathing/pulsing frame 2
- `char_lyon_demon_chase_01.png` - Chase animation frame 1
- `char_lyon_demon_chase_02.png` - Chase animation frame 2

**Animation:** 
- Idle: Pulse between frames at 4fps for unsettling effect
- Chase: Fast cycle at 12fps for aggressive movement

**Shader:** ShadowDistortion.gdshader applied for wavering effect

---

### **CHAR-004: Stewie (Tutorial Rat)**
**File:** `char_stewie.png`  
**Size:** 48x48px  
**Frames:** 3  
**Colors:** Gray fur (#6A6A7A), yellow safety vest (tiny), beady black eyes

**Description:**
Cartoon rat wearing tiny safety vest and hard hat. Friendly but tired expression. Stands on hind legs. Holding miniature clipboard. Sympathetic guide character.

**States Needed:**
- `char_stewie_idle.png` - Standing, clipboard held
- `char_stewie_point.png` - Pointing at something
- `char_stewie_wave.png` - Waving hello/goodbye

**Animation:** Hold each pose for 1-2 seconds during tutorial

**Usage:** Tutorial phase only, appears in top-left corner

---

## 🏭 ENVIRONMENT

### **ENV-001: Aisle Segment (CLEAN)**
**File:** `env_aisle_clean.png`  
**Size:** 64x128px (vertical segment)  
**Frames:** 1 (static)  
**Colors:** Industrial gray (#5A5A6A), clean floor, bright lighting

**Description:**
Industrial warehouse shelving unit. Metal frame with bolts visible. Empty shelves (items removed). Clean concrete floor tile at bottom. Fluorescent lighting from above. Corporate cleanliness.

**Variants:**
- `env_aisle_clean_01.png` - Standard aisle
- `env_aisle_clean_02.png` - Aisle with slight rust on bolts
- `env_aisle_clean_03.png` - Aisle with safety notice posted

**Usage:** Spawned when Rate > 60%

---

### **ENV-002: Aisle Segment (DIRTY)**
**File:** `env_aisle_dirty.png`  
**Size:** 64x128px  
**Frames:** 1  
**Colors:** Desaturated gray, dirt stains brown (#3A2A1A), dim lighting

**Description:**
Same aisle structure but degraded. Visible dirt/oil stains on shelves. Concrete floor cracked and stained. One fluorescent light flickering (drawn as darker). Dust particles suggested. Safety notice torn/missing.

**Variants:**
- `env_aisle_dirty_01.png` - Light dirt, few cracks
- `env_aisle_dirty_02.png` - Moderate dirt, more cracks, oil stains
- `env_aisle_dirty_03.png` - Heavy dirt, rust spots, graffiti scrawl

**Decals (separate files):**
- `decal_oil_stain.png` (16x16px) - Small oil puddle
- `decal_dust.png` (32x32px) - Dust pile

**Usage:** Spawned when Rate 20-60%

---

### **ENV-003: Aisle Segment (BLOODY)**
**File:** `env_aisle_bloody.png`  
**Size:** 64x128px  
**Frames:** 1  
**Colors:** Dark gray/black, blood red (#8A0000), deep shadows

**Description:**
Heavily corrupted aisle. Blood handprints on shelves. Floor covered in dark stains. Shelves bent/warped. No lighting (pitch black top). Graffiti visible: "STOWAWAY", "LEFT BEHIND", "PROBLEM SOLVED". Eldritch corruption suggested at edges.

**Variants:**
- `env_aisle_bloody_01.png` - Blood handprints, single graffiti
- `env_aisle_bloody_02.png` - Multiple handprints, heavy stains
- `env_aisle_bloody_03.png` - Corruption spreading, text "RUN"

**Decals (separate files):**
- `decal_blood_handprint.png` (24x24px) - Single handprint
- `decal_blood_pool.png` (32x16px) - Blood puddle
- `decal_graffiti_stowaway.png` (48x16px) - "STOWAWAY" text
- `decal_graffiti_leftbehind.png` (48x16px) - "LEFT BEHIND" text
- `decal_graffiti_run.png` (32x16px) - "RUN" text

**Usage:** Spawned when Rate < 20% (Demon Hour)

---

### **ENV-004: Floor Tile (Base)**
**File:** `env_floor_tile.png`  
**Size:** 64x32px (isometric tile)  
**Frames:** 1  
**Colors:** Concrete gray (#6A6A7A), subtle grid lines

**Description:**
Basic warehouse floor tile. Concrete texture with subtle cracks. Faint grid lines marking tile boundaries. Industrial appearance.

**Variants:**
- `env_floor_clean.png` - Pristine concrete
- `env_floor_dirty.png` - Stained, cracked
- `env_floor_bloody.png` - Dark stains, corruption

**Usage:** Tiled horizontally under aisles

---

### **ENV-005: Stow Zone Indicator**
**File:** `env_stow_zone.png`  
**Size:** 64x96px  
**Frames:** 2 (pulsing)  
**Colors:** Yellow highlight (#FFD700), glowing effect

**Description:**
Highlighted area on aisle indicating stow zone. Yellow glowing outline around shelf section. Pulsing animation to draw attention. Only visible when player has full tote.

**States:**
- `env_stow_zone_pulse_01.png` - Bright glow
- `env_stow_zone_pulse_02.png` - Dim glow

**Animation:** Alternate every 0.5s for pulsing effect

**Usage:** Overlaid on aisle when tote is full

---

### **ENV-006: Hide Spot**
**File:** `env_hide_spot.png`  
**Size:** 48x64px  
**Frames:** 1  
**Colors:** Darker gray (#3A3A4A), shadow effect

**Description:**
Designated hiding area under/behind shelf. Darker shadowed region. Visible gap between shelf levels. Player sprite partially obscured when hiding here.

**Variants:**
- `env_hide_spot_empty.png` - Available (subtle highlight)
- `env_hide_spot_occupied.png` - Player hiding (darkened)

**Usage:** Placed periodically on aisles, triggers hide mechanic

---

## 📦 ITEMS

### **ITEM-001: Standard Box**
**File:** `item_box_standard.png`  
**Size:** 32x32px  
**Frames:** 1  
**Colors:** Cardboard brown (#8A6A3A), shipping label, tape

**Description:**
Amazon-style cardboard box. Brown corrugated texture. White shipping label with barcode. Clear packing tape across top. Neutral, mundane appearance.

**Variants:**
- `item_box_small.png` (24x24px) - Smaller package
- `item_box_large.png` (48x48px) - Larger package
- `item_box_damaged.png` (32x32px) - Torn corner, bent

**Usage:** Spawned in bottom screen item queue

---

### **ITEM-002: Possessed Box**
**File:** `item_box_possessed.png`  
**Size:** 32x32px → expands to 48x48px  
**Frames:** 3 (expansion animation)  
**Colors:** Brown base, red glow (#FF0000), pulsing veins

**Description:**
Corrupted box that expands when not suppressed. Red glowing cracks appear on surface. Pulsing veins spread across cardboard. Slight distortion/warping at edges. Unsettling organic quality.

**States:**
- `item_box_possessed_01.png` (32x32px) - Initial spawn
- `item_box_possessed_02.png` (40x40px) - Mid-expansion
- `item_box_possessed_03.png` (48x48px) - Full expansion

**Shader:** PossessionGlow.gdshader applied for red outline pulse

**Animation:** Expand over 2 seconds if not touched/suppressed

**Usage:** Spawned when Rate < 60%, frequency increases with lower Rate

---

### **ITEM-003: Yellow Tote**
**File:** `item_tote.png`  
**Size:** 64x48px (container)  
**Frames:** 1  
**Colors:** Safety yellow (#FFD700), black handles, grid pattern

**Description:**
Industrial yellow plastic tote. Black handles on sides. Visible internal grid dividers. Transparent enough to show items inside (overlaid sprites). Practical warehouse aesthetic.

**States:**
- `item_tote_empty.png` - No items inside
- `item_tote_partial.png` - Some items visible inside
- `item_tote_full.png` - Stacked items visible, full

**Usage:** Bottom screen, holds items during packing

---

### **ITEM-004: Scanner (Player Equipment)**
**File:** `item_scanner.png`  
**Size:** 16x24px  
**Frames:** 2  
**Colors:** Gray plastic (#5A5A6A), green LED screen

**Description:**
Handheld barcode scanner. Gray industrial plastic. Small green LED screen on top. Trigger button visible. Attached to player's belt when not in use.

**States:**
- `item_scanner_idle.png` - Holstered on belt
- `item_scanner_scan.png` - Held up, LED glowing

**Usage:** Visual prop on player character, animates during stow action

---

### **ITEM-005: Clipboard (Lyon's Equipment)**
**File:** `item_clipboard.png`  
**Size:** 16x24px  
**Frames:** 1  
**Colors:** Brown board, white paper, text scribbles

**Description:**
Standard office clipboard. Brown pressboard backing. White paper with illegible text/checkboxes. Lyon holds this during PATROL and AUDIT states.

**Usage:** Always visible in Lyon's hand during normal form

---

## 🖼️ UI ELEMENTS

### **UI-001: Rate Meter Bar**
**File:** `ui_rate_bar_fill.png`  
**Size:** 200x24px  
**Frames:** 1 (dynamic filling)  
**Colors:** Green (#00FF00) → Yellow (#FFD700) → Red (#FF0000)

**Description:**
Horizontal progress bar showing Rate percentage. Gradient color based on value:
- 100-60%: Green (safe)
- 59-20%: Yellow (warning)
- 19-0%: Red (danger)

**Components:**
- `ui_rate_bar_bg.png` - Empty bar background (gray)
- `ui_rate_bar_fill.png` - Colored fill (dynamic width)
- `ui_rate_bar_border.png` - Frame/border around bar

**Usage:** Top of top screen HUD, always visible

---

### **UI-002: Phase Indicator Icons**
**File:** `ui_phase_icon.png`  
**Size:** 32x32px each  
**Frames:** 3 (one per phase)  
**Colors:** White icons on dark background

**Description:**
Icons indicating current game phase.

**Variants:**
- `ui_phase_tutorial.png` - Clipboard icon (teaching)
- `ui_phase_normal.png` - Clock icon (ticking)
- `ui_phase_demon.png` - Skull/demon icon (danger)

**Usage:** Top-left corner of top screen, changes with phase transitions

---

### **UI-003: Tote Efficiency Indicator**
**File:** `ui_tote_efficiency.png`  
**Size:** 48x48px  
**Frames:** 1 (dynamic fill)  
**Colors:** Green → Red gradient based on efficiency

**Description:**
Circular pie chart showing tote fullness. Fills clockwise as items added. Color intensity indicates efficiency.

**States:**
- `ui_tote_empty.png` - Empty circle (gray outline)
- `ui_tote_partial.png` - Partially filled (dynamic angle)
- `ui_tote_full.png` - Complete circle (ready to stow)

**Usage:** Bottom screen corner, updates with each item added

---

### **UI-004: Stow Ready Indicator**
**File:** `ui_stow_ready.png`  
**Size:** 64x64px  
**Frames:** 2 (pulsing)  
**Colors:** Glowing yellow (#FFD700), arrow pointing up

**Description:**
Large arrow pointing upward with "SWIPE UP TO STOW" text below. Pulsing glow effect. Only appears when tote is full.

**States:**
- `ui_stow_ready_01.png` - Bright glow
- `ui_stow_ready_02.png` - Dim glow

**Animation:** Pulse every 0.5s to draw attention

**Usage:** Appears center-bottom of top screen when tote full

---

### **UI-005: Lyon Detection Cone (Debug)**
**File:** `ui_lyon_vision_cone.png`  
**Size:** 128x128px (semi-transparent overlay)  
**Frames:** 1  
**Colors:** Red (#FF0000) at 30% opacity

**Description:**
Visual representation of Lyon's 120° detection cone. Wedge shape extending from Lyon. Red transparent overlay. Only visible in debug mode.

**Usage:** Debug visualization of Lyon's detection radius

---

## ✨ EFFECTS

### **VFX-001: Blood Decal Set**
**Sizes:** Varied (16x16px to 48x48px)  
**Frames:** 1 each  
**Colors:** Dark red (#8A0000), brown undertones

**Variants:**
- `vfx_blood_splatter_01.png` (24x24px) - Small splatter
- `vfx_blood_splatter_02.png` (32x32px) - Medium splatter
- `vfx_blood_splatter_03.png` (48x48px) - Large pool
- `vfx_blood_handprint.png` (24x24px) - Handprint on wall
- `vfx_blood_drag.png` (64x16px) - Drag mark across floor

**Usage:** Randomly spawned on aisles during Demon Hour (Rate < 20%)

---

### **VFX-002: Particle Effects**
**Sizes:** 4x4px to 8x8px  
**Frames:** 1 each (used in particle systems)  
**Colors:** Various

**Variants:**
- `vfx_particle_dust.png` (4x4px) - Gray dust mote
- `vfx_particle_glitch.png` (6x6px) - Colored glitch pixel
- `vfx_particle_spark.png` (8x8px) - Yellow spark
- `vfx_particle_blood.png` (4x4px) - Red droplet

**Usage:** 
- Dust: Environmental ambiance in DIRTY/BLOODY aisles
- Glitch: During phase transitions
- Spark: During alarm triggers
- Blood: Demon form trailing effect

---

### **VFX-003: Shadow Overlay**
**File:** `vfx_shadow.png`  
**Size:** 48x24px (ellipse)  
**Frames:** 1  
**Colors:** Black (#000000) at 50% opacity

**Description:**
Simple elliptical shadow below characters. Darker at center, fades to transparent at edges. Gives characters grounding on floor.

**Usage:** Under all characters (player, Lyon, Stewie)

---

### **VFX-004: Screen Shake Overlay (Optional)**
**File:** `vfx_screen_shake.png`  
**Size:** Full viewport (1080x1920px)  
**Frames:** 3  
**Colors:** Red tint at 10% opacity

**Description:**
Optional red flash overlay during alarm/demon transformation. Very subtle red tint. Flickers on/off rapidly.

**Usage:** Triggered by GameManager.trigger_alarm() signal

---

## 📐 TECHNICAL SPECIFICATIONS

### **General Requirements**

**File Format:** PNG with transparency (alpha channel)  
**Color Depth:** 32-bit RGBA  
**Export Settings:**
- No compression (lossless)
- Preserve transparency
- No color profile (sRGB assumed)

### **Naming Convention**

```
[category]_[name]_[state]_[frame].png

Examples:
char_associate_idle_01.png
char_lyon_patrol_walk_01.png
env_aisle_clean_01.png
item_box_possessed_02.png
ui_rate_bar_fill.png
vfx_blood_splatter_01.png
```

**Categories:**
- `char` - Characters
- `env` - Environment
- `item` - Items
- `ui` - User Interface
- `vfx` - Visual Effects

### **Resolution Guidelines**

**Base Resolution:** 16-bit pixel art style  
**Scaling:** 4x integer scaling for 1080p display  
**Anti-aliasing:** NONE (pixel-perfect rendering)

**Character Sizes:**
- Player: 32x64px (base)
- Lyon (normal): 48x96px
- Lyon (demon): 96x96px
- Stewie: 48x48px

**Environment Sizes:**
- Aisle segment: 64x128px
- Floor tile: 64x32px
- Props: 16x16px to 48x48px

**Item Sizes:**
- Standard: 32x32px
- Tote: 64x48px
- Small items: 16x16px to 24x24px

### **Color Palette Themes**

**CLEAN Phase (Rate > 60%):**
- Primary: Safety yellow (#FFD700)
- Secondary: Industrial gray (#5A5A6A)
- Accent: White (#FFFFFF)
- Lighting: Bright, saturated

**DIRTY Phase (Rate 20-60%):**
- Primary: Desaturated yellow (#B8A060)
- Secondary: Dark gray (#3A3A4A)
- Accent: Dirt brown (#3A2A1A)
- Lighting: Dim, less saturated

**BLOODY Phase (Rate < 20%):**
- Primary: Blood red (#8A0000)
- Secondary: Black (#0A0A0F)
- Accent: Sickly green (#2A4A1A)
- Lighting: Very dark, desaturated

### **Animation Frame Rates**

- **Idle breathing:** 2 frames @ 2fps (0.5s per frame)
- **Walk cycles:** 3-4 frames @ 8fps
- **Chase/urgent:** 2-4 frames @ 12fps
- **UI pulsing:** 2 frames @ 2fps (0.5s per frame)
- **VFX flicker:** 3-4 frames @ 15fps

### **Godot Import Settings**

```gdscript
# In Godot import settings for each sprite:
Compress: Lossless
Filter: false (pixel-perfect)
Mipmaps: false
Repeat: false
```

### **Sprite Sheet Alternative**

If preferred, sprites can be delivered as sprite sheets:

**Format:**
- All frames of one animation in horizontal strip
- Consistent frame size
- No padding between frames
- Metadata JSON file with frame positions

**Example:**
```
char_lyon_patrol_walk.png (192x96px = 4 frames × 48x96px each)
Frame 0: x=0, y=0, w=48, h=96
Frame 1: x=48, y=0, w=48, h=96
Frame 2: x=96, y=0, w=48, h=96
Frame 3: x=144, y=0, w=48, h=96
```

---

## 📊 Asset Checklist

### **Characters** (5 sets, ~40 files)
- [ ] Associate (Player) - 5 sprites
- [ ] Lyon Normal Form - 9 sprites
- [ ] Lyon Demon Form - 4 sprites
- [ ] Stewie (Tutorial Rat) - 3 sprites
- [ ] Equipment (Scanner, Clipboard) - 3 sprites

### **Environment** (6 sets, ~30 files)
- [ ] Aisle Clean variants - 3 sprites
- [ ] Aisle Dirty variants - 3 sprites + 2 decals
- [ ] Aisle Bloody variants - 3 sprites + 5 decals
- [ ] Floor tiles - 3 sprites
- [ ] Stow zone indicator - 2 sprites
- [ ] Hide spot - 2 sprites

### **Items** (5 sets, ~15 files)
- [ ] Standard boxes - 4 variants
- [ ] Possessed box - 3 frames
- [ ] Yellow tote - 3 states
- [ ] Scanner - 2 states
- [ ] Clipboard - 1 sprite

### **UI Elements** (5 sets, ~15 files)
- [ ] Rate meter components - 3 sprites
- [ ] Phase indicators - 3 icons
- [ ] Tote efficiency indicator - 3 states
- [ ] Stow ready indicator - 2 frames
- [ ] Lyon vision cone (debug) - 1 sprite

### **Effects** (4 sets, ~15 files)
- [ ] Blood decals - 5 variants
- [ ] Particle effects - 4 types
- [ ] Shadow overlay - 1 sprite
- [ ] Screen shake overlay - 3 frames

**TOTAL ESTIMATED:** ~115 sprite files

---

## 🎨 Delivery Format

### **Preferred Structure:**

```
assets/sprites/
├── characters/
│   ├── associate/
│   │   ├── char_associate_idle_01.png
│   │   ├── char_associate_idle_02.png
│   │   └── ...
│   ├── lyon/
│   │   ├── normal/
│   │   │   ├── char_lyon_patrol_walk_01.png
│   │   │   └── ...
│   │   └── demon/
│   │       ├── char_lyon_demon_idle_01.png
│   │       └── ...
│   └── stewie/
│       └── ...
├── environment/
│   ├── aisles/
│   ├── floors/
│   └── decals/
├── items/
│   ├── boxes/
│   └── totes/
├── ui/
│   ├── meters/
│   └── indicators/
└── vfx/
    ├── blood/
    └── particles/
```

### **Documentation:**

Each asset folder should include:
- `README.md` - Frame counts, animation speeds, usage notes
- `palette.png` - Color reference swatch
- `references.txt` - Any reference images used

---

## 🚀 Priority Tiers

### **Priority 1: MVP (Essential for gameplay)**
- Associate player character (5 sprites)
- Lyon normal form (9 sprites)
- Aisle segments (all variants + decals: ~15 sprites)
- Standard boxes (4 variants)
- Yellow tote (3 states)
- Rate meter UI (3 components)

**Total P1:** ~39 essential sprites

### **Priority 2: Core Experience**
- Lyon demon form (4 sprites)
- Possessed boxes (3 frames)
- Stewie tutorial (3 sprites)
- Blood decals (5 variants)
- Phase indicators (3 icons)
- Stow ready UI (2 frames)

**Total P2:** ~20 sprites

### **Priority 3: Polish**
- Equipment props (3 sprites)
- Floor tile variants (3 sprites)
- Particle effects (4 types)
- Shadow overlays (1 sprite)
- Screen shake effects (3 frames)
- Efficiency indicator UI (3 states)

**Total P3:** ~17 sprites

### **Priority 4: Debug/Optional**
- Vision cone visualization (1 sprite)
- Additional box variants
- Extra decal variations

---

## 📞 Questions for Artist

1. **Sprite sheets vs individual files?** (Preference for organization)
2. **Animation timing specifications needed?** (JSON metadata file?)
3. **Color palette locked or flexible?** (Can adjust based on mood)
4. **Reference images helpful?** (Real warehouse photos, corporate aesthetics)
5. **Delivery timeline?** (Batch delivery or all at once)

---

**Last Updated:** January 13, 2026  
**Status:** Ready for asset production  
**Estimated Total:** 115 sprite files across 24 asset sets
