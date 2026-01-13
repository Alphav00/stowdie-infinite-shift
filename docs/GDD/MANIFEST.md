# 📋 GDD MANIFEST - Living Document Tracker

**Project:** StowOrDie: Infinite Shift  
**Version:** 3.0.1  
**Last Updated:** January 13, 2026  
**Document Status:** ACTIVE - Living GDD

---

## 🎯 Purpose

This **MANIFEST** serves as the central hub for all Game Design Documents. It tracks document versions, maintains architectural decisions, and provides quick navigation to all design specifications.

---

## 📚 Core Documents

### 1. **MANIFEST.md** (This File)
**Status:** ✅ CURRENT  
**Purpose:** Central document tracker and navigation hub  
**Last Updated:** January 13, 2026  

### 2. **CORE_SYSTEMS.md**
**Status:** ✅ CURRENT  
**Purpose:** Deep-dive into all gameplay mechanics  
**Sections:**
- System 1: The "Jive" (Item Expansion Mechanic)
- System 2: Split-Screen Stow Action (Rhythm Mechanic)
- System 3: Lyon AI (Boss State Machine)
- System 4: Infinite Aisle Scrolling
- System 5: Rate Decay & Phase Transitions
- System 6: Input Handling (Touch Gestures)

### 3. **ASSET_LIBRARY.md**
**Status:** ✅ CURRENT  
**Purpose:** Visual and audio asset specifications  
**Sections:**
- Visual Style Guide
- Character Sprites (Associate, Lyon, Stewie)
- Environment Tiles (Conveyor, Aisles, Shelving)
- Item Catalog (Bonk Bat, Cursed Box, etc.)
- Audio Manifest (Music, SFX, Voice Lines)
- Shader Library (CRT Glitch, Possession Glow, Shadow Distortion)

### 4. **NARRATIVE_BIBLE.md**
**Status:** ✅ CURRENT  
**Purpose:** Story, characters, world-building  
**Sections:**
- World Truths (The Rate is God, The Warehouse is Infinite, VTO is a Lie)
- Plot Arc (Onboarding → The Grind → The Crunch)
- Character Profiles (The Associate, Lyon, Stewie Way)
- Environmental Storytelling (Graffiti, Blood Decals, Posters)
- Ending Conditions (No win state - only high scores)

---

## 🏗️ Technical Documents

### ARCHITECTURE.md
**Status:** ✅ CURRENT  
**Purpose:** Godot 4.3 project structure and system integration  
**Sections:**
- Dual SubViewport Configuration
- Signal-Based Architecture
- Autoload Singletons (GameManager, AudioController, InputRouter)
- Scene Hierarchy
- Performance Budgets (Frame budget, Memory budget)

### MOBILE_OPTIMIZATION.md
**Status:** 🚧 IN PROGRESS  
**Purpose:** Mobile-specific performance strategies  
**Sections:**
- Object Pooling for Physics Items
- Touch Input Gesture Detection
- Integer Scaling for Pixel Art (4x)
- Audio Polyphony Management
- Memory Profiling

---

## 🔧 Implementation Documents

### BUILD_PACKAGES.md
**Status:** ✅ CURRENT  
**Purpose:** Structured build package tracker  
**Completed Builds:**
- ✅ **STOW-AI-BUILD-001**: Top Screen AI & Environment (Lyon State Machine, Infinite Scrolling)

**Upcoming Builds:**
- 🔲 **STOW-AI-BUILD-002**: Bottom Screen Physics (Item Expansion, Tote Packing)
- 🔲 **STOW-AUDIO-001**: Dynamic Audio System (Music Crossfading, SFX Pooling)
- 🔲 **STOW-VFX-001**: Corruption Shaders & Particle Effects
- 🔲 **STOW-POLISH-001**: Mobile Optimization Pass

---

## 📊 Version History

### v3.0.1 (January 13, 2026) - CURRENT
- ✅ Complete Golden Standard GDD (92 pages)
- ✅ Lyon AI State Machine implemented
- ✅ Infinite Aisle Scrolling with object pooling
- ✅ GameManager autoload (Rate, Phase transitions)
- ✅ Pixel art assets (Associate, Lyon, Stewie, Items, Environment)
- ✅ Mobile input handling (gesture detection)

