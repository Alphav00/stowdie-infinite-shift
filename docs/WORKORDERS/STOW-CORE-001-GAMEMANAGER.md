═══════════════════════════════════════════════════════════════
WORK ORDER: STOW-CORE-001-GAMEMANAGER
═══════════════════════════════════════════════════════════════

## META
- **ID:** STOW-CORE-001-GAMEMANAGER
- **Agent:** CODER
- **Priority:** HIGH
- **Status:** PENDING
- **Created:** 2026-01-13
- **Deadline:** None

---

## OBJECTIVE

Implement the GameManager singleton that manages Rate system, phase transitions, scoring, and global game state.

---

## CONTEXT

### GDD References
- **Primary:** /docs/BUILD_LOGS/STOW-AI-BUILD-001.md → Integration Requirements → GameManager Dependencies
- **Secondary:** Rate System (0-100% efficiency metric)

### Dependencies
- **Required Files:** None (foundational singleton)
- **Required Systems:** None (first system to implement)
- **Blocks:** 
  - STOW-AI-001-LYON (needs Rate and phase signals)
  - STOW-SYSTEMS-001-AISLE-SPAWNER (needs Rate for scroll speed)
  - STOW-CORE-002-PLAYER-CART (needs Rate and tote state)

### Current State
No existing implementation. AutoLoad registered in project.godot at `/root/GameManager`.

---

## DELIVERABLES

### Code Files
- [x] `scripts/_Autoloads/GameManager.gd` - Complete singleton implementation

### Documentation
- [x] Update `docs/BUILD_LOGS/STOW-AI-BUILD-002.md` with GameManager implementation notes

---

## ACCEPTANCE CRITERIA (Gherkin Format)

```gherkin
Feature: Rate System

Scenario: Rate drains passively
  Given the game is running
  And current_rate is 100.0
  When 1 second elapses in NORMAL phase
  Then current_rate should be approximately 98.0
  And rate_changed signal should emit with new value

Scenario: Rate addition
  Given current_rate is 50.0
  When add_rate(25.0) is called
  Then current_rate should be 75.0
  And rate_changed signal should emit

Scenario: Rate subtraction
  Given current_rate is 60.0
  When subtract_rate(15.0) is called
  Then current_rate should be 45.0
  And rate_changed signal should emit

Scenario: Rate clamping
  Given current_rate is 95.0
  When add_rate(10.0) is called
  Then current_rate should be 100.0 (clamped at max)

Feature: Phase Transitions

Scenario: Normal to Demon Hour transition
  Given current_phase is NORMAL (1)
  And current_rate is 21.0
  When rate drops below 20.0
  Then current_phase should be DEMON_HOUR (2)
  And phase_transition signal should emit with phase 2

Scenario: Tutorial phase start
  Given game just started
  When _ready() is called
  Then current_phase should be TUTORIAL (0)

Feature: Tote Management

Scenario: Get tote efficiency
  Given 8 items in tote
  And tote capacity is 10
  When get_tote_efficiency() is called
  Then should return 0.8 (80%)

Scenario: Clear tote
  Given tote has items
  When clear_tote() is called
  Then tote should be empty
  And tote_filled signal should emit with final efficiency
```

### Performance Criteria
- Frame time: < 0.1ms per _process call
- Memory usage: < 1MB
- No allocations during _process

---

## CONSTRAINTS

### Technical
- [x] Must be AutoLoad singleton at `/root/GameManager`
- [x] Must use strict static typing
- [x] Must use signal-based communication (no direct calls from other systems)
- [x] Rate decay must use delta time (frame-rate independent)

### Design
- [x] Rate range: 0.0 to 100.0 (float)
- [x] Phase transitions automatic based on Rate thresholds
- [x] Phases: 0=TUTORIAL, 1=NORMAL, 2=DEMON_HOUR
- [x] Passive drain: -2.0 Rate/second in NORMAL phase
- [x] No passive drain in TUTORIAL phase
- [x] Demon Hour has additional mechanics handled by Lyon AI

### Performance Budget
- Logic: < 0.1ms per frame

---

## VALIDATION CHECKLIST

Before marking complete:
- [ ] All acceptance criteria pass
- [ ] Signals emit correctly with proper typed parameters
- [ ] No hardcoded references to other nodes
- [ ] Static typing throughout (no Variant types)
- [ ] Rate decay frame-rate independent (uses delta)
- [ ] Performance measured < 0.1ms per frame
- [ ] Documentation created in BUILD_LOGS

---

## IMPLEMENTATION SPECIFICATIONS

### Required Properties
```gdscript
# Rate System
var current_rate: float = 100.0  # 0-100
var rate_drain_per_second: float = 2.0

# Phase System
enum Phase { TUTORIAL, NORMAL, DEMON_HOUR }
var current_phase: Phase = Phase.TUTORIAL

# Tote System (placeholder for future bottom screen)
var tote_items: int = 0
var tote_capacity: int = 10
```

### Required Signals
```gdscript
signal phase_transition(new_phase: int)
signal rate_changed(new_rate: float)
signal tote_filled(efficiency: float)
```

### Required Methods
```gdscript
func add_rate(amount: float) -> void
func subtract_rate(amount: float) -> void
func get_tote_efficiency() -> float
func get_tote_score() -> int
func clear_tote() -> void
func trigger_alarm() -> void
func trigger_screen_shake(duration: float, intensity: float) -> void
```

### Phase Transition Thresholds
- Rate < 20% → DEMON_HOUR
- Rate >= 20% → NORMAL (if currently in DEMON_HOUR)
- Manual transition from TUTORIAL → NORMAL via method

---

## ADDITIONAL CONTEXT

**Passive Rate Decay:**
- Only active in NORMAL and DEMON_HOUR phases
- Rate drains -2.0/second in NORMAL
- Rate drains -5.0/second in DEMON_HOUR (handled by Lyon, but GameManager tracks it)
- Use `_process(delta)` with time accumulation for smooth decay

**Screen Shake & Alarm:**
- These are placeholder methods that emit signals
- Actual implementation will be in camera/audio systems
- For now, just emit signals that other systems can connect to

**Tote System:**
- Currently placeholder (bottom screen not implemented yet)
- Methods should exist but can return dummy values
- Will be fully implemented in STOW-PHYSICS-001

---

## RELATED WORK ORDERS

- **Blocks:** 
  - STOW-AI-001-LYON-STATE-MACHINE
  - STOW-SYSTEMS-001-AISLE-SPAWNER
  - STOW-CORE-002-PLAYER-CART
  - STOW-CORE-003-INPUT-ROUTER

- **Blocked By:** None (foundational system)

---

## NOTES / QUESTIONS

Q: Should Rate decay continue when game is paused?  
A: No. Pause handling will be added in future work order.

Q: What happens at Rate = 0?  
A: Game over condition. Placeholder for now (print statement), full implementation in STOW-UI-001.

Q: Thread safety for signals?  
A: Not needed. Godot signals are deferred by default and safe.

---

## AGENT RESPONSE SECTION

### Implementation Summary
[CODER will fill this in upon delivery]

### Files Changed
- `scripts/_Autoloads/GameManager.gd` - [What was implemented]

### Known Issues
- [Any limitations or edge cases]

### Next Steps
- [Recommendations for follow-up work]

═══════════════════════════════════════════════════════════════
END WORK ORDER [ID: STOW-CORE-001-GAMEMANAGER]
Issued By: ORCHESTRATOR
Issued Date: 2026-01-13
═══════════════════════════════════════════════════════════════
