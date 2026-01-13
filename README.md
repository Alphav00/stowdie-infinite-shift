# 🎮 StowOrDie: Infinite Shift

**"Tetris meets Alien: Isolation in an endless, haunted Amazon fulfillment center"**

[![Godot 4.3](https://img.shields.io/badge/Godot-4.3-blue.svg)](https://godotengine.org/)
[![Platform](https://img.shields.io/badge/Platform-Mobile%20%7C%20Android%20%7C%20iOS-green.svg)]()
[![Development](https://img.shields.io/badge/Status-In%20Development-yellow.svg)]()

---

## 📋 Overview

**StowOrDie: Infinite Shift** is a mobile indie horror game combining:
- 📦 **Tetris-style packing mechanics** (bottom screen)
- 👁️ **Alien: Isolation survival horror** (top screen)
- 🏭 **Workplace anxiety as game mechanic** (efficiency metrics warp reality)
- 🎨 **"Silly Horror" aesthetic** (corporate pastels → body horror)

### The Premise

You are Associate #44721, trapped in an infinite shift at a haunted fulfillment center. Pack items into totes while navigating endless aisles, avoiding your demonic boss Lyon, and maintaining your Rate above 0%.

**The Rate is God. Drop below 20% and Lyon transforms into a reality-warping demon.**

---

## 🎯 Core Systems

### Dual Screen Architecture
- **Bottom Screen (Puzzle)**: Drag-and-drop Tetris-style packing with possessed items
- **Top Screen (Horror)**: Auto-scrolling aisles with Lyon AI patrol/pursuit

### The "Jive" Mechanic
Possessed items actively expand and fight back. Players must **tap to suppress** expansion before items explode and trigger alarms.

### Lyon AI State Machine
```
DORMANT → PATROL → AUDIT → DEMON_PURSUIT
```
- **Patrol**: Random pauses to stare at player
- **Audit**: Evaluates tote efficiency, penalizes poor packing
- **Demon Mode**: Constant Rate drain, relentless pursuit (triggers at Rate < 20%)

### Phase System
1. **Tutorial** (Rate 100-80%): Clean corporate aesthetic
2. **Normal** (Rate 80-20%): Gradual corruption, items start possessing
3. **Demon Hour** (Rate < 20%): Full horror mode, Lyon transforms

---

## 🛠️ Development Pipeline

### The "Guerrilla Stack"
- **Engine**: Godot 4.3 (Mobile Renderer, Forward+)
- **Platform**: Android 10+ / iOS 15+ (Portrait, 1080x1920)
- **Primary Development**: Mobile-first (Pixel 10 + external keyboard)
- **AI-Assisted**: Claude 4.5 + Gemini 2.5 for code generation
- **Version Control**: GitHub with direct API integration

### Mobile-First Constraints
- Target: 60fps on mid-range Android (512MB memory budget)
- Input: Touch gestures only (swipe, tap, drag)
- Assets: 16-bit pixel art (4x integer scaling)
- Audio: 32 polyphony max, OGG Vorbis compression

---

## 📁 Repository Structure

```
stowdie-infinite-shift/
├── docs/
│   ├── GDD/                     # Game Design Documents
│   │   ├── MANIFEST.md          # Master document tracker
│   │   ├── CORE_SYSTEMS.md      # Mechanics deep-dive
│   │   ├── ASSET_LIBRARY.md     # Visual/audio specifications
│   │   └── NARRATIVE_BIBLE.md   # Story, characters, world-building
│   ├── AGENT_CONTEXTS/          # AI agent instruction sets
│   │   ├── ARCHITECT.md         # System design specialist
│   │   ├── IMPLEMENTER.md       # Code generation specialist
│   │   ├── AUDITOR.md           # QA and validation specialist
│   │   └── SCRIBE.md            # Documentation specialist
│   └── WORKORDERS/              # Structured task assignments
│       └── TEMPLATE.md          # Standard work order format
├── engine/
│   └── godot_project/           # Godot 4.3 project files
│       ├── scenes/
│       ├── scripts/
│       ├── assets/
│       └── project.godot
├── assets/
│   ├── sprites/                 # Pixel art (16-bit indexed)
│   ├── audio/                   # SFX and music (OGG)
│   └── shaders/                 # Custom GLSL shaders
└── .github/
    └── workflows/               # CI/CD automation
```

---

## 🚀 Getting Started

### Prerequisites
- Godot 4.3+ (or Godot Android Editor)
- Git with GitHub authentication
- (Optional) External keyboard + mouse for mobile dev

### Clone Repository
```bash
git clone https://github.com/Alphav00/stowdie-infinite-shift.git
cd stowdie-infinite-shift
```

### Open in Godot
```bash
cd engine/godot_project
godot project.godot
```

### Mobile Development Setup
1. Install [Godot Android Editor](https://godotengine.org/download/android/) on device
2. Clone repo via Termux or GitHub mobile app
3. Open `engine/godot_project/project.godot` in Godot Android

---

## 📚 Documentation

### Game Design Documents
- **[GDD Manifest](docs/GDD/MANIFEST.md)** - Central document tracker (Living GDD)
- **[Core Systems](docs/GDD/CORE_SYSTEMS.md)** - Detailed mechanics specifications
- **[Asset Library](docs/GDD/ASSET_LIBRARY.md)** - Visual and audio asset specifications
- **[Narrative Bible](docs/GDD/NARRATIVE_BIBLE.md)** - Story, characters, world-building

### AI Agent Contexts
Specialized instruction sets for AI-assisted development:
- **[Architect](docs/AGENT_CONTEXTS/ARCHITECT.md)** - System architecture and design patterns
- **[Implementer](docs/AGENT_CONTEXTS/IMPLEMENTER.md)** - GDScript code generation
- **[Auditor](docs/AGENT_CONTEXTS/AUDITOR.md)** - Code review and validation
- **[Scribe](docs/AGENT_CONTEXTS/SCRIBE.md)** - Documentation and technical writing

---

## 🤖 AI-Assisted Workflow

This project uses the **"Vagrant Architect × Crystalline Lattice"** methodology:

### Development Modes
- **MODE A: Field Command** (Mobile) - Voice dictation → AI sanitization → Code generation
- **MODE B: Ping-Pong** - Gemini for structure, Claude for implementation
- **MODE C: Chronos Sync** - Automated CI/CD with GitHub Actions
- **MODE D: Self-Heal** - Error-driven prompt mutation and learning

### Work Order System
All tasks are routed through structured work orders (`docs/WORKORDERS/`) containing:
- Agent role assignment
- Signal packet (required context)
- Acceptance criteria (Gherkin scenarios)
- Integration dependencies

See [TEMPLATE.md](docs/WORKORDERS/TEMPLATE.md) for the standard format.

---

## 📊 Current Status

### ✅ Completed
- [x] Comprehensive Game Design Document (92 pages)
- [x] Core pixel art assets (characters, items, environment tiles)
- [x] Technical architecture (dual SubViewport system)
- [x] GameManager with Rate/Phase systems
- [x] Lyon AI state machine (DORMANT → PATROL → AUDIT → DEMON)
- [x] Infinite aisle scrolling with object pooling
- [x] Mobile input handling (gesture detection)

### 🚧 In Progress
- [ ] Bottom screen packing mechanics
- [ ] Item possession system ("The Jive")
- [ ] Visual corruption shaders
- [ ] Audio system integration
- [ ] Tutorial sequence

### 📋 Roadmap
1. **STOW-AI-BUILD-002**: Bottom screen physics prototype
2. **STOW-AUDIO-001**: Dynamic music crossfading system
3. **STOW-VFX-001**: Corruption shaders and particle effects
4. **STOW-POLISH-001**: Mobile optimization pass
5. **STOW-RELEASE-001**: Platform submission preparation

---

## 🎨 Art Style

**"Corporate Decay Pixel Art"**
- Base resolution: 16px sprites (4x scaled to 64px display)
- Palette: Hyper-saturated corporate colors → desaturated horror
- Animation: 3-4 frame cycles (walk, idle, expansion)
- Corruption stages: Clean → Dirty → Bloody

### Visual Progression
```
Phase 1: Safety-vest orange, motivational posters, Comic Sans
Phase 2: Sickly greens, blood decals, Lyon's mug grows teeth
Phase 3: Glitch art, meat textures, barcodes reading "HELP ME"
```

---

## 🔊 Audio Design

**Musical Concept:** Bossa nova Muzak → grindcore industrial

- **Shift Start** (Normal Phase): Elevator music, 120 BPM, light percussion
- **Demon Hour**: Bossa nova samples reversed, blast beats, 240 BPM
- **SFX**: Scanner beeps, Lyon roars, item explosions, whispered dialogue

---

## 🎯 Design Pillars

1. **Bicameral Panic** - Cognitive overload through dual-screen asymmetry
2. **Silly Horror** - Tonal whiplash between corporate absurdism and body horror
3. **Tactile Jank** - Physics chaos mirrors workplace frustration

### Thematic Core
**"Efficiency metrics as reality-warping force"** - The game's horror emerges from the psychological truth that modern labor systems demand impossible productivity, then punish workers when reality can't keep up.

---

## 🤝 Contributing

This is a personal indie project, but feedback and suggestions are welcome!

### Reporting Issues
- Use GitHub Issues for bugs or design feedback
- Include: Device model, OS version, steps to reproduce

### Code Style
- GDScript with static typing (`var name: Type`)
- 80-character line limit (mobile readability)
- Signal-based architecture (no direct function calls across systems)

---

## 📄 License

**Proprietary** - All rights reserved. This is a commercial indie game project.

Source code is shared for educational/portfolio purposes but not licensed for reuse.

---

## 👤 Creator

**Chi (@Alphav00)**
- Mobile-first indie developer
- AI-assisted development advocate
- "Guerrilla Pipeline" methodology pioneer

---

## 🔗 Links

- **GitHub**: [github.com/Alphav00/stowdie-infinite-shift](https://github.com/Alphav00/stowdie-infinite-shift)
- **Documentation**: [Full GDD](docs/GDD/MANIFEST.md)
- **Development Log**: [Work Orders](docs/WORKORDERS/)

---

**"The Rate is God. Stow or Die."** 📦💀
