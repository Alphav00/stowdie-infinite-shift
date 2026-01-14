═══════════════════════════════════════════════════════════════
WORK ORDER: STOW-CORE-002-INPUT-ROUTER
═══════════════════════════════════════════════════════════════

## META
- **ID:** STOW-CORE-002-INPUT-ROUTER
- **Agent:** CODER
- **Priority:** HIGH
- **Status:** PENDING
- **Created:** 2026-01-13
- **Deadline:** None

---

## OBJECTIVE

Implement InputRouter singleton that detects and routes touch gestures (tap, swipe, drag) to appropriate screen zones.

---

## CONTEXT

### GDD References
- **Primary:** /docs/BUILD_LOGS/STOW-AI-BUILD-001.md → Signal Architecture → InputRouter Signals
- **Secondary:** Mobile-first touch input requirements

### Dependencies
- **Required Files:** None (foundational singleton)
- **Required Systems:** None
- **Blocks:** 
  - STOW-CORE-003-PLAYER-CART (needs swipe detection)
  - Future bottom screen drag mechanics

### Current State
No existing implementation. AutoLoad registered in project.godot at `/root/InputRouter`.

---

## DELIVERABLES

### Code Files
- [x] `scripts/_Autoloads/InputRouter.gd` - Complete gesture detection singleton

### Documentation
- [x] Update `docs/BUILD_LOGS/STOW-AI-BUILD-002.md` with InputRouter implementation notes

---

## ACCEPTANCE CRITERIA (Gherkin Format)

```gherkin
Feature: Tap Detection

Scenario: Simple tap on top screen
  Given finger touches screen at position (540, 500)
  And finger releases within 0.3 seconds
  And finger moved < 20 pixels
  When finger releases
  Then tap_detected signal should emit with position (540, 500) and zone TOP

Scenario: Tap on bottom screen
  Given finger touches screen at position (540, 1500)
  When tap is completed
  Then tap_detected signal should emit with zone BOTTOM

Feature: Swipe Detection

Scenario: Upward swipe in stow zone
  Given finger touches at (540, 800)
  And finger drags upward 150 pixels
  And drag completes in < 0.5 seconds
  When finger releases
  Then swipe_detected signal should emit with direction (0, -1) and velocity > 300

Scenario: Downward swipe for hiding
  Given finger touches at (540, 400)
  And finger drags downward 100 pixels
  When swipe completes
  Then swipe_detected signal should emit with direction (0, 1)

Scenario: Swipe too slow (becomes drag)
  Given finger touches screen
  And finger drags over 1.0 second
  When finger releases
  Then should emit drag_ended, NOT swipe_detected

Feature: Drag Detection

Scenario: Dragging an item
  Given finger touches at (540, 1200) in BOTTOM zone
  When finger starts moving
  Then drag_started signal should emit with position and zone BOTTOM
  
Scenario: Continuous drag updates
  Given drag is active
  When finger moves to new position
  Then drag_updated signal should emit with delta and position

Scenario: Drag completion
  Given drag is active
  When finger releases
  Then drag_ended signal should emit with final position

Feature: Zone Detection

Scenario: Touch in top half of screen
  Given viewport height is 1920
  When touch occurs at y < 960
  Then zone should be TOP

Scenario: Touch in bottom half of screen
  Given viewport height is 1920
  When touch occurs at y >= 960
  Then zone should be BOTTOM
```

### Performance Criteria
- Frame time: < 0.2ms per input event
- Memory usage: < 2MB
- No dropped input events

---

## CONSTRAINTS

### Technical
- [x] Must be AutoLoad singleton at `/root/InputRouter`
- [x] Must use InputEvent system (not raw touch polling)
- [x] Must work identically on Android and desktop (mouse emulation)
- [x] Must handle multi-touch (track first touch only, ignore others)

### Design
- [x] Screen split: Top (0-959px), Bottom (960-1919px) on 1080x1920 viewport
- [x] Tap threshold: < 20px movement, < 0.3s duration
- [x] Swipe threshold: > 50px movement, < 0.5s duration, velocity > 300px/s
- [x] Drag: Any touch held > 0.15s or moved > 50px slowly

### Performance Budget
- Logic: < 0.2ms per input event

---

