═══════════════════════════════════════════════════════════════
WORK ORDER: STOW-CORE-001-ISOMETRIC-CAMERA
═══════════════════════════════════════════════════════════════

## META
- **ID:** STOW-CORE-001-ISOMETRIC-CAMERA
- **Agent:** CODER
- **Priority:** HIGH (Foundation system)
- **Status:** PENDING
- **Created:** January 13, 2026
- **Deadline:** None

---

## OBJECTIVE

Create an IsometricCamera3D controller that locks the viewport to the "God Angle" (26.565° dimetric projection) with Mode 7-style floor rendering and infinite aisle scrolling logic.

---

## CONTEXT

### GDD References
- **Primary:** New architectural direction (3D isometric replacing 2D dual-viewport)
- **Related:** STOW-AI-BUILD-001.md (conceptual parallels for scrolling and anxiety)

### Dependencies
- **Required Systems:** None (foundation system)
- **Blocks:** ConveyorSystem, ToteProjectile (both need camera reference)

### Current State
No existing implementation. This represents a pivot from the 2D dual-viewport architecture documented in BUILD-001.

---

## DELIVERABLES

### Code Files
- [x] `scripts/Core/IsometricCamera3D.gd` - Camera controller with Mode 7 logic
- [x] `scenes/Camera/IsometricCamera.tscn` - Camera node with viewport setup

### Shaders (if needed)
- [ ] `assets/shaders/Mode7Floor.gdshader` - Perspective floor rendering (optional enhancement)

### Documentation
- [ ] Update `docs/GDD/00_MANIFEST.md` noting architectural pivot
- [ ] Create `docs/BUILD_LOGS/STOW-CORE-001.md` with implementation details

---

## ACCEPTANCE CRITERIA (Gherkin Format)

```gherkin
Feature: Isometric Camera with God Angle

Scenario: Camera maintains proper isometric angle
  Given the camera is initialized
  When the scene loads
  Then the camera rotation_degrees.x equals 26.565
  And the camera rotation_degrees.y equals 45.0
  And the camera projection is ORTHOGONAL

Scenario: Mode 7-style floor scrolling
  Given the camera has a scroll_speed property
  When anxiety_level increases
  Then scroll_speed increases proportionally
  And floor texture scrolls in Z-axis
  And aisle segments spawn/despawn based on scroll position

Scenario: Camera follows player laterally
  Given the player cart exists in the scene
  When the player moves on X-axis
  Then the camera smoothly follows on X-axis
  But camera Z and Y positions remain fixed
  And camera maintains God Angle orientation

Scenario: Viewport bounds maintained
  Given the camera has defined orthogonal size
  When rendering the scene
  Then all gameplay elements fit within 1080x1920 portrait bounds
  And pixel-perfect rendering is maintained
```

### Performance Criteria
- Frame time: < 8ms for camera updates
- Memory usage: < 50MB for camera and viewport
- Scroll smoothness: Zero stutter at 60fps

---

## CONSTRAINTS

### Technical
- [x] Must work on Android 10+ (mobile touch input)
- [x] Must maintain 60fps on mid-range devices
- [x] Must use Godot 4.3 Camera3D with ORTHOGONAL projection
- [x] Must preserve pixel-perfect rendering (texture filter: nearest)

### Design
- [x] God Angle must be exactly 26.565° (arctangent of 0.5, dimetric projection)
- [x] Rotation Y must be 45° (isometric diamond orientation)
- [x] Floor/aisle scrolling must feel infinite (seamless looping)
- [x] Camera must not rotate or tilt during gameplay

### Performance Budget
- Camera transform updates: < 2ms per frame
- Frustum culling: Efficient (only render visible aisles)
- No dynamic shadows (performance cost too high)

---

## TECHNICAL SPECIFICATIONS

