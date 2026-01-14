═══════════════════════════════════════════════════════════════
WORK ORDER: STOW-CORE-004-ANXIETY-MANAGER
═══════════════════════════════════════════════════════════════

## META
- **ID:** STOW-CORE-004-ANXIETY-MANAGER
- **Agent:** CODER
- **Priority:** CRITICAL (Foundation singleton)
- **Status:** PENDING
- **Created:** January 13, 2026
- **Deadline:** None

---

## OBJECTIVE

Create the AnxietyManager global singleton managing current_rate (0-100%), anxiety_level (derived state), game phase transitions (Safe → Warn → Demon Hour), and scoring/persistence logic.

---

## CONTEXT

### GDD References
- **Primary:** New anxiety-based mechanics (replaces "Rate" terminology from BUILD-001)
- **Related:** STOW-AI-BUILD-001.md (GameManager concept, but rebranded as AnxietyManager)

### Dependencies
- **Required Systems:** None (foundation singleton)
- **Blocks:** ALL other systems (provides global state and signals)

### Current State
No existing implementation. This replaces the GameManager concept from BUILD-001 but uses "anxiety" framing instead of "productivity rate."

---

## DELIVERABLES

### Code Files
- [x] `scripts/_Autoloads/AnxietyManager.gd` - Global singleton with anxiety state management
- [x] `project.godot` - Register AnxietyManager as autoload

### Documentation
- [ ] Update `docs/BUILD_LOGS/STOW-CORE-004.md` with implementation details
- [ ] Update `docs/GDD/00_MANIFEST.md` noting anxiety_level as primary metric

---

## ACCEPTANCE CRITERIA (Gherkin Format)

```gherkin
Feature: Anxiety Level Management

Scenario: Anxiety starts at 100% (Safe state)
  Given the game begins
  When AnxietyManager initializes
  Then current_rate equals 100.0
  And anxiety_level equals "SAFE"
  And current_phase equals PHASE_SAFE

Scenario: Anxiety decreases passively over time
  Given the game is running in SAFE phase
  When 1 second elapses
  Then current_rate decreases by 2.0 (base_drain_rate)
  And anxiety_decreased signal emits with new value

Scenario: Successful stow increases anxiety
  Given current_rate is 60%
  When ToteProjectile.item_stowed emits with grade "PERFECT"
  Then add_anxiety(15.0) is called
  And current_rate becomes 75.0
  And anxiety_increased signal emits

Scenario: Missed stow decreases anxiety
  Given current_rate is 50%
  When ConveyorSystem.item_missed emits
  Then subtract_anxiety(10.0) is called
  And current_rate becomes 40.0
  And anxiety_decreased signal emits

Scenario: Phase transition to WARN at 60%
  Given current_rate is 65%
  When current_rate drops to 59%
  Then current_phase changes to PHASE_WARN
  And phase_transition signal emits with PHASE_WARN
  And visual/audio warning plays

Scenario: Phase transition to DEMON_HOUR at 20%
  Given current_rate is 25%
  When current_rate drops to 19%
  Then current_phase changes to PHASE_DEMON_HOUR
  And phase_transition signal emits with PHASE_DEMON_HOUR
  And Lyon transformation triggers (via signal)
  And anxiety drain rate triples

Scenario: Game Over at 0% anxiety
  Given current_rate is 5%
  When current_rate drops to 0%
  Then game_over signal emits
  And gameplay pauses
  And final score is calculated

Scenario: Anxiety clamped to 0-100 range
  Given current_rate is 95%
  When add_anxiety(10.0) is called
  Then current_rate becomes 100.0 (clamped)
  When current_rate is 5%
  And subtract_anxiety(10.0) is called
  Then current_rate becomes 0.0 (clamped, game over)
```

### Performance Criteria
- Anxiety update: < 0.5ms per frame
- Signal emission: < 0.2ms per event
- Memory: < 5MB (state + scoring data)

---

## CONSTRAINTS

### Technical
- [x] Must be registered as autoload in project.godot
- [x] Must persist across scene changes (singleton pattern)
- [x] Must emit signals for all state changes (signal-driven architecture)
- [x] Must handle save/load for high scores (mobile-friendly)

### Design
- [x] Anxiety range: 0.0 - 100.0 (percentage)
- [x] Three phases: SAFE (>60%), WARN (20-60%), DEMON_HOUR (<20%)
- [x] Passive drain: -2%/sec (SAFE), -3%/sec (WARN), -5%/sec (DEMON_HOUR)
- [x] Clamp all anxiety changes to valid range

### Performance Budget
- Process loop: < 0.5ms per frame
- Signal emission: < 0.2ms per signal
- Save/load: < 50ms

