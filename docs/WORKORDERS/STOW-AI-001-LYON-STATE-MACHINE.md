═══════════════════════════════════════════════════════════════
WORK ORDER: STOW-AI-001-LYON-STATE-MACHINE
═══════════════════════════════════════════════════════════════

## META
- **ID:** STOW-AI-001-LYON-STATE-MACHINE
- **Agent:** CODER
- **Priority:** HIGH
- **Status:** PENDING
- **Created:** 2026-01-13
- **Deadline:** None

---

## OBJECTIVE

Implement Lyon's 4-state AI system (DORMANT → PATROL → AUDIT → DEMON_PURSUIT) with player detection, Rate evaluation, and phase-based behavior.

---

## CONTEXT

### GDD References
- **Primary:** /docs/BUILD_LOGS/STOW-AI-BUILD-001.md → System Specifications → Lyon AI State Machine
- **Secondary:** Signal Architecture → Lyon Signals

### Dependencies
- **Required Files:** None (standalone component)
- **Required Systems:** 
  - GameManager (for current_rate and current_phase)
  - Player node in scene (tagged with group "player")
- **Blocks:** Lyon scene assembly (STOW-SCENES-001)

### Current State
No existing implementation. Will be attached to LyonAI.tscn scene node.

---

## DELIVERABLES

### Code Files
- [x] `scripts/AI/LyonStateMachine.gd` - Complete 4-state AI implementation (~380 lines)

### Documentation
- [x] Update `docs/BUILD_LOGS/STOW-AI-BUILD-002.md` with Lyon AI implementation notes

---

## ACCEPTANCE CRITERIA (Gherkin Format)

```gherkin
Feature: State Transitions

Scenario: DORMANT to PATROL (phase change)
  Given Lyon is in DORMANT state
  And GameManager.current_phase is TUTORIAL
  When GameManager.phase_transition signal emits with NORMAL
  Then Lyon should transition to PATROL state
  And state_changed signal should emit

Scenario: PATROL to AUDIT (player spotted)
  Given Lyon is in PATROL state
  And player is within 350px detection radius
  And player is within 120° vision cone
  And player is not hidden
  When detection check passes
  Then Lyon should transition to AUDIT state
  And audit_started signal should emit

Scenario: AUDIT to DEMON_PURSUIT (low Rate)
  Given Lyon is in AUDIT state
  And GameManager.current_rate drops below 20.0
  When rate threshold check occurs
  Then Lyon should transition to DEMON_PURSUIT state
  And demon_transformation_started signal should emit

Scenario: DEMON_PURSUIT to PATROL (Rate recovery)
  Given Lyon is in DEMON_PURSUIT state
  And GameManager.current_rate rises above 45.0
  When rate threshold check occurs
  Then Lyon should transition to PATROL state
  And demon_transformation_ended signal should emit

Feature: PATROL Behavior

Scenario: Basic patrol movement
  Given Lyon is in PATROL state
  And scroll speed is 180px/s
  When _physics_process is called
  Then Lyon should move left at 120px/s (against scroll)
  And sprite should face left

Scenario: Random stare pause
  Given Lyon is in PATROL state
  And patrol timer > 3.0 seconds
  When random chance triggers (8%)
  Then Lyon should pause for 1.5-2.5 seconds
  And sprite should flip to face player direction

Scenario: Player detection check
  Given Lyon is in PATROL state
  When player enters 350px radius
  And player is within 120° front-facing cone
  And player is not hidden
  Then should transition to AUDIT

Feature: AUDIT Behavior

Scenario: Audit sequence
  Given Lyon just entered AUDIT state
  Then Lyon should lock velocity to 0
  And should face player
  And should wait 4.5 seconds
  And should evaluate tote efficiency

Scenario: Poor tote efficiency
  Given Lyon is evaluating tote
  And GameManager.get_tote_efficiency() returns 0.35
  When audit completes
  Then should subtract 25 Rate
  And audit_completed signal emits with "This is unacceptable"
  And should return to PATROL

Scenario: Acceptable tote efficiency
  Given tote efficiency is 0.65
  When audit completes
  Then should subtract 0 Rate
  And audit_completed signal emits with "...Acceptable"

Feature: DEMON_PURSUIT Behavior

Scenario: Active pursuit
  Given Lyon is in DEMON_PURSUIT state
  When _physics_process is called
  Then Lyon should move toward player at 280px/s
  And should apply -5 Rate/second constant drain
  And should ignore obstacles (phase through)

Scenario: Player caught in DEMON mode
  Given Lyon is in DEMON_PURSUIT
  And Lyon touches player (collision)
  When collision occurs
  Then should trigger game over
  And should reset Rate to 0
```

### Performance Criteria
- Frame time: < 0.5ms per _physics_process
- Memory usage: < 5MB
- Detection checks: < 0.1ms per frame

---

## CONSTRAINTS

### Technical
- [x] Must use CharacterBody2D as base node type
- [x] Must use @export variables for tuning values
- [x] Must use signal-based communication with GameManager
- [x] Must use groups to find player: `get_tree().get_first_node_in_group("player")`

