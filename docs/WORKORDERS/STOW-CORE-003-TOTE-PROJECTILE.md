═══════════════════════════════════════════════════════════════
WORK ORDER: STOW-CORE-003-TOTE-PROJECTILE
═══════════════════════════════════════════════════════════════

## META
- **ID:** STOW-CORE-003-TOTE-PROJECTILE
- **Agent:** CODER
- **Priority:** HIGH (Core mechanic)
- **Status:** PENDING
- **Created:** January 13, 2026
- **Deadline:** None

---

## OBJECTIVE

Create the ToteProjectile system handling "Swipe to Stow" input, implementing 2:1 slope physics with visual cheat (parabolic arc for tote vs linear shadow), and scoring based on timing/accuracy.

---

## CONTEXT

### GDD References
- **Primary:** New 3D isometric "swipe to stow" mechanic
- **Related:** STOW-AI-BUILD-001.md (stow mechanics concept, though 2D implementation)

### Dependencies
- **Required Systems:** ConveyorSystem (provides items to stow), IsometricCamera3D (for trajectory calculation)
- **Blocked By:** STOW-CORE-001-ISOMETRIC-CAMERA, STOW-CORE-002-CONVEYOR-SYSTEM

### Current State
No existing implementation. This is a new physics-based stowing mechanic replacing the simple "swipe up in zone" from BUILD-001.

---

## DELIVERABLES

### Code Files
- [x] `scripts/Core/ToteProjectile.gd` - Tote physics body with 2:1 slope trajectory
- [x] `scripts/Core/StowInputHandler.gd` - Swipe gesture detection and timing evaluation
- [x] `scenes/Entities/ToteProjectile.tscn` - Tote mesh with shadow sprite

### Shaders (Optional Enhancement)
- [ ] `assets/shaders/ProjectileShadow.gdshader` - Dynamic shadow scaling

### Assets
- [ ] `assets/sprites/items/tote_yellow.png` - Tote sprite/texture
- [ ] `assets/sprites/items/tote_shadow.png` - Circular shadow sprite
- [ ] `assets/audio/sfx/tote_throw.wav` - Tote launch sound
- [ ] `assets/audio/sfx/tote_land_success.wav` - Successful stow impact
- [ ] `assets/audio/sfx/tote_land_miss.wav` - Missed stow impact

### Documentation
- [ ] Update `docs/BUILD_LOGS/STOW-CORE-003.md` with implementation details

---

## ACCEPTANCE CRITERIA (Gherkin Format)

```gherkin
Feature: Swipe to Stow Mechanic

Scenario: Player swipes up to throw tote
  Given an item is in the stow zone (Z <= 5.0)
  And the player is not on cooldown
  When the player swipes upward on screen
  Then a ToteProjectile spawns at player position
  And the tote follows a parabolic arc trajectory
  And the trajectory uses 2:1 slope physics (2 forward : 1 up)
  And the shadow moves linearly (visual cheat)

Scenario: Perfect timing stow (item in sweet spot)
  Given the player swipes to throw tote
  And an item is at Z = 3.0 (sweet spot)
  When the tote trajectory intersects the item
  Then the item is captured successfully
  And AnxietyManager.add_anxiety(15.0) is called
  And "PERFECT" feedback is shown
  And the item disappears (stowed)

Scenario: Good timing stow (item near sweet spot)
  Given the player swipes to throw tote
  And an item is at Z = 4.0 or Z = 2.0 (good range)
  When the tote trajectory intersects the item
  Then the item is captured successfully
  And AnxietyManager.add_anxiety(10.0) is called
  And "GOOD" feedback is shown

Scenario: Missed stow (item too far or too close)
  Given the player swipes to throw tote
  And no items are in trajectory path
  When the tote completes its arc
  Then no item is captured
  And AnxietyManager.subtract_anxiety(5.0) is called
  And "MISS" feedback is shown
  And tote despawns

Scenario: Shadow visual cheat
  Given a tote is in flight
  When the tote follows parabolic arc (Y changes)
  Then the tote's Y position changes with physics
  But the shadow's Y position stays constant (0.0)
  And the shadow's X/Z position tracks tote's X/Z
  And shadow scale decreases as tote rises (perspective illusion)

Scenario: Cooldown prevents spam
  Given the player threw a tote
  When cooldown_timer < 0.5 seconds
  Then new swipe inputs are ignored
  When cooldown_timer >= 0.5 seconds
  Then new swipes are accepted
```

### Performance Criteria
- Trajectory calculation: < 2ms per throw
- Physics update: < 1ms per frame during flight
- Memory: < 10MB for tote + shadow

---

## CONSTRAINTS

