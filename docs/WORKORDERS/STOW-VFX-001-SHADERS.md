═══════════════════════════════════════════════════════════════
WORK ORDER: STOW-VFX-001-SHADERS
═══════════════════════════════════════════════════════════════

## META
- **ID:** STOW-VFX-001-SHADERS
- **Agent:** CODER
- **Priority:** MEDIUM
- **Status:** PENDING
- **Created:** 2026-01-13

---

## OBJECTIVE

Implement three custom shaders: CRT Glitch (horror effect), Shadow Distortion (Lyon demon form), and Possession Glow (item outline).

---

## CONTEXT

### GDD References
- **Primary:** /docs/BUILD_LOGS/STOW-AI-BUILD-001.md → Shaders

### Dependencies
- **Required Systems:** None (standalone visual effects)
- **Blocks:** None (can be applied later)

---

## DELIVERABLES

- [x] `assets/shaders/CRTGlitch.gdshader` - VHS tracking errors, scanlines, chromatic aberration
- [x] `assets/shaders/ShadowDistortion.gdshader` - Lyon demon form shadow wavering effect
- [x] `assets/shaders/PossessionGlow.gdshader` - Red pulsing outline for possessed items

---

## ACCEPTANCE CRITERIA

```gherkin
Feature: CRT Glitch Shader
  Scenario: Scanline effect
    Given shader applied to top screen
    Then should show horizontal scanlines
    And scanline intensity should increase with lower Rate

  Scenario: Chromatic aberration
    Given Rate < 30%
    Then RGB channels should separate slightly
    And aberration increases as Rate decreases

Feature: Shadow Distortion Shader
  Scenario: Demon form shadow
    Given shader applied to Lyon sprite
    When Lyon in DEMON_PURSUIT state
    Then shadow should waver and distort
    And distortion uses sin wave animation

Feature: Possession Glow Shader
  Scenario: Red outline pulse
    Given shader applied to possessed item
    Then should show red outline
    And outline intensity pulses over time
    And pulse speed increases as item ages
```

---

## IMPLEMENTATION SPECS

### CRTGlitch.gdshader
```glsl
shader_type canvas_item;

uniform float scanline_count : hint_range(100.0, 500.0) = 240.0;
uniform float scanline_intensity : hint_range(0.0, 1.0) = 0.3;
uniform float aberration_amount : hint_range(0.0, 0.01) = 0.002;
uniform float distortion_amount : hint_range(0.0, 0.1) = 0.01;
uniform float time_speed : hint_range(0.0, 5.0) = 1.0;

// Implement: scanlines, chromatic aberration, VHS tracking distortion
```

### ShadowDistortion.gdshader
```glsl
shader_type canvas_item;

uniform float wave_amplitude : hint_range(0.0, 0.1) = 0.02;
uniform float wave_frequency : hint_range(0.0, 10.0) = 3.0;
uniform float wave_speed : hint_range(0.0, 5.0) = 2.0;

// Implement: sin wave distortion on sprite edges
```

### PossessionGlow.gdshader
```glsl
shader_type canvas_item;

uniform vec4 glow_color : source_color = vec4(1.0, 0.0, 0.0, 1.0);
uniform float outline_thickness : hint_range(1.0, 10.0) = 2.0;
uniform float pulse_speed : hint_range(0.0, 5.0) = 2.0;
uniform float pulse_min : hint_range(0.0, 1.0) = 0.5;
uniform float pulse_max : hint_range(0.0, 1.0) = 1.0;

// Implement: outline detection, pulsing alpha modulation
```

---

## VALIDATION

- [ ] Shaders compile without errors
- [ ] Mobile performance: < 1ms per frame per shader
- [ ] Effects scale with uniforms correctly
- [ ] Can be applied via ShaderMaterial to any sprite/viewport

---

## RELATED WORK ORDERS
- **Blocked By:** None (standalone)
- **Related:** Future work orders for applying shaders to scenes

═══════════════════════════════════════════════════════════════
