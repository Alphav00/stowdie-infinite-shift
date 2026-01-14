# 🗺️ StowOrDie: Implementation Roadmap

**Generated:** January 13, 2026  
**Based On:** STOW-AI-BUILD-001 Specifications  
**Status:** Ready for Development

---

## 📋 Overview

This roadmap outlines the complete implementation sequence for **StowOrDie: Infinite Shift** based on the validated specifications in BUILD-001. All work orders are ready for delegation to AI agents (CODER, ARCHITECT, ARTISAN).

---

## 🎯 Phase 1: Foundation Systems (PRIORITY: HIGH)

These are the core singletons and systems that everything else depends on.

### **STOW-CORE-001-GAMEMANAGER** 
**Agent:** CODER  
**Dependencies:** None (foundational)  
**Blocks:** Everything  
**Estimated Lines:** ~200

**Purpose:** Implements the Rate system (0-100%), phase management (TUTORIAL/NORMAL/DEMON_HOUR), and global game state.

**Key Features:**
- Passive Rate decay (-2.0/sec in NORMAL)
- Phase transitions based on Rate thresholds
- Tote management (placeholder for bottom screen)
- Screen shake and alarm signals

**Acceptance Criteria:**
- Rate drains correctly with delta time
- Phase transitions at Rate < 20% and Rate > 45%
- All signals emit with typed parameters
- < 0.1ms per frame performance

**Status:** ⏳ PENDING

---

### **STOW-CORE-002-INPUT-ROUTER**
**Agent:** CODER  
**Dependencies:** None (foundational)  
**Blocks:** Player movement, all touch interactions  
**Estimated Lines:** ~180

**Purpose:** Detects and routes touch gestures (tap, swipe, drag) to appropriate screen zones.

**Key Features:**
- Tap detection (< 20px movement, < 0.3s duration)
- Swipe detection (> 50px, < 0.5s, velocity > 300px/s)
- Drag detection (held > 0.15s or slow movement)
- Zone awareness (TOP/BOTTOM screen split)

**Acceptance Criteria:**
- All gesture types detected correctly
- Works with mouse emulation (desktop testing)
- Multi-touch handled (first touch only)
- < 0.2ms per input event

**Status:** ⏳ PENDING

---

## 🎯 Phase 2: Top Screen Core (PRIORITY: HIGH)

These systems create the horror/stealth gameplay loop.

### **STOW-AI-001-LYON-STATE-MACHINE**
**Agent:** CODER  
**Dependencies:** GameManager  
**Blocks:** Lyon scene assembly  
**Estimated Lines:** ~380

**Purpose:** Implements Lyon's 4-state AI (DORMANT → PATROL → AUDIT → DEMON_PURSUIT).

**Key Features:**
- **PATROL:** Moves left at 120px/s, 8% random stare chance, 350px detection radius
- **AUDIT:** Locks for 4.5s, evaluates tote efficiency, applies Rate penalties
- **DEMON_PURSUIT:** Chase at 280px/s, constant -5 Rate/sec drain
- Player detection with vision cone (120° front-facing)

**Acceptance Criteria:**
- All 4 states functional with correct transitions
- Detection accurate (radius + cone check)
- Hidden players not detected
- Rate penalties apply correctly
- < 0.5ms per frame

**Status:** ⏳ PENDING

---

### **STOW-SYSTEMS-001-AISLE-SPAWNER**
**Agent:** CODER  
**Dependencies:** GameManager  
**Blocks:** TopScreen scene  
**Estimated Lines:** ~280 (spawner) + ~250 (aisle component)

**Purpose:** Infinite scrolling aisles with object pooling and corruption states.

**Key Features:**
- Rate-based scroll speed: lerp(180, 450, 1.0 - rate/100)
- Object pool of 6 aisles (spawn at 1200, despawn at -900)
- 3 corruption levels based on Rate (CLEAN/DIRTY/BLOODY)
- Horror spawn chances (5% normal, 35% demon hour)

**Acceptance Criteria:**
- Smooth infinite scrolling
- Pool recycling works correctly
- Corruption updates with Rate changes
- Blood decals and graffiti spawn correctly
- 60fps maintained with all aisles active

**Status:** ⏳ PENDING

---

### **STOW-CORE-003-PLAYER-CART**
**Agent:** CODER  
**Dependencies:** GameManager, InputRouter  
**Blocks:** TopScreen scene assembly  
**Estimated Lines:** ~300

**Purpose:** Player movement, stow mechanic, and hide mechanic for top screen.

**Key Features:**
- Vertical-only movement (250px/s, bounds 100-860)
- **Stow mechanic:** Swipe UP in zone when tote full
- **Hide mechanic:** Swipe DOWN near shelf, 2.5s duration, 1s cooldown
- Zone detection for correct stowing

**Acceptance Criteria:**
- Smooth touch-drag movement
- Successful stow clears tote and awards points
- Failed stow (wrong zone) applies -10 Rate penalty
- Hide mechanic makes player invisible to Lyon
- Signals emit correctly

**Status:** ⏳ PENDING

---

## 🎯 Phase 3: Visual Effects (PRIORITY: MEDIUM)

These shaders enhance the horror atmosphere.

### **STOW-VFX-001-SHADERS**
**Agent:** CODER  
**Dependencies:** None (standalone)  
**Blocks:** None (applied later)  
**Estimated Lines:** ~100 per shader

**Purpose:** Three custom shaders for horror effects.

