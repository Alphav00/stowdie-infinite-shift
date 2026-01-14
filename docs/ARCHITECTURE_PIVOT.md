# 🔄 Architecture Pivot Notice

**Date:** January 13, 2026  
**Decision:** Pivot from 2D Dual-Viewport to 3D Isometric Single-Screen  
**Status:** ACTIVE DIRECTION

---

## 📋 Executive Summary

StowOrDie: Infinite Shift is pivoting from the BUILD-001 architecture (2D dual split-screen) to a new **3D isometric single-screen** approach with Mode 7-style aesthetics and physics-based "swipe to stow" mechanics.

---

## 🔀 Architectural Comparison

### OLD (BUILD-001 - Legacy)
```
┌─────────────────────────────────┐
│   TOP SCREEN (2D Horror)        │
│   - Scrolling aisles (2D)       │
│   - Lyon AI patrol              │
│   - Swipe up in zone to stow    │
│                                  │
├─────────────────────────────────┤
│   BOTTOM SCREEN (2D Physics)    │
│   - Tetris-style tote packing   │
│   - Item expansion mechanics    │
│   - Tap to suppress             │
└─────────────────────────────────┘

Architecture:
- Dual SubViewports (960px each)
- 2D navigation on both screens
- Split attention gameplay
- Rate system (productivity %)
```

### NEW (CORE Systems - Current)
```
┌─────────────────────────────────┐
│   SINGLE SCREEN (3D Isometric)  │
│                                  │
│   ┌───────────┐                 │
│   │   LYON    │   GOD ANGLE     │
│   └───────────┘   (26.565°)     │
│                                  │
│   ╔═══════════╗   MODE 7        │
│   ║ CONVEYOR  ║   SCROLLING     │
│   ║  [ITEMS]  ║                 │
│   ╚═══════════╝                 │
│                                  │
│       (YOU)                      │
│   Swipe ↗ to throw tote          │
└─────────────────────────────────┘

Architecture:
- Single 3D isometric viewport
- Mode 7-style floor scrolling
- Physics-based tote projectiles
- Anxiety system (psychological %)
```

---

## 🎯 Key System Changes

| System | BUILD-001 (Legacy) | CORE (Current) |
|--------|-------------------|----------------|
| **Camera** | Dual 2D SubViewports | Single IsometricCamera3D (26.565° God Angle) |
| **Items** | Physics boxes in tote (bottom screen) | ConveyorItem on conveyor belt (3D) |
| **Stowing** | Swipe up in zone (simple timing) | ToteProjectile with 2:1 slope physics |
| **Pressure** | GameManager → Rate (0-100%) | AnxietyManager → Anxiety (0-100%) |
| **Scrolling** | Infinite aisles (2D horizontal) | Mode 7 floor (3D perspective) |
| **Lyon** | Top screen patrol + audit | 3D model with proximity threat |

---

## 🏗️ New Core Systems (STOW-CORE-001 through 004)

### 1. IsometricCamera3D (CORE-001)
**Purpose:** Lock viewport to "God Angle" with Mode 7 scrolling

**Key Features:**
- 26.565° X rotation (dimetric projection)
- 45° Y rotation (isometric diamond)
- Orthogonal projection (pixel-perfect)
- Smooth player follow on X-axis
- Infinite scrolling floor illusion

**Replaces:** TopScreen viewport + AisleSpawner (BUILD-001)

---

### 2. ConveyorSystem (CORE-002)
**Purpose:** Spawn items on endless conveyor, manage movement toward player

**Key Features:**
- Object pooling (10 items max)
- Spawn rate scales with anxiety
- Item speed scales with anxiety
- Belt texture scrolls in sync
- Despawn at player zone if not stowed

**Replaces:** Item spawning on bottom screen (BUILD-001)

---

### 3. ToteProjectile (CORE-003)
**Purpose:** Physics-based "swipe to stow" with 2:1 slope trajectory

**Key Features:**
- Parabolic arc (gravity-affected)
- 2:1 slope (2 forward : 1 up)
- Linear shadow (visual cheat)
- Timing windows (Perfect/Good/Miss)
- 0.5s cooldown

**Replaces:** Simple "swipe up in zone" from BUILD-001

---

### 4. AnxietyManager (CORE-004)
**Purpose:** Global state manager with anxiety-based phase system

**Key Features:**
- Anxiety 0-100% (replaces Rate)
- Three phases: SAFE (>60%), WARN (20-60%), DEMON_HOUR (<20%)
- Passive drain: -2%, -3%, -5% per phase
- Stow scoring: Perfect +15%, Good +10%
- Game over at 0%

**Replaces:** GameManager from BUILD-001

---

## 🎮 Gameplay Flow Comparison

### OLD Flow (BUILD-001)
```
1. Items spawn on conveyor (bottom screen)
2. Tap to suppress expansion
3. Pack into tote (Tetris-style)
4. Swipe up when tote full
5. Navigate aisles (top screen)
6. Swipe up in correct aisle zone
7. Rate increases on success
```

### NEW Flow (CORE Systems)
```
1. Items spawn on conveyor (3D belt)
2. Items move toward player
3. Player swipes up when item in range
4. Tote projectile follows 2:1 slope arc
5. Item captured if timing correct
6. Anxiety increases on success
7. Repeat - items never stop coming
```

