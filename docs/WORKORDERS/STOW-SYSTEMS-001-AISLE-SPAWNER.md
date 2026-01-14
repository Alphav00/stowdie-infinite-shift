═══════════════════════════════════════════════════════════════
WORK ORDER: STOW-SYSTEMS-001-AISLE-SPAWNER
═══════════════════════════════════════════════════════════════

## META
- **ID:** STOW-SYSTEMS-001-AISLE-SPAWNER
- **Agent:** CODER
- **Priority:** HIGH
- **Status:** PENDING
- **Created:** 2026-01-13

---

## OBJECTIVE

Implement infinite scrolling aisle system with object pooling, corruption states, and Rate-based speed scaling.

---

## CONTEXT

### GDD References
- **Primary:** /docs/BUILD_LOGS/STOW-AI-BUILD-001.md → Infinite Aisle Spawner

### Dependencies
- **Required Systems:** GameManager (for Rate)
- **Blocks:** TopScreen scene assembly

---

## DELIVERABLES

- [x] `scripts/Systems/AisleSpawner.gd` - Spawner system (~280 lines)
- [x] `scripts/Entities/Aisle.gd` - Individual aisle script (~250 lines)

---

## ACCEPTANCE CRITERIA

```gherkin
Feature: Infinite Scrolling
  Scenario: Speed scales with Rate
    Given Rate is 50%
    When scroll speed calculated
    Then speed should be lerp(180, 450, 0.5) = 315px/s

Feature: Object Pooling
  Scenario: Aisle recycling
    Given pool has 6 aisles
    When aisle moves past x = -900
    Then should reposition to x = 1200
    And should update corruption level

Feature: Corruption System
  Scenario: Rate-based corruption
    Given Rate is 45%
    Then corruption_level should be 1 (DIRTY)
    And blood decals spawn at 5% chance
```

---

## IMPLEMENTATION SPECS

```gdscript
@export var base_scroll_speed: float = 180.0
@export var max_scroll_speed: float = 450.0
@export var pool_size: int = 6
@export var aisle_spacing: float = 800.0
@export var spawn_x: float = 1200.0
@export var despawn_x: float = -900.0
```

### Corruption Levels
- Level 0 (CLEAN): Rate > 60%
- Level 1 (DIRTY): Rate 20-60%
- Level 2 (BLOODY): Rate < 20%

---

## RELATED WORK ORDERS
- **Blocked By:** STOW-CORE-001-GAMEMANAGER

═══════════════════════════════════════════════════════════════