**Shaders:**
1. **CRTGlitch.gdshader**
   - VHS tracking errors
   - Scanlines (240 lines default)
   - Chromatic aberration (increases with low Rate)
   - Distortion effects

2. **ShadowDistortion.gdshader**
   - Lyon demon form shadow effect
   - Sin wave distortion on edges
   - Wavering shadow effect

3. **PossessionGlow.gdshader**
   - Red pulsing outline for possessed items
   - Configurable pulse speed and intensity
   - Outline thickness adjustable

**Acceptance Criteria:**
- All shaders compile without errors
- < 1ms per frame per shader on mobile
- Uniforms work correctly
- Can apply via ShaderMaterial

**Status:** ⏳ PENDING

---

## 📊 Dependency Graph

```
STOW-CORE-001-GAMEMANAGER (Foundational)
    ↓
    ├─→ STOW-AI-001-LYON-STATE-MACHINE
    ├─→ STOW-SYSTEMS-001-AISLE-SPAWNER
    └─→ STOW-CORE-003-PLAYER-CART
         ↑
         └─ STOW-CORE-002-INPUT-ROUTER (Foundational)

STOW-VFX-001-SHADERS (Parallel, no dependencies)
```

---

## 🚀 Recommended Implementation Order

### **Week 1: Foundation**
1. **Day 1-2:** STOW-CORE-001-GAMEMANAGER
2. **Day 2-3:** STOW-CORE-002-INPUT-ROUTER
3. **Day 3-4:** Test integration between GameManager and InputRouter

### **Week 2: Top Screen Core**
4. **Day 5-7:** STOW-AI-001-LYON-STATE-MACHINE
5. **Day 8-10:** STOW-SYSTEMS-001-AISLE-SPAWNER
6. **Day 11-12:** STOW-CORE-003-PLAYER-CART
7. **Day 13-14:** Integration testing of all top screen systems

### **Week 3: Visual Polish**
8. **Day 15-17:** STOW-VFX-001-SHADERS (all three)
9. **Day 18-19:** Apply shaders to scenes
10. **Day 20-21:** Performance tuning and mobile testing

---

## 📦 Deliverables Summary

After completing all work orders:

### **Scripts** (7 files)
- `scripts/_Autoloads/GameManager.gd` ✅
- `scripts/_Autoloads/InputRouter.gd` ✅
- `scripts/AI/LyonStateMachine.gd` ✅
- `scripts/Systems/AisleSpawner.gd` ✅
- `scripts/Entities/Aisle.gd` ✅
- `scripts/Core/PlayerCart.gd` ✅

### **Shaders** (3 files)
- `assets/shaders/CRTGlitch.gdshader` ✅
- `assets/shaders/ShadowDistortion.gdshader` ✅
- `assets/shaders/PossessionGlow.gdshader` ✅

### **Total Implementation**
- **Lines of Code:** ~1,890
- **Work Orders:** 6
- **Estimated Time:** 3 weeks (with testing)

---

## ✅ Validation Criteria

All systems must pass:
- [ ] Gherkin acceptance scenarios
- [ ] Performance budgets (60fps on mid-range Android)
- [ ] Mobile touch input testing
- [ ] Signal-based integration (no hardcoded paths)
- [ ] Static typing throughout
- [ ] Memory limits (< 512MB peak)

---

## 🔄 After Phase 3

### **Next Phases** (Future Work Orders)
- **Phase 4:** Bottom screen physics (item expansion, tote scoring)
- **Phase 5:** Audio system (SFX pooling, music crossfading)
- **Phase 6:** Dual viewport integration
- **Phase 7:** Tutorial and Stewie NPC
- **Phase 8:** Menus and UI polish

---

## 📝 Work Order Access

All work orders available in:
- `/docs/WORKORDERS/STOW-*.md`

**Template:** `/docs/WORKORDERS/TEMPLATE.md`

---

## 🤖 AI Agent Workflow

### **To Start Implementation:**

1. **User selects work order:** "Implement STOW-CORE-001-GAMEMANAGER"
2. **ORCHESTRATOR assigns to CODER agent**
3. **CODER generates GDScript** following specifications
4. **Deliverable validated** against acceptance criteria
5. **BUILD_LOG updated** with implementation notes
6. **Commit to repository**

### **Commands:**
- "Implement GameManager" → Routes to STOW-CORE-001
- "Start with InputRouter" → Routes to STOW-CORE-002
- "Build Lyon AI" → Routes to STOW-AI-001

---

## 📊 Progress Tracking

| Work Order | Status | Agent | Priority |
|------------|--------|-------|----------|
| STOW-CORE-001-GAMEMANAGER | ⏳ PENDING | CODER | HIGH |
| STOW-CORE-002-INPUT-ROUTER | ⏳ PENDING | CODER | HIGH |
| STOW-AI-001-LYON-STATE-MACHINE | ⏳ PENDING | CODER | HIGH |
| STOW-SYSTEMS-001-AISLE-SPAWNER | ⏳ PENDING | CODER | HIGH |
| STOW-CORE-003-PLAYER-CART | ⏳ PENDING | CODER | HIGH |
| STOW-VFX-001-SHADERS | ⏳ PENDING | CODER | MEDIUM |

**Legend:**
- ⏳ PENDING - Not started
- 🚧 IN_PROGRESS - Active development
- ✅ COMPLETE - Validated and integrated
- 🔍 REVIEW - Awaiting validation

---

**Ready to start development!** 🚀

Choose any work order to begin implementation.
