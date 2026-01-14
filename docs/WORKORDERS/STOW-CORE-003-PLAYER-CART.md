═══════════════════════════════════════════════════════════════
WORK ORDER: STOW-CORE-003-PLAYER-CART
═══════════════════════════════════════════════════════════════

## META
- **ID:** STOW-CORE-003-PLAYER-CART
- **Agent:** CODER
- **Priority:** HIGH
- **Status:** PENDING
- **Created:** 2026-01-13

---

## OBJECTIVE

Implement player cart movement (vertical only), stow mechanic, and hide mechanic for top screen.

---

## CONTEXT

### GDD References
- **Primary:** /docs/BUILD_LOGS/STOW-AI-BUILD-001.md → Player Cart (Top Screen)

### Dependencies
- **Required Systems:** 
  - InputRouter (for swipe detection)
  - GameManager (for tote state)

---

## DELIVERABLES

- [x] `scripts/Core/PlayerCart.gd` - Player controller (~300 lines)

---

## ACCEPTANCE CRITERIA

```gherkin
Feature: Vertical Movement
  Scenario: Touch drag movement
    Given player at y = 500
    When InputRouter.drag_updated emits with delta (0, 50)
    Then player should move to y = 550
    And should clamp to bounds [100, 860]

Feature: Stow Mechanic
  Scenario: Successful stow
    Given tote is full
    And player in stow zone (y 300-500)
    When InputRouter.swipe_detected emits with direction UP
    Then stow_executed signal emits with success=true
    And GameManager.clear_tote() called

  Scenario: Failed stow (wrong zone)
    Given tote is full
    And player NOT in stow zone
    When swipe UP detected
    Then subtract 10 Rate
    And trigger alarm

Feature: Hide Mechanic
  Scenario: Enter hiding
    Given player near shelf
    When InputRouter.swipe_detected emits with direction DOWN
    Then is_hidden should be true
    And hide_state_changed signal emits
    And invisible to Lyon for 2.5 seconds
```

---

## IMPLEMENTATION SPECS

```gdscript
@export var move_speed: float = 250.0
@export var min_y: float = 100.0
@export var max_y: float = 860.0
@export var hide_duration: float = 2.5
@export var hide_cooldown: float = 1.0

var is_hidden: bool = false
var can_stow: bool = false  # Set by GameManager signal

signal stow_executed(success: bool, score: int, aisle_id: String)
signal hide_state_changed(is_hidden: bool)
signal stow_ready_changed(is_ready: bool)
```

---

## RELATED WORK ORDERS
- **Blocked By:** 
  - STOW-CORE-001-GAMEMANAGER
  - STOW-CORE-002-INPUT-ROUTER

═══════════════════════════════════════════════════════════════