**Key Difference:** Single unified mechanic (swipe to throw) instead of split attention across two screens.

---

## 📊 Why This Pivot?

### Problems with BUILD-001
1. **Cognitive overload:** Two screens, two control schemes, split attention
2. **Complexity creep:** Bottom screen physics was becoming a full game itself
3. **Mobile UX issues:** Small screens make dual viewports cramped
4. **Implementation scope:** Two full game loops = 2x development time

### Benefits of CORE Systems
1. **Single mechanic mastery:** One skill to learn (timing the throw)
2. **Clearer pressure curve:** Anxiety rises → items come faster → Lyon approaches
3. **Mobile-friendly:** Full portrait screen for single interaction point
4. **Reduced scope:** One game loop = faster iteration
5. **Clearer identity:** "Paperboy meets Alien: Isolation" vs unclear dual-game hybrid

---

## 🚀 Implementation Priority

### Phase 1: Foundation (CORE-001 to 004) - CRITICAL PATH
1. **CORE-004 AnxietyManager** - Foundation singleton (NO BLOCKERS)
2. **CORE-001 IsometricCamera3D** - Camera and viewport setup (NEEDS: AnxietyManager)
3. **CORE-002 ConveyorSystem** - Item spawning (NEEDS: Camera, AnxietyManager)
4. **CORE-003 ToteProjectile** - Stow mechanic (NEEDS: All above)

### Phase 2: Polish & Enemies
- Lyon 3D model and AI
- VFX for phases (SAFE → WARN → DEMON_HOUR)
- Audio integration
- Tutorial sequence

### Phase 3: Content & Balance
- Item variety (heavy, possessed, golden)
- Power-ups
- Combo system
- High score persistence

---

## 📁 Repository Impact

### Files Marked Legacy
- `/docs/BUILD_LOGS/STOW-AI-BUILD-001.md` - Top screen systems (reference only)
- `/docs/GDD/LEGACY_NOTICE.md` - Original 92-page GDD

### Active Work Orders
- `/docs/WORKORDERS/STOW-CORE-001-ISOMETRIC-CAMERA.md` ✅
- `/docs/WORKORDERS/STOW-CORE-002-CONVEYOR-SYSTEM.md` ✅
- `/docs/WORKORDERS/STOW-CORE-003-TOTE-PROJECTILE.md` ✅
- `/docs/WORKORDERS/STOW-CORE-004-ANXIETY-MANAGER.md` ✅

### Godot Project Status
- **Directory structure:** ✅ Ready
- **project.godot:** ✅ Configured for 3D (still mobile-optimized)
- **Autoloads:** Need to implement AnxietyManager
- **Scenes:** Need to create Camera, Conveyor, Tote prefabs

---

## 🎨 Visual Identity Shift

### BUILD-001 Aesthetic
- Split-screen horror
- 2D pixel art aisles
- CRT glitch shaders
- Dual viewports

### CORE Aesthetic
- God Angle isometric 3D
- Mode 7 perspective floor
- Dimetric projection (2:1)
- Unified viewport with depth

**Still maintaining:**
- Pixel art characters (Lyon, player)
- Corporate → horror color shift
- VHS/retro distortion effects

---

## 🤔 Open Questions

### Q: Can we salvage any BUILD-001 code?
**A:** Yes, partially:
- Lyon AI state machine logic (adapt to 3D)
- Shader effects (CRT, possession glow)
- Input gesture detection
- Signal architecture patterns

### Q: What about the Tetris mechanics?
**A:** Removed entirely. The "2:1 slope physics throw" replaces box packing. Simpler, more focused.

### Q: Is this still horror?
**A:** Yes. Lyon still patrols/hunts. DEMON_HOUR phase still creates tension. But horror is now atmospheric (approaching threat) rather than split-screen jump scares.

### Q: Mobile performance with 3D?
**A:** Godot 4.3 Mobile renderer is optimized for this. Orthogonal camera + minimal geometry + object pooling = 60fps on mid-range Android.

---

## 📝 Developer Notes

**For CODER agents:**
- Implement work orders in dependency order (CORE-004 → 001 → 002 → 003)
- Follow 3D conventions (Vector3, Transform3D)
- Maintain mobile-first performance budget
- Use static typing throughout

**For ARCHITECT agents:**
- New systems should reference CORE work orders, not BUILD-001
- Consider 3D spatial relationships for future features
- Lyon AI will need 3D pathfinding (separate work order)

**For Chi (Project Lead):**
- This pivot simplifies scope significantly
- Focus on nailing the "swipe throw timing" feel
- BUILD-001 code can be studied for patterns, but don't port directly
- Trust the unified mechanic - it's cleaner

---

## ✅ Approval Status

**Approved By:** Chi (Project Lead)  
**Date:** January 13, 2026  
**Rationale:** Reduce complexity, improve mobile UX, faster iteration

---

**This is now the official architecture. BUILD-001 is legacy reference material only.**

**Next Step:** Implement STOW-CORE-004 (AnxietyManager) first, then proceed through CORE-001/002/003 in order.