### Technical
- [x] Must work on Android 10+ (touch-based swipe input)
- [x] Must maintain 60fps during tote flight
- [x] Must use Godot physics (RigidBody3D or custom kinematic)
- [x] Shadow must NOT be a separate physics body (visual only)

### Design
- [x] 2:1 slope trajectory (2 units forward per 1 unit up)
- [x] Parabolic arc for tote (gravity-affected)
- [x] Linear shadow movement (visual cheat for readability)
- [x] Shadow scale must decrease with height (fake perspective)
- [x] Timing windows: Perfect (±0.5s), Good (±1.0s), Miss (else)

### Performance Budget
- Swipe detection: < 1ms per frame
- Trajectory physics: < 1ms per frame
- Shadow update: < 0.5ms per frame

---

## TECHNICAL SPECIFICATIONS

### ToteProjectile Script
```gdscript
extends RigidBody3D
class_name ToteProjectile

## Trajectory configuration (2:1 slope)
const FORWARD_VELOCITY: float = 8.0  # Units per second (Z-axis)
const UPWARD_VELOCITY: float = 4.0   # Units per second (Y-axis, initial)
const GRAVITY: float = -9.8          # Standard gravity

## Timing windows (Z-axis positions from player)
const PERFECT_ZONE: Vector2 = Vector2(2.5, 3.5)  # Sweet spot
const GOOD_ZONE: Vector2 = Vector2(1.5, 5.0)     # Acceptable range

## Visual components
@onready var shadow_sprite: Sprite3D = $Shadow
@onready var tote_mesh: MeshInstance3D = $ToteMesh

var launch_position: Vector3
var velocity: Vector3
var is_in_flight: bool = false

## Signals
signal item_stowed(item: ConveyorItem, timing_grade: String, score: int)
signal tote_missed()
signal tote_landed()

func launch(from_position: Vector3) -> void:
    launch_position = from_position
    position = from_position
    
    # Set initial velocity (2:1 slope)
    velocity = Vector3(0, UPWARD_VELOCITY, -FORWARD_VELOCITY)
    is_in_flight = true
    
    # Emit audio
    AudioController.play_sfx("tote_throw")

func _physics_process(delta: float) -> void:
    if not is_in_flight:
        return
    
    # Apply gravity to upward velocity
    velocity.y += GRAVITY * delta
    
    # Update position
    position += velocity * delta
    
    # Update shadow (visual cheat)
    shadow_sprite.position.x = position.x
    shadow_sprite.position.z = position.z
    shadow_sprite.position.y = 0.01  # Just above floor
    
    # Shadow scale based on tote height (fake perspective)
    var height_factor: float = clamp(1.0 - (position.y / 5.0), 0.3, 1.0)
    shadow_sprite.scale = Vector3.ONE * height_factor
    
    # Check for item collision
    check_item_collision()
    
    # Check for landing
    if position.y <= 0.0:
        land()

func check_item_collision() -> void:
    # Raycast or Area3D overlap detection for items in trajectory
    # If item found in PERFECT_ZONE -> emit item_stowed with grade "PERFECT"
    # If item found in GOOD_ZONE -> emit item_stowed with grade "GOOD"
    pass  # Implementation details

func land() -> void:
    is_in_flight = false
    emit_signal("tote_landed")
    
    # Play miss sound if no item was caught
    AudioController.play_sfx("tote_land_miss")
    
    # Despawn after brief delay
    await get_tree().create_timer(0.2).timeout
    queue_free()
```

### StowInputHandler Script
```gdscript
extends Node
class_name StowInputHandler

## Swipe detection
@export var min_swipe_distance: float = 50.0  # pixels
@export var max_swipe_time: float = 0.3       # seconds

## Cooldown
@export var throw_cooldown: float = 0.5       # seconds

var swipe_start_position: Vector2
var swipe_start_time: float
var is_swiping: bool = false
var cooldown_timer: float = 0.0

## Signals
signal swipe_detected(direction: Vector2)
signal tote_throw_requested()

func _process(delta: float) -> void:
    cooldown_timer -= delta

func _input(event: InputEvent) -> void:
    if event is InputEventScreenTouch:
        if event.pressed:
            swipe_start_position = event.position
            swipe_start_time = Time.get_ticks_msec() / 1000.0
            is_swiping = true
        else:
            if is_swiping:
                var swipe_vector: Vector2 = event.position - swipe_start_position
                var swipe_time: float = (Time.get_ticks_msec() / 1000.0) - swipe_start_time
                
                # Check if valid upward swipe
                if swipe_vector.length() >= min_swipe_distance \
                   and swipe_time <= max_swipe_time \
                   and swipe_vector.y < -min_swipe_distance * 0.5:  # Upward direction
                    
                    if cooldown_timer <= 0.0:
                        emit_signal("tote_throw_requested")
                        cooldown_timer = throw_cooldown
                
                is_swiping = false
```