### v2.5.0 (December 2025)
- ✅ Initial technical architecture design
- ✅ Dual SubViewport system specification
- ✅ Core mechanics documentation

### v2.0.0 (November 2025)
- ✅ High concept finalized ("Tetris meets Alien: Isolation")
- ✅ Art direction locked (Corporate Decay Pixel Art)
- ✅ Thematic core defined (Efficiency metrics as horror)

### v1.0.0 (October 2025)
- ✅ Project inception
- ✅ Prototype design sketches

---

## 🎯 Design Pillars

### 1. Bicameral Panic (Mechanics)
Cognitive overload through asymmetric dual-screen gameplay. Bottom screen demands spatial reasoning (Tetris packing), top screen demands pattern recognition (Lyon patrol avoidance). Failure in one domain cascades into the other.

### 2. Silly Horror (Aesthetics)
Tonal whiplash between twee corporate absurdism and body horror. Items have googly eyes while the warehouse walls bleed. The emotional core is nervous laughter mixed with palm-sweating dread.

### 3. Tactile Jank (Dynamics)
Possessed items actively resist containment through emergent physics chaos. Players experience simulated workplace incompetence - the game feels unfair in the same way bad jobs feel unfair.

---

## 🔗 Navigation

### By System Type
- **Gameplay Mechanics** → [CORE_SYSTEMS.md](CORE_SYSTEMS.md)
- **Visual/Audio Assets** → [ASSET_LIBRARY.md](ASSET_LIBRARY.md)
- **Story & Characters** → [NARRATIVE_BIBLE.md](NARRATIVE_BIBLE.md)
- **Technical Architecture** → [ARCHITECTURE.md](ARCHITECTURE.md)

### By Development Phase
- **Current Implementation** → [BUILD_PACKAGES.md](BUILD_PACKAGES.md)
- **Work Orders** → [../WORKORDERS/](../WORKORDERS/)
- **Agent Contexts** → [../AGENT_CONTEXTS/](../AGENT_CONTEXTS/)

---

## 📝 Document Conventions

### Status Indicators
- ✅ **CURRENT** - Document is up-to-date and reflects implemented systems
- 🚧 **IN PROGRESS** - Document is being actively updated
- 🔲 **PLANNED** - Document is queued for creation
- ⚠️ **DEPRECATED** - Document has been superseded

### File Naming
- Use `SCREAMING_SNAKE_CASE.md` for all GDD files
- Prefix with category (e.g., `SYSTEM_`, `ASSET_`, `NARRATIVE_`)
- Keep names concise but descriptive

### Update Protocol
When modifying any GDD document:
1. Update the document content
2. Update version number in document header
3. Update "Last Updated" timestamp
4. Add entry to this MANIFEST under "Version History"
5. Commit with descriptive message: `[GDD] Update SYSTEM_X with Y changes`

---

## 🚨 Critical Decisions Log

### Architectural Decisions
| Date | Decision | Rationale |
|------|----------|-----------|
| 2025-12-10 | Godot 4.3 (not Unity) | Native Android editor, open-source, mobile-first |
| 2025-12-15 | Dual SubViewport (not TabContainer) | True simultaneous rendering, no tab switching |
| 2025-12-20 | Signal-based architecture (not direct calls) | Loose coupling, easier AI-assisted development |
| 2026-01-05 | Object pooling for aisles | Mobile memory constraints (512MB budget) |

### Design Decisions
| Date | Decision | Rationale |
|------|----------|-----------|
| 2025-11-20 | No win condition | Horror is about inevitability, not victory |
| 2025-12-01 | Rate as core mechanic | Unified theme - metrics warp reality |
| 2025-12-08 | Lyon transforms (not separate boss) | Narrative continuity, resource efficiency |
| 2026-01-02 | Portrait orientation (not landscape) | Mobile ergonomics, dual-screen stacking |

---

## 🔄 Living Document Philosophy

This GDD is **LIVING** - it evolves with the project. Changes are expected and encouraged when:
- Playtesting reveals design flaws
- Technical constraints require adaptation
- New creative insights emerge
- AI-assisted development suggests improvements

**The MANIFEST is the map. The game is the territory. When they diverge, update the map.**

---

**Document Version:** 3.0.1  
**Maintainer:** Chi (@Alphav00)  
**Next Review Date:** Weekly (every Monday)

---

**END OF MANIFEST**
