# 📊 PROJECT STATUS - StowOrDie: Infinite Shift

**Last Updated:** January 13, 2026  
**Version:** v0.3.1-alpha  
**Development Phase:** Pre-Alpha / Prototype

---

## 🎯 Executive Summary

**StowOrDie: Infinite Shift** is in active pre-alpha development. Core technical architecture is complete, top-screen AI systems are implemented, and foundational assets exist. Bottom-screen packing mechanics and audio integration are the current blockers to vertical slice completion.

**Target Milestone:** Vertical slice playable demo by February 2026

---

## ✅ COMPLETED SYSTEMS

### Documentation & Planning
- [x] **Golden Standard GDD** (92 pages) - Complete game design specification
- [x] **GitHub Repository** - Source control with AI-assisted workflow
- [x] **Agent Contexts** - Specialized AI instruction sets (Implementer, Architect, Auditor, Scribe)
- [x] **Work Order System** - Structured task delegation framework

### Technical Architecture
- [x] **Dual SubViewport System** - Split-screen rendering (top/bottom 1080x960 each)
- [x] **GameManager Autoload** - Rate decay, phase transitions, score tracking
- [x] **Input Router** - Touch gesture detection (tap, swipe, drag with zone routing)
- [x] **Signal Architecture** - Loose coupling between all systems

### Top Screen (Horror/Navigation)
- [x] **Lyon AI State Machine** - 4 states (DORMANT → PATROL → AUDIT → DEMON)
- [x] **Infinite Aisle Spawner** - Object pooling, dynamic scroll speed
- [x] **Player Cart Controller** - Vertical movement, stow/hide mechanics
- [x] **Corruption System** - 3-level visual degradation (CLEAN → DIRTY → BLOODY)

### Assets (Pixel Art)
- [x] **Character Sprites**
  - Associate (32x64px, walk cycle)
  - Lyon Base (64x64px, patrol animation)
  - Lyon Demon (96x96px, demon form)
  - Stewie the Safety Rat (32x32px portrait)
- [x] **Environment Tiles**
  - Conveyor belt (clean/bloody variants)
  - Aisle backgrounds with 4 corruption stages
  - Floor tiles (64x32px isometric)
  - Shelving units (64x128px)
- [x] **UI Elements**
  - Rate meter mockups
  - Phase indicators

---

## 🚧 IN PROGRESS

### Bottom Screen (Puzzle/Packing)
- [ ] **Item Physics System** (BLOCKED)
  - RigidBody2D base class with drag-and-drop
  - Possession mechanic ("The Jive")
  - Expansion system with tap suppression
  - **Status:** Design complete, implementation queued

- [ ] **Tote Container** (BLOCKED)
  - Collision detection for item containment
  - Packing efficiency calculation
  - Full/ready state signaling
  - **Status:** Awaiting Item Physics

### Audio System
- [ ] **Dynamic Music Crossfading**
  - Normal phase: Bossa nova Muzak (120 BPM)
  - Demon Hour: Grindcore industrial (240 BPM)
  - **Status:** Audio files not yet created

- [ ] **SFX System**
  - 3D positional audio for Lyon
  - Scanner beeps (clean/cursed variants)
  - Item explosions, stow success/fail sounds
  - **Status:** Placeholder system exists, no audio files

---

## 🔲 PLANNED (Next 30 Days)

### Critical Path to Vertical Slice
1. **STOW-PHYS-002**: Bottom Screen Item Physics
   - Priority: CRITICAL
   - Estimate: 5-7 days
   - Blocker: None

2. **STOW-AUDIO-001**: Core Audio Integration
   - Priority: HIGH
   - Estimate: 3-4 days
   - Blocker: Need music/SFX assets

3. **STOW-VFX-001**: Corruption Shaders
   - Priority: MEDIUM
   - Estimate: 2-3 days
   - Blocker: None

4. **STOW-TUTORIAL-001**: Tutorial Sequence
   - Priority: HIGH
   - Estimate: 4-5 days
   - Blocker: Bottom screen must be functional

### Secondary Systems
- [ ] Score persistence (high score tracking)
- [ ] Mobile optimization pass (target 60fps stable)
- [ ] Haptic feedback integration
- [ ] Particle effects (possession, explosions, phase transitions)

---

## 📈 PROGRESS METRICS

### Lines of Code (GDScript)
- **Total:** ~1,200 lines
- **Top Screen:** ~800 lines (Lyon AI, Aisle System, Player Cart)
- **Autoloads:** ~400 lines (GameManager, InputRouter, AudioController stubs)

### Asset Count
- **Sprites:** 24 individual files
- **Animations:** 8 sprite sheets (multi-frame)
- **Scenes:** 12 .tscn files
- **Shaders:** 3 .gdshader files (placeholders)

### Documentation
- **GDD Pages:** 92
- **Agent Contexts:** 1 (Implementer complete, 3 pending)
- **Work Orders:** 1 template, 0 active tasks

---

## 🚨 CURRENT BLOCKERS

### 1. Bottom Screen Physics (CRITICAL)
**Impact:** Cannot test core gameplay loop  
**Resolution:** STOW-PHYS-002 work order (queued for immediate assignment)

### 2. Audio Assets (HIGH)
**Impact:** No sound/music in builds  
**Resolution:** Outsource or generate with AI tools (LMMS, ChipTone, Suno)

