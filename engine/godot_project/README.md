# 🎮 StowOrDie: Godot Project

**Engine:** Godot 4.3.0  
**Renderer:** Mobile (Forward+)  
**Target:** Android 10+, iOS 15+  
**Resolution:** 1080x1920 (Portrait)

---

## 📁 Directory Structure

```
godot_project/
├── project.godot              # Engine configuration (mobile-first)
├── icon.svg                   # Project icon
│
├── scenes/                    # All .tscn scene files
│   ├── MainGame.tscn          # Root scene with dual SubViewports
│   ├── TopScreen/             # Top screen (horror/stealth)
│   ├── BottomScreen/          # Bottom screen (physics/packing)
│   ├── UI/                    # HUD, menus, dialogs
│   └── Entities/              # Prefabs
│       ├── Characters/        # Player, Lyon, Stewie
│       ├── Environment/       # Aisles, shelves, props
│       └── Items/             # Boxes, possessed items
│
├── scripts/                   # All .gd script files
│   ├── _Autoloads/            # Singleton systems
│   │   ├── GameManager.gd     # Rate, phases, scoring
│   │   ├── InputRouter.gd     # Touch gesture handling
│   │   └── AudioController.gd # SFX and music
│   ├── Core/                  # Core mechanics
│   ├── AI/                    # Lyon state machine, pathfinding
│   ├── Systems/               # Spawners, scrolling, corruption
│   └── Entities/              # Component scripts for scenes
│
└── assets/                    # All non-code resources
    ├── sprites/               # Pixel art (.png)
    ├── audio/                 # Music (.ogg) and SFX (.wav)
    ├── shaders/               # Custom .gdshader files
    └── fonts/                 # UI fonts
```

---

## 🚀 Quick Start

### Open in Godot Desktop
```bash
godot --path engine/godot_project
```

### Open in Godot Android Editor
1. Open Godot Android Editor app
2. Tap "Import Project"
3. Navigate to `stowdie-infinite-shift/engine/godot_project/`
4. Tap `project.godot`

---

## ⚙️ Project Configuration

### Display Settings
- **Viewport:** 1080x1920 (9:16 aspect ratio)
- **Mode:** Fullscreen (mode 3)
- **Stretch:** Viewport with expand aspect
- **Orientation:** Portrait only

### Rendering
- **Method:** Mobile (Forward+)
- **Texture Filter:** Nearest (pixel-perfect)
- **MSAA:** Disabled (performance)
- **2D Snap:** Enabled (pixel alignment)

### Physics
- **Engine:** GodotPhysics2D
- **Tick Rate:** 60 Hz (fixed timestep)
- **Gravity:** 980 (standard)

### Input
- **Touch Emulation:** Mouse → Touch enabled
- **Reverse Emulation:** Disabled (pure touch on mobile)

---

## 🎯 Autoloads (Singletons)

| Name | Path | Purpose |
|------|------|---------|
| **GameManager** | `_Autoloads/GameManager.gd` | Rate system, phase management, scoring |
| **InputRouter** | `_Autoloads/InputRouter.gd` | Global touch gesture detection |
| **AudioController** | `_Autoloads/AudioController.gd` | SFX pooling, music crossfading |

Access via: `/root/GameManager`, `/root/InputRouter`, etc.

---

## 🏷️ Physics Layers

| Layer | Name | Purpose |
|-------|------|---------|
| 1 | Player | Player cart collision |
| 2 | Items | Packable items (boxes, possessed objects) |
| 3 | Environment | Aisles, shelves, walls |
| 4 | Lyon | Boss character collision |
| 5 | Tote | Container boundaries |
| 6 | HideSpots | Player hiding zones |

---

## 📦 Asset Organization

### Sprites
- **Resolution:** 16-bit base (4x integer scaling)
- **Format:** PNG with transparency
- **Naming:** `{category}_{name}_{state}.png`
  - Example: `char_lyon_patrol_01.png`

### Audio
- **Music:** OGG Vorbis, loopable, 120/240 BPM
- **SFX:** WAV, 44.1kHz, mono preferred
- **Naming:** `{type}_{action}.{ext}`
  - Example: `sfx_item_stow.wav`

### Shaders
- **Format:** `.gdshader` (Godot 4.x)
- **Naming:** `{Effect}Shader.gdshader`
  - Example: `CRTGlitch.gdshader`

---

## 🧪 Testing

### Performance Budget
- **Target:** 60 FPS sustained
- **Frame Time:** < 16.67ms
- **Memory:** 512MB peak, 256MB baseline

### Test on Device
```bash
# Export debug APK
godot --headless --export-debug "Android" build/StowOrDie_Debug.apk

# Install and run
adb install build/StowOrDie_Debug.apk
adb shell am start -n com.alphav00.stowdie/.GodotApp
```

---

## 📋 Current Implementation Status

Based on **STOW-AI-BUILD-001** (see `/docs/BUILD_LOGS/`):

### ✅ Implemented Systems
- [x] Lyon AI State Machine
- [x] Infinite Aisle Scrolling
- [x] Player Cart Movement
- [x] Input Router (Touch Gestures)
- [x] Custom Shaders (CRT, Possession, Shadow)

### 🚧 In Progress
- [ ] Physics Item Expansion
- [ ] Tote Container System
- [ ] Audio System Integration

### ⏳ Planned
- [ ] Tutorial Sequence
- [ ] Stewie NPC
- [ ] High Score Persistence

---

## 🔗 Related Documentation

- **BUILD_LOGS:** See `/docs/BUILD_LOGS/STOW-AI-BUILD-001.md` for detailed specs
- **Work Orders:** Check `/docs/WORKORDERS/` for active tasks
- **GDD Manifest:** Reference `/docs/GDD/00_MANIFEST.md` for navigation

---

## ⚠️ Important Notes

1. **Never hardcode paths** - Use groups: `get_tree().get_first_node_in_group("player")`
2. **Always use static typing** - `var health: float = 100.0`
3. **Signal-based architecture** - Connect systems via signals, not direct calls
4. **Mobile-first** - Test all input with touch, not mouse
5. **Performance matters** - Profile regularly, stay within budgets

---

**Last Updated:** January 13, 2026  
**Based On:** STOW-AI-BUILD-001 (Top Screen Systems)