---

## TECHNICAL SPECIFICATIONS

### AnxietyManager Script
```gdscript
extends Node
class_name AnxietyManagerClass  # For type hints

## Phase constants
enum Phase {
    SAFE,        # 60-100% anxiety
    WARN,        # 20-60% anxiety
    DEMON_HOUR   # 0-20% anxiety
}

## Anxiety configuration
@export var starting_anxiety: float = 100.0
@export var base_drain_rate: float = 2.0      # %/sec in SAFE phase
@export var warn_drain_rate: float = 3.0      # %/sec in WARN phase
@export var demon_drain_rate: float = 5.0     # %/sec in DEMON_HOUR

## Phase thresholds
const WARN_THRESHOLD: float = 60.0
const DEMON_THRESHOLD: float = 20.0

## Current state
var current_rate: float = 100.0
var current_phase: Phase = Phase.SAFE
var is_game_over: bool = false

## Scoring
var total_items_stowed: int = 0
var perfect_stows: int = 0
var good_stows: int = 0
var missed_items: int = 0
var final_score: int = 0

## Signals
signal anxiety_changed(new_value: float)
signal anxiety_increased(amount: float)
signal anxiety_decreased(amount: float)
signal phase_transition(new_phase: Phase)
signal game_over(final_score: int)

## Derived property
var anxiety_level: String:
    get:
        match current_phase:
            Phase.SAFE:
                return "SAFE"
            Phase.WARN:
                return "WARN"
            Phase.DEMON_HOUR:
                return "DEMON_HOUR"
        return "UNKNOWN"

func _ready() -> void:
    current_rate = starting_anxiety
    current_phase = Phase.SAFE

func _process(delta: float) -> void:
    if is_game_over:
        return
    
    # Apply passive drain
    var drain_rate: float = get_current_drain_rate()
    subtract_anxiety(drain_rate * delta)

func get_current_drain_rate() -> float:
    match current_phase:
        Phase.SAFE:
            return base_drain_rate
        Phase.WARN:
            return warn_drain_rate
        Phase.DEMON_HOUR:
            return demon_drain_rate
    return base_drain_rate

func add_anxiety(amount: float) -> void:
    var old_rate: float = current_rate
    current_rate = clamp(current_rate + amount, 0.0, 100.0)
    
    if current_rate != old_rate:
        emit_signal("anxiety_changed", current_rate)
        emit_signal("anxiety_increased", amount)
        check_phase_transition(old_rate, current_rate)

func subtract_anxiety(amount: float) -> void:
    var old_rate: float = current_rate
    current_rate = clamp(current_rate - amount, 0.0, 100.0)
    
    if current_rate != old_rate:
        emit_signal("anxiety_changed", current_rate)
        emit_signal("anxiety_decreased", amount)
        check_phase_transition(old_rate, current_rate)
    
    # Check game over
    if current_rate <= 0.0 and not is_game_over:
        trigger_game_over()

func check_phase_transition(old_rate: float, new_rate: float) -> void:
    var old_phase: Phase = get_phase_for_rate(old_rate)
    var new_phase: Phase = get_phase_for_rate(new_rate)
    
    if old_phase != new_phase:
        current_phase = new_phase
        emit_signal("phase_transition", new_phase)
        
        # Play transition effects
        match new_phase:
            Phase.WARN:
                AudioController.play_sfx("phase_warn")
            Phase.DEMON_HOUR:
                AudioController.play_sfx("phase_demon")

func get_phase_for_rate(rate: float) -> Phase:
    if rate >= WARN_THRESHOLD:
        return Phase.SAFE
    elif rate >= DEMON_THRESHOLD:
        return Phase.WARN
    else:
        return Phase.DEMON_HOUR

func trigger_game_over() -> void:
    is_game_over = true
    calculate_final_score()
    emit_signal("game_over", final_score)

func calculate_final_score() -> int:
    final_score = (perfect_stows * 15) + (good_stows * 10) - (missed_items * 5)
    return final_score

## Called by ToteProjectile when item stowed
func on_item_stowed(item: ConveyorItem, grade: String, score: int) -> void:
    total_items_stowed += 1
    
    match grade:
        "PERFECT":
            perfect_stows += 1
            add_anxiety(15.0)
        "GOOD":
            good_stows += 1
            add_anxiety(10.0)
    
    # Additional score could be used for combos, etc.

## Called by ConveyorSystem when item missed
func on_item_missed(item: ConveyorItem) -> void:
    missed_items += 1
    subtract_anxiety(10.0)
```

### project.godot Registration
```ini
[autoload]

AnxietyManager="*res://scripts/_Autoloads/AnxietyManager.gd"
```

