# 📂 Godot Project Structure

**Complete directory tree for StowOrDie: Infinite Shift**

---

## 🎯 Root Files

```
godot_project/
├── project.godot          # Engine configuration ✅
├── icon.svg               # Project icon ✅
├── README.md              # This directory's documentation ✅
└── STRUCTURE.md           # This file
```

---

## 🎬 Scenes Directory

```
scenes/
├── MainGame.tscn          # Root scene (dual SubViewports) ⏳
│
├── TopScreen/             # Horror/stealth gameplay
│   ├── TopScreen.tscn     # Top viewport container ⏳
│   └── TopHUD.tscn        # Rate meter, hiding indicator ⏳
│
├── BottomScreen/          # Physics/packing gameplay
│   ├── BottomScreen.tscn  # Bottom viewport container ⏳
│   ├── ToteContainer.tscn # Physics container ⏳
│   └── BottomHUD.tscn     # Item queue, efficiency meter ⏳
│
├── UI/                    # Menus and overlays
│   ├── MainMenu.tscn      # Title screen ⏳
│   ├── PauseMenu.tscn     # Pause overlay ⏳
│   ├── GameOver.tscn      # Game over screen ⏳
│   └── Tutorial.tscn      # Tutorial overlay ⏳
│
└── Entities/              # Reusable prefabs
    ├── Characters/
    │   ├── PlayerCart.tscn      # Top screen player ✅ (BUILD-001)
    │   ├── LyonAI.tscn          # Boss character ✅ (BUILD-001)
    │   └── Stewie.tscn          # Tutorial rat ⏳
    │
    ├── Environment/
    │   ├── Aisle.tscn           # Scrolling aisle segment ✅ (BUILD-001)
    │   ├── Shelf.tscn           # Individual shelf unit ⏳
    │   └── StowZone.tscn        # Stow detection area ⏳
    │
    └── Items/
        ├── BoxStandard.tscn     # Normal box ⏳
        ├── BoxPossessed.tscn    # Expanding box ⏳
        └── ItemPickup.tscn      # Collectible items ⏳
```

---

## 💻 Scripts Directory

```
scripts/
├── _Autoloads/            # Singletons (registered in project.godot)
│   ├── GameManager.gd     # Rate, phases, scoring ✅ (Specified in BUILD-001)
│   ├── InputRouter.gd     # Touch gestures ✅ (BUILD-001)
│   └── AudioController.gd # SFX/music manager ✅ (Specified in BUILD-001)
│
├── Core/                  # Core game mechanics
│   ├── PlayerCart.gd      # Top screen movement ✅ (BUILD-001)
│   ├── ItemPhysics.gd     # Expansion mechanic ⏳
│   └── ToteScoring.gd     # Collision evaluation ⏳
│
├── AI/                    # NPC behavior
│   ├── LyonStateMachine.gd  # 4-state boss AI ✅ (BUILD-001)
│   └── StewieController.gd  # Tutorial rat behavior ⏳
│
├── Systems/               # Environment systems
│   ├── AisleSpawner.gd    # Infinite scrolling ✅ (BUILD-001)
│   ├── CorruptionManager.gd # Visual degradation ⏳
│   └── ItemSpawner.gd     # Bottom screen item queue ⏳
│
└── Entities/              # Component scripts
    ├── Aisle.gd           # Individual aisle logic ✅ (BUILD-001)
    └── HideSpot.gd        # Player hiding zones ⏳
```

---

## 🎨 Assets Directory

```
assets/
├── sprites/               # Pixel art (PNG)
│   ├── characters/        # Player, Lyon, Stewie sprites
│   ├── items/             # Boxes, possessed items
│   ├── environment/       # Aisles, shelves, floor tiles
│   └── ui/                # HUD elements, buttons
│
├── audio/                 # Sound and music
│   ├── music/             # Phase-based tracks (OGG)
│   └── sfx/               # Sound effects (WAV)
│
├── shaders/               # Custom shaders (GDSHADER)
│   ├── CRTGlitch.gdshader        # VHS effect ✅ (BUILD-001)
│   ├── ShadowDistortion.gdshader # Lyon demon form ✅ (BUILD-001)
│   └── PossessionGlow.gdshader   # Red outline ✅ (BUILD-001)
│
└── fonts/                 # UI typography
    └── main_font.ttf      # Monospace UI font ⏳
```

---

## 📊 Status Legend

| Symbol | Meaning |
|--------|---------|
| ✅ | Implemented (see BUILD_LOGS) |
| ⏳ | Planned (not yet built) |
| 🚧 | In Progress (active work order) |

---

## 🔗 Implementation References

Files marked ✅ are documented in:
- **STOW-AI-BUILD-001.md** - Top screen systems (Lyon AI, Aisle scrolling, Player cart, Input router, Shaders)

Future implementations will be tracked in:
- **STOW-AI-BUILD-002.md** - Bottom screen physics
- **STOW-AI-BUILD-003.md** - Dual viewport integration
- **STOW-AI-BUILD-004.md** - Audio system
- **STOW-AI-BUILD-005.md** - Tutorial and Stewie

---

## 🎯 Quick Navigation

**To find a system:**
1. Check this file for its location
2. Reference `/docs/BUILD_LOGS/` for implementation details
3. Check `/docs/WORKORDERS/` for active development

**To add a new system:**
1. Create work order using `/docs/WORKORDERS/TEMPLATE.md`
2. Implement in appropriate directory
3. Document in new BUILD_LOG
4. Update this STRUCTURE.md with ✅ status

---

**Last Updated:** January 13, 2026  
**Based On:** STOW-AI-BUILD-001 (Top Screen Systems)
