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

You are Associate #44721, trapped in an infinite shift at a haunted fulfillment center. Pack possessed items into totes while navigating endless aisles and evading Lyon, your boss who transforms into a demon when your productivity drops.

---

## 🎯 Core Systems

### Dual-Screen Gameplay
- **Bottom Screen:** Physics-based item packing with "possessed" objects that expand and resist containment
- **Top Screen:** Auto-scrolling horror aisles with stealth mechanics and timing-based stowing
- **Unified Pressure:** The "Rate" stat connects both screens - poor performance in one affects the other

### The Rate System
Your efficiency percentage (0-100%) controls:
- Item possession frequency
- Lyon's AI state (Patrol → Audit → Demon)
- Environmental corruption (clean → bloody → eldritch)
- Game phase transitions

### Lyon AI
Four-state boss system:
- **DORMANT** (Tutorial)
- **PATROL** (Ambient threat)
- **AUDIT** (Direct inspection)
- **DEMON_PURSUIT** (Rate < 20%, constant drain)

---

## 🏗️ Development Pipeline

This project uses a **Guerrilla Development Pipeline** optimized for:
- **Mobile-first development** (Android primary platform)
- **AI-assisted workflows** (Claude, Gemini for code generation)
- **Godot-MCP integration** (Direct AI scene manipulation)
- **Modular architecture** (Signal-based system integration)

### The Vagrant Architect Framework
Based on the "Asymmetric Stack" methodology:
- **Gemini 2.5** → Heavy logic, architectural planning, massive context
- **Claude 4.5** → Code refinement, documentation, agent orchestration
- **Godot 4.3** → Mobile-optimized engine with native Android editor support

---

## 📁 Repository Structure

```
stowdie-infinite-shift/
├── README.md                          # This file
├── docs/
│   ├── GDD/                           # Game Design Documents
│   │   ├── 00_MANIFEST.md             # Master index
│   │   ├── 01_CORE_PILLARS.md         # Design philosophy
│   │   ├── 02_SYSTEMS_REFERENCE.md    # Technical specifications
│   │   ├── 03_ASSET_BIBLE.md          # Visual/audio guidelines
│   │   └── 04_NARRATIVE_CODEX.md      # Story and world-building
│   │
│   ├── AGENT_CONTEXTS/                # AI Agent System Prompts
│   │   ├── ORCHESTRATOR.md            # Master coordinator (Claude Haiku)
│   │   ├── ARCHITECT.md               # System designer (Gemini Pro)
│   │   ├── CODER.md                   # Implementation specialist
│   │   └── ARTISAN.md                 # Asset creator
│   │
│   ├── WORKORDERS/                    # Task delegation templates
│   │   └── TEMPLATE.md                # Standard work order format
│   │
│   └── BUILD_LOGS/                    # Development audit trail
│       └── STOW-AI-BUILD-001.md       # Top screen systems
│
├── engine/
│   └── godot_project/                 # Godot 4.3 project
│       ├── project.godot
│       ├── scenes/
│       ├── scripts/
│       ├── assets/
│       └── addons/
│
└── .github/
    └── workflows/                     # CI/CD automation
        └── gdd-validation.yml
```

---

## 🚀 Getting Started

### Prerequisites
- **Godot 4.3** (Mobile Renderer recommended)
- **Android device** with Godot Android Editor (optional but recommended)
- **Git** for version control
- **AI access** (Claude Pro / Gemini Advanced for development assistance)

### Clone the Repository
```bash
git clone https://github.com/Alphav00/stowdie-infinite-shift.git
cd stowdie-infinite-shift
```

---

## 📖 Documentation

The `docs/GDD/` directory contains the **Living GDD** - a version-controlled, machine-readable design document.

**Key files:**
- **00_MANIFEST.md** - Project overview and navigation
- **02_SYSTEMS_REFERENCE.md** - Complete technical specifications
- **BUILD_LOGS/** - Detailed implementation records

---

## 📊 Current Status

### ✅ Completed
- [x] Comprehensive Game Design Document (92 pages)
- [x] Core pixel art assets (characters, environment, items)
- [x] Dual SubViewport architecture
- [x] GameManager singleton with phase system
- [x] Lyon AI state machine (4 states)
- [x] Infinite aisle scrolling with object pooling

### 🚧 In Progress
- [ ] Physics item expansion mechanic
- [ ] Tote container collision scoring
- [ ] Swipe gesture integration
- [ ] Audio system implementation

---

## 🛠️ Development Tools

### Mobile-First Stack
- **Godot 4.3** - Primary engine
- **Termux** - Linux environment on Android
- **GitHub Mobile** - Repository management

### AI Integration
- **Claude 4.5 Sonnet** - Code generation, orchestration
- **Gemini 2.5 Pro** - Architectural design
- **Godot-MCP** - Direct AI scene manipulation

---

## 📄 License

**Proprietary** - All rights reserved. Commercial indie game project.

---

**"Your shift never ends. Stow or die."**
