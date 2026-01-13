# WORK ORDER TEMPLATE

```
═══════════════════════════════════════════════════════════════
WORK ORDER [ID: STOW-XXX-COMPONENT]
PROJECT: StowOrDie: Infinite Shift
ASSIGNED TO: [Agent Role]
ISSUED BY: Orchestrator (Claude Sonnet 4.5)
ISSUED DATE: [YYYY-MM-DD]
PRIORITY: [LOW | MEDIUM | HIGH | CRITICAL]
═══════════════════════════════════════════════════════════════
```

## MISSION BRIEF

**Objective:**  
[One-sentence description of what needs to be built/fixed/documented]

**Context:**  
[1-2 paragraphs explaining why this work order exists, how it fits into the broader project, and what problem it solves]

**Success Criteria:**  
- [ ] [Measurable outcome 1]
- [ ] [Measurable outcome 2]
- [ ] [Measurable outcome 3]

---

## SIGNAL PACKET (Required Context)

### DEPENDENCIES
- **Required Files:**  
  - `path/to/file1.gd`
  - `path/to/file2.tscn`
- **Required Signals:**  
  - `signal_name(params)` from `SourceNode`
- **Required Autoloads:**  
  - `GameManager` (Rate, Phase)
  - `AudioController` (SFX playback)

### INTEGRATION POINTS
[Describe how this component connects to existing systems]

### CONSTRAINTS
- **Technical:**  
  - Must run at 60fps on mid-range Android
  - Memory budget: [X MB]
  - Must use static typing
- **Design:**  
  - Must follow signal-based architecture
  - Must be mobile-touch compatible

---

## DELIVERABLES

### PRIMARY ARTIFACTS
1. **File:** `path/to/script.gd`  
   **Type:** GDScript  
   **Purpose:** [What this file does]

2. **File:** `path/to/scene.tscn`  
   **Type:** Scene  
   **Purpose:** [What this scene represents]

### DOCUMENTATION
- [ ] Inline code comments (GDScript docstrings)
- [ ] README update (if new feature)
- [ ] GDD update (if design change)

---

## ACCEPTANCE CRITERIA (Gherkin Format)

```gherkin
Feature: [Feature Name]

Scenario: [Primary Happy Path]
  Given [initial state]
  And [additional context]
  When [action is performed]
  Then [expected outcome]
  And [additional expected state]

Scenario: [Edge Case 1]
  Given [edge case setup]
  When [edge case trigger]
  Then [graceful handling]

Scenario: [Error Condition]
  Given [error setup]
  When [error occurs]
  Then [error handling behavior]
```

---

## IMPLEMENTATION GUIDANCE

### ARCHITECTURE PATTERN
[Specify the design pattern: State Machine, Observer, Factory, etc.]

### CODE STRUCTURE
```gdscript
# Pseudocode or structural outline
class_name ComponentName
extends BaseType

## EXPORTS
@export var config_value: Type

## STATE
var internal_state: Type

## LIFECYCLE
func _ready() -> void:
    pass

func _process(delta: float) -> void:
    pass

## PUBLIC API
func public_method(param: Type) -> ReturnType:
    pass

## PRIVATE HELPERS
func _private_helper() -> void:
    pass

## SIGNALS
signal event_occurred(data: Type)
```

### VALIDATION STEPS
1. Test in isolation (unit test if possible)
2. Integrate with dependent systems
3. Test on mobile device (real hardware or emulator)
4. Profile performance (fps counter, memory profiler)

---

## REFERENCE MATERIALS

### RELATED GDD SECTIONS
- [Link to GDD doc, specific section]

### EXISTING CODE
- `path/to/similar/implementation.gd` (reference example)

### EXTERNAL RESOURCES
- [Link to Godot docs]
- [Link to design pattern explanation]

---

## AGENT-SPECIFIC NOTES

### FOR IMPLEMENTER:
[Code-generation-specific instructions]

### FOR AUDITOR:
[What to verify during code review]

### FOR SCRIBE:
[Documentation requirements]

---

## EDGE CASES & FAQ

**Q:** [Common question about this task]  
**A:** [Answer or approach]

**Q:** [Edge case scenario]  
**A:** [How to handle it]

---

## STATUS TRACKING

**Current Status:** [ QUEUED | IN PROGRESS | BLOCKED | REVIEW | COMPLETE ]

**Blocked By:** [List any blocking dependencies]

**Estimated Effort:** [X hours / Y story points]

**Actual Effort:** [Filled in upon completion]

---

## CHANGELOG

| Date | Status Change | Notes |
|------|---------------|-------|
| YYYY-MM-DD | QUEUED | Work order created |
| YYYY-MM-DD | IN PROGRESS | Assigned to [Agent] |
| YYYY-MM-DD | COMPLETE | Merged into main |

---

```
═══════════════════════════════════════════════════════════════
END WORK ORDER [ID: STOW-XXX-COMPONENT]
═══════════════════════════════════════════════════════════════
```

---

## TEMPLATE USAGE INSTRUCTIONS

### Creating a New Work Order

1. **Copy this template** to a new file: `STOW-XXX-COMPONENTNAME.md`
2. **Replace placeholder values:**
   - `XXX` → Sequential number (e.g., `001`, `002`)
   - `COMPONENT` → Brief descriptor (e.g., `LYON-AI`, `ITEM-PHYSICS`)
3. **Fill all sections** - No section should remain empty or placeholder text
4. **Commit** with message: `[WO] Create STOW-XXX-COMPONENTNAME`

### Work Order Naming Convention

```
STOW-[CATEGORY]-[NUMBER]-[COMPONENT]

Categories:
- AI    : Artificial intelligence systems
- PHYS  : Physics and collision
- UI    : User interface
- AUDIO : Sound and music
- VFX   : Visual effects and shaders
- DATA  : Data structures and managers
- POLISH: Optimization and refinement

Examples:
- STOW-AI-001-LYON-STATE-MACHINE
- STOW-PHYS-002-ITEM-EXPANSION
- STOW-UI-003-HUD-RATE-METER
```

### Agent Assignment Protocol

**Architect** → High-level system design, architecture decisions  
**Implementer** → Code generation, scene construction  
**Auditor** → Code review, testing, validation  
**Scribe** → Documentation updates, README maintenance

---

## BEST PRACTICES

1. **Be Specific:** Vague requirements lead to vague implementations
2. **Provide Context:** Explain the "why" not just the "what"
3. **Link Liberally:** Reference GDD sections, existing code, external docs
4. **Test Thoroughly:** Define clear success criteria before starting
5. **Update Promptly:** Keep status and changelog current

---

**Template Version:** 1.0.0  
**Last Updated:** January 13, 2026  
**Maintainer:** Chi (@Alphav00)