### Integration Points
```gdscript
# Signals to connect
# StowInputHandler.tote_throw_requested -> _on_throw_requested
# ToteProjectile.item_stowed -> ConveyorSystem._on_item_stowed
# ToteProjectile.item_stowed -> AnxietyManager._on_item_stowed

# Signals to emit
signal item_stowed(item: ConveyorItem, timing_grade: String, score: int)
signal tote_missed()
```

---

## VALIDATION CHECKLIST

Before marking complete, verify:
- [x] Swipe detection works (upward swipe triggers throw)
- [x] Tote follows 2:1 slope trajectory (2 forward : 1 up)
- [x] Shadow moves linearly (no Y movement)
- [x] Shadow scale decreases with tote height
- [x] Perfect timing zone works (Z = 2.5-3.5)
- [x] Good timing zone works (Z = 1.5-5.0)
- [x] Miss feedback triggers when no item caught
- [x] Cooldown prevents spam (0.5s)
- [x] Performance measured: < 2ms per frame during flight
- [x] Audio plays correctly (throw, land success, land miss)
- [x] AnxietyManager integration tested
- [x] BUILD_LOG created

---

## ADDITIONAL CONTEXT

### 2:1 Slope Mathematics
The "2:1 slope" comes from dimetric projection:
```
Horizontal movement: 2 units
Vertical movement: 1 unit
Slope = rise / run = 1 / 2 = 0.5
```

For trajectory:
```gdscript
velocity.z = -8.0  # Forward (toward aisles)
velocity.y = 4.0   # Upward (initial)
# Ratio: 8:4 = 2:1 ✓
```

### Visual Cheat Justification
**Why separate tote and shadow?**
- **Tote:** Follows real physics (parabolic arc with gravity)
- **Shadow:** Linear XZ movement only, no Y component
- **Result:** Player can track both 3D trajectory AND flat distance simultaneously
- **Benefit:** Easier to judge timing without mental 3D rotation

This is inspired by:
- **Mario 64:** Shadow always directly below character
- **A Link to the Past:** Falling/jumping objects have circular shadow
- **Pac-Man Championship Edition:** Bombs have static shadows during flight

### Timing Window Tuning
```
PERFECT: ±0.5 seconds @ 3.0 units distance
  - Item at Z=3.0, tote intercepts at t=0.375s
  - Window: t ∈ [0.25, 0.50]
  
GOOD: ±1.0 seconds @ 4.0 or 2.0 units distance
  - Item at Z=4.0, tote intercepts at t=0.5s
  - Item at Z=2.0, tote intercepts at t=0.25s
  - Window: t ∈ [0.15, 0.60]
```

**Tuning knob:** Adjust FORWARD_VELOCITY to change difficulty.

---

## RELATED WORK ORDERS

- **Blocked By:** STOW-CORE-001-ISOMETRIC-CAMERA (needs camera for input mapping)
- **Blocked By:** STOW-CORE-002-CONVEYOR-SYSTEM (needs items to stow)
- **Related:** STOW-CORE-004-ANXIETY-MANAGER (receives score signals)

---

## NOTES / QUESTIONS

**Q:** Should tote be RigidBody3D or KinematicBody3D?  
**A:** KinematicBody3D with manual physics. More control, no collision weirdness.

**Q:** How to detect item collision - raycast or Area3D?  
**A:** Area3D overlap. Check on_area_entered signal for ConveyorItem areas.

**Q:** What if two items are in trajectory?  
**A:** Capture the first (closest) item only. Don't multi-stow.

**Q:** Should shadow have actual shader or just sprite scaling?  
**A:** Start with sprite scaling. Add shader if performance allows.

**Q:** Visual feedback for timing grade?  
**A:** TBD - could be text popup, particle effect, or UI flash. Defer to separate work order.

---

## AGENT RESPONSE SECTION

### Implementation Summary
[Agent fills this in upon delivery]

### Files Changed
- [To be filled by CODER agent]

### Known Issues
- [Any limitations or edge cases]

### Next Steps
- Test with real conveyor items
- Tune timing windows based on playtest
- Add visual feedback for grades

═══════════════════════════════════════════════════════════════
END WORK ORDER [ID: STOW-CORE-003-TOTE-PROJECTILE]
Issued By: ORCHESTRATOR
Issued Date: January 13, 2026
═══════════════════════════════════════════════════════════════
