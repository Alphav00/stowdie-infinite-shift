# 📚 StowOrDie: Living GDD Manifest

**Version:** 3.0.1  
**Document Type:** Navigation Index  
**Last Updated:** January 13, 2026  
**Maintainer:** ORCHESTRATOR (Claude 4.5 Sonnet)

---

## 🎯 Purpose

This manifest serves as the **master index** for the StowOrDie: Infinite Shift Game Design Document. The Living GDD is:
- ✅ **Version-controlled** - All changes tracked via Git
- ✅ **Machine-readable** - Structured for AI agent consumption
- ✅ **Single source of truth** - No conflicting documentation

---

## 📖 Document Structure

### Core GDD Files

| File | Purpose | Status |
|------|---------|--------|
| **00_MANIFEST.md** | This file - Navigation and versioning | ✅ Current |
| **01_CORE_PILLARS.md** | Design philosophy and core mechanics | ✅ Stable |
| **02_SYSTEMS_REFERENCE.md** | Technical specifications for all systems | ✅ Stable |
| **03_ASSET_BIBLE.md** | Visual/audio style guidelines | ✅ Stable |
| **04_NARRATIVE_CODEX.md** | Story, world-building, entities | ✅ Stable |

### Extended Documentation

| Directory | Purpose |
|-----------|---------|
| **../AGENT_CONTEXTS/** | AI agent system prompts |
| **../WORKORDERS/** | Task delegation templates |
| **../BUILD_LOGS/** | Implementation audit trail |

---

## 🏗️ Architecture Overview

### The Three Layers

**1. CONCEPT LAYER** (What and Why)
- High concept and USP trinity
- Core pillars and design philosophy
- Target audience and market fit

**2. SYSTEM LAYER** (How)
- Mechanic implementations
- Technical specifications
- Signal architecture
- Performance budgets

**3. ASSET LAYER** (What It Looks Like)
- Visual style guide
- Audio design
- Generative manifests
- Localization strategy

---

## 📊 Version History

### v3.0.1 (Current - January 2026)
- ✅ Comprehensive 92-page GDD complete
- ✅ All 8 core systems specified with GDScript implementations
- ✅ Asset generation manifests with AI prompts
- ✅ 13-week development roadmap
- ✅ Mobile-first optimization specifications

### v2.1.0 (December 2025)
- Lyon AI state machine expansion
- Infinite scrolling implementation
- Shader system specifications

### v1.0.0 (November 2025)
- Initial dual-screen concept
- Rate system design
- Core mechanic prototypes

---

## 🎮 Core Game Loop

```
Session Start (Rate = 100%)
    ↓
Bottom Screen: Pack Items → Suppress Expansion → Fill Tote
    ↓
Top Screen: Navigate Aisles → Avoid Lyon → Stow at Correct Aisle
    ↓
Rate Drains Passively (-2%/sec)
    ↓
Rate < 60%: Phase 2 (Corruption Begins)
    ↓
Rate < 20%: Phase 3 (Demon Hour - Lyon Transforms)
    ↓
Rate = 0%: Game Over
```

---

## 🔧 Technical Stack

- **Engine:** Godot 4.3.0 (Mobile Renderer, Forward+)
- **Target Platform:** Android 10+, iOS 15+
- **Resolution:** 1080x1920 (Portrait, 320dpi)
- **Frame Rate:** 60fps (VSync Adaptive)
- **Memory Budget:** 512MB peak, 256MB baseline
- **Physics:** Godot Physics 2D (Fixed timestep: 60Hz)

---

## 📋 Reading Order

### For Developers
1. Start with **01_CORE_PILLARS.md** for design philosophy
2. Reference **02_SYSTEMS_REFERENCE.md** for implementation
3. Use **../BUILD_LOGS/** for specific component examples

### For AI Agents
1. Load **00_MANIFEST.md** (this file) for context
2. Reference **../AGENT_CONTEXTS/[ROLE].md** for your specialization
3. Await work orders from ORCHESTRATOR
4. Validate output against **02_SYSTEMS_REFERENCE.md**

### For Artists/Sound Designers
1. **03_ASSET_BIBLE.md** for complete style guide
2. **02_SYSTEMS_REFERENCE.md** → ASSET LAYER for generative manifests
3. **04_NARRATIVE_CODEX.md** for thematic context

---

## 🚧 Current Development Phase

**Status:** **Phase 2 - Core Mechanics Implementation**

### Completed Systems
- ✅ Dual SubViewport architecture
- ✅ GameManager (Rate, Phases, Scoring)
- ✅ Lyon AI (PATROL, AUDIT, DEMON states)
- ✅ Infinite aisle scrolling with object pooling
- ✅ Custom shader suite

### In Progress
- 🚧 Physics item expansion mechanic (STOW-AI-BUILD-002)
- 🚧 Tote container collision system
- 🚧 Swipe gesture integration

### Next Milestones
- ⏳ Audio system and music crossfading
- ⏳ Tutorial sequence and Stewie NPC
- ⏳ High score persistence and leaderboards

---

## 🤖 AI Agent Integration

This GDD is designed for consumption by AI development agents using the **Vagrant Architect Framework**:

**ORCHESTRATOR** (Claude 4.5 Sonnet)
- Routes work orders to specialists
- Maintains GDD coherence
- Validates deliverables

**ARCHITECT** (Gemini 2.5 Pro)
- Designs system architectures
- Plans technical implementation
- 2M token context for full project state

**CODER** (Claude 4.5 Sonnet)
- Implements GDScript with strict typing
- Follows 02_SYSTEMS_REFERENCE specs
- Validates with Gherkin scenarios

**ARTISAN** (Gemini / Midjourney)
- Generates pixel art assets
- Creates procedural audio
- Follows 03_ASSET_BIBLE guidelines

---

## 📞 Contact & Contribution

**Primary Developer:** Chi (Alphav00)  
**Repository:** [github.com/Alphav00/stowdie-infinite-shift](https://github.com/Alphav00/stowdie-infinite-shift)  
**Development Philosophy:** Mobile-first, AI-assisted, modular architecture

For questions about specific systems, reference the appropriate GDD section and create an issue in the repository.

---

## 🔐 Document Integrity

**This is the authoritative version.** Any conflicting information in:
- Slack messages
- Email threads
- Meeting notes
- External documents

...should be reconciled against this Living GDD. When in doubt, **the GDD wins**.

---

**Last Validation:** January 13, 2026  
**Next Review:** Upon completion of STOW-AI-BUILD-002

**"The GDD is the source of truth. Everything else is commentary."**