### Camera Setup
```gdscript
extends Camera3D
class_name IsometricCamera3D

## The "God Angle" - arctangent of 0.5 for dimetric projection
const GOD_ANGLE: float = 26.565  # degrees

## Orthogonal size for 1080x1920 portrait viewport
@export var ortho_size: float = 10.0

## Scroll speed (units per second)
@export var base_scroll_speed: float = 5.0
@export var max_scroll_speed: float = 15.0

## Smooth follow settings
@export var follow_speed: float = 5.0
@export var follow_offset: Vector3 = Vector3(0, 8, 10)

var current_scroll_speed: float = 0.0
var scroll_position: float = 0.0
var target_follow_position: Vector3
```

### Mode 7 Logic
- **Infinite Scrolling:** Modulo-based position wrapping
- **Perspective Floor:** Fake perspective via texture scaling (optional shader)
- **Aisle Spawning:** Object pooling based on camera scroll_position
- **Culling:** Only render aisles within camera frustum + buffer

### Integration Points
```gdscript
# Signals to emit
signal scroll_speed_changed(new_speed: float)
signal scroll_position_updated(position: float)
signal aisle_spawn_requested(spawn_z: float)
signal aisle_despawn_requested(aisle_id: String)

# Expected connections
# AnxietyManager.anxiety_level_changed -> _on_anxiety_changed
# Player.position_changed -> _on_player_moved
```

---

## VALIDATION CHECKLIST

Before marking complete, verify:
- [x] Camera angle locked to 26.565° X rotation, 45° Y rotation
- [x] Orthogonal projection configured correctly
- [x] Scroll speed scales with anxiety level (via signal)
- [x] Camera follows player on X-axis smoothly
- [x] Floor/aisle scrolling is seamless (no visible seams)
- [x] Performance measured: < 8ms camera update time
- [x] Mobile touch input works (player can move, camera follows)
- [x] Pixel-perfect rendering preserved (no sub-pixel jitter)
- [x] BUILD_LOG created documenting implementation

---

## ADDITIONAL CONTEXT

### Dimetric Projection Mathematics
The "God Angle" of 26.565° comes from:
```
tan(θ) = 0.5
θ = arctan(0.5) = 26.565°
```

This creates the classic isometric "2:1 slope" where:
- Horizontal movement: 2 pixels
- Vertical movement: 1 pixel

### Mode 7 Reference
Mode 7 (SNES) created pseudo-3D floors via:
1. Affine transformations on 2D textures
2. Perspective scaling based on screen Y position
3. Texture scrolling for movement illusion

For Godot 4.3, we can achieve this with:
- **Option A:** True 3D floor plane with repeating texture
- **Option B:** Quad mesh with custom shader for perspective distortion

**Recommendation:** Start with Option A (simpler), add Option B shader if performance allows.

---

## RELATED WORK ORDERS

- **Blocks:** STOW-CORE-002-CONVEYOR (needs camera for positioning)
- **Blocks:** STOW-CORE-003-TOTE-PROJECTILE (needs camera for trajectory calculation)
- **Related:** STOW-CORE-004-ANXIETY-MANAGER (provides anxiety_level signal)

---

## NOTES / QUESTIONS

**Q:** Should the camera support zoom in/out?  
**A:** No. Fixed ortho_size for consistent gameplay. Zoom would break pixel-perfect rendering.

**Q:** How to handle portrait aspect ratio in 3D?  
**A:** Use ortho_size = 10.0 with viewport 1080x1920. Adjust FOV if needed for proper framing.

**Q:** Do we need actual 3D aisles or sprite-based?  
**A:** TBD. Could use 3D MeshInstance3D or Sprite3D billboards. Recommend Sprite3D for performance.

**Q:** Should floor be infinite plane or scrolling quad?  
**A:** Scrolling quad with repeating texture. Infinite plane has precision issues at large distances.

---

## AGENT RESPONSE SECTION

### Implementation Summary
[Agent fills this in upon delivery]

### Files Changed
- [To be filled by CODER agent]

### Known Issues
- [Any limitations or edge cases]

### Next Steps
- Test camera with placeholder aisle geometry
- Integrate AnxietyManager signal for scroll speed
- Add player follow logic

═══════════════════════════════════════════════════════════════
END WORK ORDER [ID: STOW-CORE-001-ISOMETRIC-CAMERA]
Issued By: ORCHESTRATOR
Issued Date: January 13, 2026
═══════════════════════════════════════════════════════════════