## VALIDATION CHECKLIST

Before marking complete:
- [ ] All acceptance criteria pass
- [ ] Signals emit with correct typed parameters
- [ ] No input lag (immediate signal emission)
- [ ] Works with mouse emulation (desktop testing)
- [ ] Multi-touch handled (ignores secondary touches)
- [ ] Static typing throughout
- [ ] Performance measured < 0.2ms per event
- [ ] Documentation created in BUILD_LOGS

---

## IMPLEMENTATION SPECIFICATIONS

### Required Enums
```gdscript
enum Zone { TOP, BOTTOM }
enum GestureType { TAP, SWIPE, DRAG }
```

### Required Signals
```gdscript
signal tap_detected(position: Vector2, zone: Zone)
signal swipe_detected(direction: Vector2, velocity: float)
signal swipe_detected_in_zone(direction: Vector2, velocity: float, zone: Zone)
signal drag_started(position: Vector2, zone: Zone)
signal drag_updated(delta: Vector2, position: Vector2, zone: Zone)
signal drag_ended(position: Vector2, zone: Zone)
```

### Required Properties
```gdscript
# Gesture thresholds
const TAP_MAX_DISTANCE: float = 20.0
const TAP_MAX_DURATION: float = 0.3
const SWIPE_MIN_DISTANCE: float = 50.0
const SWIPE_MAX_DURATION: float = 0.5
const SWIPE_MIN_VELOCITY: float = 300.0
const DRAG_START_DELAY: float = 0.15

# Touch state tracking
var is_touching: bool = false
var touch_start_position: Vector2
var touch_start_time: float
var current_touch_position: Vector2
```

### Required Methods
```gdscript
func _input(event: InputEvent) -> void
func _get_zone_from_position(pos: Vector2) -> Zone
func _calculate_velocity(start_pos: Vector2, end_pos: Vector2, duration: float) -> float
func _is_tap(distance: float, duration: float) -> bool
func _is_swipe(distance: float, duration: float, velocity: float) -> bool
```

### Gesture Detection Logic
1. **Touch Start:** Record position, time, set is_touching = true
2. **Touch Move:** Update current_touch_position
   - If moved > 50px and > 0.15s since start → emit drag_started (once)
   - If drag active → emit drag_updated
3. **Touch End:** Calculate distance and duration
   - Check for tap → emit tap_detected
   - Check for swipe → emit swipe_detected
   - If drag was active → emit drag_ended

---

## ADDITIONAL CONTEXT

**Multi-Touch Handling:**
- Track only the first touch (index 0)
- Ignore all other simultaneous touches
- Reset on first touch release, then can track a new touch

**Desktop Testing:**
- Mouse clicks should behave as taps
- Mouse drag should behave as touch drag
- Use InputEvent.is_action_pressed/released for compatibility

**Zone Detection:**
- Use viewport size from get_viewport().get_visible_rect().size
- Split at midpoint: y < (viewport_height / 2) = TOP
- Zone detection happens on every signal emission

**Velocity Calculation:**
```gdscript
velocity = distance / duration
# For swipe direction: (end_pos - start_pos).normalized()
```

---

## RELATED WORK ORDERS

- **Blocks:** 
  - STOW-CORE-003-PLAYER-CART
  - Future bottom screen item dragging

- **Blocked By:** None (foundational system)

---

## NOTES / QUESTIONS

Q: What if user drags from TOP to BOTTOM zone?  
A: Use zone from where touch *started* for consistency.

Q: Should we support pinch/zoom gestures?  
A: No. Single-touch only for this mobile game.

Q: Cancel gesture if finger leaves screen bounds?  
A: Yes. Treat as drag_ended or cancelled gesture.

---

## AGENT RESPONSE SECTION

### Implementation Summary
[CODER will fill this in upon delivery]

### Files Changed
- `scripts/_Autoloads/InputRouter.gd` - [What was implemented]

### Known Issues
- [Any limitations or edge cases]

### Next Steps
- [Recommendations for follow-up work]

═══════════════════════════════════════════════════════════════
END WORK ORDER [ID: STOW-CORE-002-INPUT-ROUTER]
Issued By: ORCHESTRATOR
Issued Date: 2026-01-13
═══════════════════════════════════════════════════════════════