### Integration Points
```gdscript
# Signals to connect (from other systems)
# ToteProjectile.item_stowed -> AnxietyManager.on_item_stowed
# ConveyorSystem.item_missed -> AnxietyManager.on_item_missed

# Signals to emit (for other systems to listen)
signal anxiety_changed(new_value: float)          # IsometricCamera, ConveyorSystem
signal anxiety_increased(amount: float)           # UI feedback
signal anxiety_decreased(amount: float)           # UI feedback
signal phase_transition(new_phase: Phase)         # Lyon AI, environment
signal game_over(final_score: int)                # UI, scene transition
```

---

## VALIDATION CHECKLIST

Before marking complete, verify:
- [x] Singleton accessible via `/root/AnxietyManager`
- [x] Anxiety starts at 100% (SAFE phase)
- [x] Passive drain works at correct rates per phase
- [x] add_anxiety() increases rate correctly
- [x] subtract_anxiety() decreases rate correctly
- [x] Anxiety clamped to 0-100 range
- [x] Phase transitions trigger at correct thresholds
- [x] phase_transition signal emits with correct phase
- [x] Game over triggers at 0% anxiety
- [x] Scoring calculations work correctly
- [x] Performance measured: < 0.5ms per frame
- [x] All signals emit properly
- [x] BUILD_LOG created

---

## ADDITIONAL CONTEXT

### Why "Anxiety" Instead of "Rate"?
**Narrative framing:**
- **"Rate" (BUILD-001):** Productivity metric, external measurement
- **"Anxiety" (Current):** Internal psychological state, player empathy

**Gameplay benefit:**
- "Anxiety rising" feels more urgent than "rate dropping"
- Clearer motivation for horror elements (anxiety → fear → Lyon transformation)
- Better thematic consistency with "Demon Hour" phase

### Drain Rate Balancing
```
SAFE Phase (100% → 60%):
  - Duration: 20 seconds (40% / 2%/sec)
  - Player has time to learn mechanics
  
WARN Phase (60% → 20%):
  - Duration: 13.3 seconds (40% / 3%/sec)
  - Pressure increases, mistakes hurt more
  
DEMON_HOUR Phase (20% → 0%):
  - Duration: 4 seconds (20% / 5%/sec)
  - Extreme pressure, Lyon actively hunts
  - Player must perform perfectly to survive
```

**Tuning knobs:**
- Adjust base_drain_rate for difficulty
- Adjust phase thresholds for pacing
- Adjust stow bonuses (+10, +15) for reward feel

### Phase Visual/Audio Cues
**SAFE → WARN Transition:**
- UI: Anxiety meter turns yellow
- Audio: Warning beep
- Environment: Lighting dims slightly

**WARN → DEMON_HOUR Transition:**
- UI: Anxiety meter turns red, pulsing
- Audio: Demon roar (Lyon transformation)
- Environment: Red emergency lights, heavy shadows
- Lyon: Transforms to demon form, begins pursuit

---

## RELATED WORK ORDERS

- **Blocks:** STOW-CORE-001-ISOMETRIC-CAMERA (needs anxiety_changed signal)
- **Blocks:** STOW-CORE-002-CONVEYOR-SYSTEM (needs anxiety_changed signal)
- **Blocks:** STOW-CORE-003-TOTE-PROJECTILE (sends item_stowed signal)
- **Related:** All future systems (central state manager)

---

## NOTES / QUESTIONS

**Q:** Should anxiety recovery be possible during DEMON_HOUR?  
**A:** Yes, but very difficult. Perfect stows give +15%, but drain is -5%/sec. Need 3 perfect stows/minute to break even.

**Q:** Should there be a maximum anxiety cap after game over?  
**A:** No. Game over at 0% is final. Player must restart.

**Q:** Should high scores persist across sessions?  
**A:** Yes. Use ConfigFile or save/load system. Separate work order for persistence.

**Q:** What about combos or multipliers?  
**A:** Good idea for later. Start with base scoring. Add combo system in separate work order.

---

## AGENT RESPONSE SECTION

### Implementation Summary
[Agent fills this in upon delivery]

### Files Changed
- [To be filled by CODER agent]

### Known Issues
- [Any limitations or edge cases]

### Next Steps
- Test phase transitions with debug UI
- Tune drain rates via playtesting
- Add high score persistence (separate work order)

═══════════════════════════════════════════════════════════════
END WORK ORDER [ID: STOW-CORE-004-ANXIETY-MANAGER]
Issued By: ORCHESTRATOR
Issued Date: January 13, 2026
═══════════════════════════════════════════════════════════════