### Design
- [x] State machine with 4 states (enum)
- [x] Detection radius: 350px
- [x] Vision cone: 120° from facing direction
- [x] Patrol speed: 120px/s (leftward)
- [x] Demon pursuit speed: 280px/s
- [x] Audit duration: 4.5 seconds
- [x] Rate thresholds: < 20% trigger DEMON, > 45% end DEMON

### Performance Budget
- Physics: < 0.5ms per frame
- Detection: < 0.1ms per frame

---

## VALIDATION CHECKLIST

Before marking complete:
- [ ] All 4 states functional
- [ ] All state transitions work correctly
- [ ] All signals emit with proper parameters
- [ ] Player detection accurate (radius + cone)
- [ ] Hidden player not detected
- [ ] Rate drain in DEMON mode functional
- [ ] Static typing throughout
- [ ] @export vars for designer tuning
- [ ] Performance measured < 0.5ms
- [ ] Documentation created

---

## IMPLEMENTATION SPECIFICATIONS

### Required Enum
```gdscript
enum State {
    DORMANT,        # Tutorial phase, inactive
    PATROL,         # Normal phase, roaming behavior
    AUDIT,          # Inspecting player's tote
    DEMON_PURSUIT   # Active chase at low Rate
}
```

### Required Signals
```gdscript
signal state_changed(new_state: State, old_state: State)
signal audit_started()
signal audit_completed(rate_penalty: float, message: String)
signal demon_transformation_started()
signal demon_transformation_ended()
signal player_spotted(player_position: Vector2)
```

### Required Export Variables
```gdscript
@export var patrol_speed: float = 120.0
@export var demon_speed: float = 280.0
@export var detection_radius: float = 350.0
@export var vision_cone_angle: float = 120.0
@export var audit_duration: float = 4.5
@export var demon_rate_drain: float = -5.0  # per second
@export var stare_chance: float = 0.08
```

### State-Specific Logic

**DORMANT:**
- No movement
- No detection
- Listens for phase_transition signal → PATROL

**PATROL:**
- Move left at patrol_speed
- Check for player detection every frame
- Random 8% chance to pause and stare (every 3+ seconds)
- Transition to AUDIT if player detected

**AUDIT:**
- Lock velocity to zero
- Face player
- Wait audit_duration seconds
- Evaluate tote efficiency:
  - < 40%: -25 Rate, "This is unacceptable"
  - < 60%: -15 Rate, "Sloppy work"
  - ≥ 60%: 0 Rate, "...Acceptable"
- Return to PATROL after audit

**DEMON_PURSUIT:**
- Move toward player at demon_speed
- Apply demon_rate_drain per second to GameManager
- Check if Rate > 45% → revert to PATROL
- Collision with player → game over

### Detection Algorithm
```gdscript
func _can_see_player() -> bool:
    var player = get_tree().get_first_node_in_group("player")
    if not player or player.is_hidden:
        return false
    
    var distance = global_position.distance_to(player.global_position)
    if distance > detection_radius:
        return false
    
    var direction_to_player = (player.global_position - global_position).normalized()
    var facing_direction = Vector2.LEFT  # Adjust based on sprite facing
    var angle = facing_direction.angle_to(direction_to_player)
    
    return abs(angle) < deg_to_rad(vision_cone_angle / 2.0)
```

---

## ADDITIONAL CONTEXT

**Player Reference:**
- Never store player reference directly
- Always use: `get_tree().get_first_node_in_group("player")`
- Check if player.is_hidden property exists and is true

**Rate Integration:**
- Access via: `GameManager.current_rate`
- Modify via: `GameManager.subtract_rate(amount)`
- Listen for: `GameManager.rate_changed` signal

**Phase Integration:**
- Listen for: `GameManager.phase_transition` signal
- DORMANT only active in TUTORIAL phase
- DEMON_PURSUIT only possible when Rate < 20%

**Visual Feedback:**
- Sprite flipping handled by AnimationPlayer (future work order)
- For now, just set scale.x = -1 for facing right, 1 for facing left

---

## RELATED WORK ORDERS

- **Blocks:** 
  - STOW-SCENES-001-LYON-PREFAB (scene assembly)
  - STOW-VFX-002-DEMON-SHADER (visual effects)

- **Blocked By:** 
  - STOW-CORE-001-GAMEMANAGER (needs Rate system)

- **Related:**
  - STOW-CORE-003-PLAYER-CART (player interaction)

---

## NOTES / QUESTIONS

Q: What if player leaves detection radius during AUDIT?  
A: Audit continues for full duration. Lyon doesn't cancel audits.

Q: Can Lyon detect player through walls?  
A: For MVP, yes. Raycasting for occlusion is future enhancement.

Q: Multiple players in scene?  
A: Use first node in "player" group. Game is single-player.

---

## AGENT RESPONSE SECTION

### Implementation Summary
[CODER will fill this in upon delivery]

### Files Changed
- `scripts/AI/LyonStateMachine.gd` - [What was implemented]

### Known Issues
- [Any limitations or edge cases]

### Next Steps
- [Recommendations for follow-up work]

═══════════════════════════════════════════════════════════════
END WORK ORDER [ID: STOW-AI-001-LYON-STATE-MACHINE]
Issued By: ORCHESTRATOR
Issued Date: 2026-01-13
═══════════════════════════════════════════════════════════════