### 3. Mobile Device Testing (MEDIUM)
**Impact:** Performance unknown on real hardware  
**Resolution:** Export APK, test on Pixel 10 (can be done with partial features)

---

## 🎯 MILESTONE ROADMAP

### Milestone 1: Vertical Slice (Target: Feb 15, 2026)
**Definition:** 60-second gameplay loop demonstrating all core mechanics
**Requirements:**
- [x] Lyon AI patrols and audits
- [ ] Items can be packed into tote
- [ ] Possessed items expand and can be suppressed
- [ ] Stow action works on top screen
- [ ] Rate decays and phases transition
- [ ] Basic audio (at least 1 music track, 5 SFX)

**Completion:** 60% (6/10 requirements)

### Milestone 2: Alpha Build (Target: March 15, 2026)
**Definition:** Feature-complete, pre-polish
**Requirements:**
- [ ] All core systems implemented
- [ ] Full asset library (20+ items, 10+ environment variants)
- [ ] Tutorial sequence
- [ ] High score persistence
- [ ] 3 minutes of gameplay before inevitable death

### Milestone 3: Beta (Target: April 30, 2026)
**Definition:** Content-complete, optimization focus
**Requirements:**
- [ ] Stable 60fps on mid-range Android
- [ ] Full audio mix (music crossfading, all SFX)
- [ ] Particle effects and shaders
- [ ] Playtested with 20+ external users
- [ ] Bug fixes from alpha feedback

### Milestone 4: Release Candidate (Target: May 31, 2026)
**Definition:** Platform submission ready
**Requirements:**
- [ ] App store assets (icon, screenshots, trailer)
- [ ] Privacy policy & EULA
- [ ] Localization (English + 2 additional languages)
- [ ] APK signed for Google Play
- [ ] IPA signed for App Store

---

## 📊 DEVELOPMENT VELOCITY

### Week of Jan 6-12, 2026
- **Completed:** Lyon AI state machine, infinite scrolling
- **Lines of Code:** +800
- **Blockers Resolved:** Input routing architecture
- **Velocity:** HIGH (major systems completed)

### Week of Jan 13-19, 2026 (Current)
- **Focus:** Repository setup, bottom screen physics
- **Target LOC:** +400
- **Expected Blockers:** None
- **Velocity Target:** MEDIUM (foundational work)

---

## 🔍 TECHNICAL DEBT

### Known Issues
1. **Audio Controller** - Stub implementation, needs full system
2. **Memory Profiling** - Not yet tested on constrained devices
3. **Save System** - High scores not yet persisted
4. **Input Zones** - Hard-coded coordinates, need responsive scaling
5. **Lyon Pathfinding** - Uses simple line-of-sight, needs proper NavMesh

### Deferred Optimizations
- Object pooling for particles (not yet needed)
- Texture atlas generation (manual sprites work for now)
- Shader precompilation (no shader stutters observed yet)

---

## 💡 LESSONS LEARNED

### What's Working Well
- **AI-Assisted Development:** Claude 4.5 + GitHub integration is highly effective
- **Signal Architecture:** Loose coupling makes isolated testing easy
- **Mobile-First Design:** Constraints are forcing good architecture decisions
- **Pixel Art:** 16-bit aesthetic scales perfectly at 4x, looks crisp

### What Needs Improvement
- **Asset Pipeline:** Need standardized export process from Aseprite
- **Testing Workflow:** Should establish mobile CI/CD earlier
- **Documentation:** GDD is comprehensive but needs "quick reference" version
- **Scope Management:** Feature creep risk - need strict vertical slice focus

---

## 📞 TEAM & RESOURCES

### Core Team
- **Chi (@Alphav00)** - Solo developer, designer, project lead
- **Claude 4.5 Sonnet** - AI pair programmer (Implementer role)
- **Gemini 2.5 Pro** - AI architect (deep context analysis)

### Tools Stack
- **Engine:** Godot 4.3.0
- **Version Control:** GitHub with API integration
- **Primary IDE:** Godot Android Editor (Pixel 10) + external keyboard
- **Asset Tools:** Aseprite (pixel art), LMMS (audio), ChipTone (SFX)
- **AI Services:** Claude Pro, Gemini Advanced

### Budget
- **Development:** $0 (all free/open-source tools)
- **AI Subscriptions:** ~$40/month (Claude Pro + Gemini)
- **Asset Creation:** $0 (self-made or AI-generated)
- **Target ROI:** Mobile F2P with ethical monetization

---

## 🎮 PLAYABLE BUILD STATUS

### Current Build: v0.3.1-alpha
**Platforms:** None (not yet exported)  
**Playable:** ❌ No (core mechanics incomplete)  
**Next Build Target:** v0.4.0-alpha (Vertical Slice)  
**ETA:** February 15, 2026

### Build Checklist (for v0.4.0)
- [ ] Top screen fully functional (Lyon AI working)
- [ ] Bottom screen fully functional (item packing working)
- [ ] Rate decay system integrated
- [ ] At least 1 BGM track + 5 SFX
- [ ] Exportable as Android APK
- [ ] Runs at 30fps minimum on Pixel 10

---

**Status Document Version:** 1.0.0  
**Next Update:** January 20, 2026  
**Maintained By:** Chi (@Alphav00)
