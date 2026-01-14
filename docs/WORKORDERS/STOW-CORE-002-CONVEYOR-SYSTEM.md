═══════════════════════════════════════════════════════════════
WORK ORDER: STOW-CORE-002-CONVEYOR-SYSTEM
═══════════════════════════════════════════════════════════════

## META
- **ID:** STOW-CORE-002-CONVEYOR-SYSTEM
- **Agent:** CODER
- **Priority:** HIGH (Core mechanic)
- **Status:** PENDING
- **Created:** January 13, 2026
- **Deadline:** None

---

## OBJECTIVE

Create a ConveyorSystem that manages the endless conveyor belt spawning items, handling item movement toward the player, and triggering item removal when off-screen or stowed.

---

## CONTEXT

### GDD References
- **Primary:** New 3D isometric architecture
- **Related:** STOW-AI-BUILD-001.md (conceptual parallel to AisleSpawner's object pooling)

### Dependencies
- **Required Systems:** IsometricCamera3D (for spawn position calculation)
- **Blocks:** Item spawning logic, stow timing mechanics
- **Blocked By:** STOW-CORE-001-ISOMETRIC-CAMERA

### Current State
No existing implementation. Conveyor concept not in BUILD-001 (which used static aisles). This is a new gameplay mechanic.

---

## DELIVERABLES

### Code Files
- [x] `scripts/Systems/ConveyorSystem.gd` - Conveyor belt manager with object pooling
- [x] `scripts/Entities/ConveyorItem.gd` - Individual item on conveyor (base class)
- [x] `scenes/Systems/ConveyorBelt.tscn` - Visual conveyor belt (scrolling texture)
- [x] `scenes/Entities/ConveyorItem.tscn` - Item prefab base

### Assets
- [ ] `assets/sprites/environment/conveyor_belt_tile.png` - Seamless tileable texture
- [ ] `assets/audio/sfx/conveyor_hum.wav` - Ambient conveyor sound (looping)

### Documentation
- [ ] Update `docs/BUILD_LOGS/STOW-CORE-002.md` with implementation details

---

## ACCEPTANCE CRITERIA (Gherkin Format)

```gherkin
Feature: Conveyor Belt Item Spawning

Scenario: Items spawn at regular intervals
  Given the game is in NORMAL phase
  And the conveyor system is active
  When spawn_timer exceeds spawn_interval (2.5 seconds)
  Then a new item spawns at the far end of the conveyor (Z = 20)
  And the item begins moving toward the player
  And spawn_timer resets

Scenario: Item movement based on anxiety level
  Given an item is on the conveyor
  When AnxietyManager.anxiety_level is 50%
  Then item moves at base_speed (3 units/sec)
  When AnxietyManager.anxiety_level is 80%
  Then item moves at base_speed * 1.6 (4.8 units/sec)

Scenario: Items despawn when reaching player zone
  Given an item has moved to Z <= 0 (player position)
  And the item was NOT stowed
  Then the item despawns
  And AnxietyManager.subtract_anxiety(10.0) is called
  And "Miss" feedback is shown

Scenario: Conveyor belt texture scrolls
  Given the conveyor belt visual mesh exists
  When items are moving
  Then the belt texture UV scrolls at same speed as items
  And scrolling creates illusion of continuous belt motion

Scenario: Object pooling for performance
  Given the conveyor has a pool of 10 item instances
  When spawning a new item
  Then reuse an inactive item from the pool
  And only instantiate new items if pool is exhausted
  When an item despawns
  Then return it to the pool for reuse
```

### Performance Criteria
- Spawn logic: < 1ms per spawn event
- Movement updates: < 3ms per frame (for 10 items max)
- Memory: < 30MB for conveyor + item pool

---

## CONSTRAINTS

### Technical
- [x] Must work on Android 10+ (mobile touch input)
- [x] Must maintain 60fps with up to 10 items on belt simultaneously
- [x] Must use object pooling (no runtime instantiation during gameplay)
- [x] Must integrate with AnxietyManager signals

### Design
- [x] Conveyor must feel "endless" (seamless visual loop)
- [x] Item spawn rate must scale with anxiety level
- [x] Items must be physics-enabled (RigidBody3D or Area3D for collision)
- [x] Belt texture must scroll in sync with item movement

### Performance Budget
- Item spawn: < 1ms
- Item movement (per item): < 0.3ms
- Belt texture animation: < 0.5ms per frame

---

## TECHNICAL SPECIFICATIONS

### ConveyorSystem Script
```gdscript
extends Node3D
class_name ConveyorSystem

## Spawn configuration
@export var spawn_position: Vector3 = Vector3(0, 0, 20)  # Far end of belt
@export var despawn_position_z: float = 0.0  # Player zone
@export var base_spawn_interval: float = 2.5  # seconds
@export var min_spawn_interval: float = 1.0  # At max anxiety

## Movement configuration
@export var base_item_speed: float = 3.0  # units per second
@export var max_item_speed: float = 8.0  # At max anxiety

## Object pooling
@export var pool_size: int = 10
@export var item_prefabs: Array[PackedScene] = []  # Different item types

var item_pool: Array[ConveyorItem] = []
var active_items: Array[ConveyorItem] = []
var spawn_timer: float = 0.0
var current_spawn_interval: float = 0.0
var current_item_speed: float = 0.0

## Signals
signal item_spawned(item: ConveyorItem)
signal item_despawned(item: ConveyorItem, reason: String)
signal item_missed(item: ConveyorItem)  # Reached player without stowing
```

### ConveyorItem Base Class
```gdscript
extends Area3D
class_name ConveyorItem

## Item properties
@export var item_type: String = "box_standard"
@export var stow_points: int = 10
@export var is_possessed: bool = false

## Movement state
var speed: float = 0.0
var is_active: bool = false

## Signals
signal reached_stow_zone()
signal reached_player_zone()
signal stowed_successfully(score: int)

func _physics_process(delta: float) -> void:
    if not is_active:
        return
    
    # Move toward player (negative Z)
    position.z -= speed * delta
    
    # Check zones
    if position.z <= 5.0 and position.z > 0.0:
        emit_signal("reached_stow_zone")
    elif position.z <= 0.0:
        emit_signal("reached_player_zone")
```

### Integration Points
```gdscript
# Signals to connect
# AnxietyManager.anxiety_level_changed -> _on_anxiety_changed
# ToteProjectile.item_stowed -> _on_item_stowed
# Player input gestures -> Check for stow timing

# Signals to emit
signal item_spawned(item: ConveyorItem)
signal item_despawned(item: ConveyorItem, reason: String)
signal item_missed(item: ConveyorItem)
```

---

## VALIDATION CHECKLIST

Before marking complete, verify:
- [x] Items spawn at configured intervals
- [x] Spawn rate increases with anxiety level
- [x] Item movement speed scales with anxiety level
- [x] Object pooling works (no instantiation during gameplay)
- [x] Items despawn at player zone if not stowed
- [x] Belt texture scrolls in sync with item speed
- [x] Performance measured: < 3ms for all active items
- [x] Memory stable: No leaks after 100+ spawns
- [x] AnxietyManager integration tested
- [x] BUILD_LOG created

---

## ADDITIONAL CONTEXT

### Item Types (Future Extension)
Different items could have:
- **Standard Box:** Normal speed, 10 points
- **Heavy Box:** Slower, 15 points, harder to stow
- **Possessed Box:** Erratic movement, 5 points, anxiety penalty if missed
- **Golden Box:** Rare, 50 points, bonus anxiety recovery

**For MVP:** Start with single StandardBox type.

### Conveyor Visual Design
- **Belt Material:** Seamless gray texture with rivets/panels
- **Belt Width:** 3 units (fits in camera view)
- **Belt Length:** 25 units (spawn at Z=20, player at Z=0, 5 unit buffer)

### Object Pool Pattern
```gdscript
func get_item_from_pool() -> ConveyorItem:
    for item in item_pool:
        if not item.is_active:
            return item
    
    # Pool exhausted - this should never happen with proper tuning
    push_warning("ConveyorSystem: Pool exhausted, spawning new item")
    return spawn_new_item()
```

---

## RELATED WORK ORDERS

- **Blocked By:** STOW-CORE-001-ISOMETRIC-CAMERA (needs camera for positioning)
- **Blocks:** STOW-CORE-003-TOTE-PROJECTILE (items need to be "stowable")
- **Related:** STOW-CORE-004-ANXIETY-MANAGER (provides anxiety_level signal)

---

## NOTES / QUESTIONS

**Q:** Should items have physics collision or just Area3D detection?  
**A:** Area3D for stow zone detection. RigidBody3D adds complexity without benefit here.

**Q:** How many different item types for MVP?  
**A:** Start with 1 (StandardBox). Add variety in later work orders.

**Q:** Should belt be actual 3D mesh or sprite-based?  
**A:** 3D mesh (Plane with scrolling material). Simpler than sprite animation.

**Q:** What happens if player doesn't stow items fast enough?  
**A:** Items pile up at player zone, anxiety drops per missed item. Max 10 items enforced by spawn rate.

---

## AGENT RESPONSE SECTION

### Implementation Summary
[Agent fills this in upon delivery]

### Files Changed
- [To be filled by CODER agent]

### Known Issues
- [Any limitations or edge cases]

### Next Steps
- Test with placeholder box mesh
- Tune spawn intervals for difficulty curve
- Add item type variety

═══════════════════════════════════════════════════════════════
END WORK ORDER [ID: STOW-CORE-002-CONVEYOR-SYSTEM]
Issued By: ORCHESTRATOR
Issued Date: January 13, 2026
═══════════════════════════════════════════════════════════════
