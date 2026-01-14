extends CharacterBody2D
## LyonStateMachine - Boss AI with 4-state behavior
##
## States: DORMANT → PATROL → AUDIT → DEMON_PURSUIT
## 
## DORMANT: Tutorial phase, inactive
## PATROL: Roams left at 120px/s, detects player in 350px radius with 120° cone
## AUDIT: Locks in place for 4.5s, evaluates tote efficiency, applies Rate penalty
## DEMON_PURSUIT: Active chase at 280px/s when Rate < 20%, constant -5 Rate/sec drain
##
## @tutorial: /docs/BUILD_LOGS/STOW-AI-BUILD-001.md

# ═══════════════════════════════════════════════════════════════════════
# SIGNALS
# ═══════════════════════════════════════════════════════════════════════

## Emitted when state changes
signal state_changed(new_state: State, old_state: State)

## Emitted when Lyon begins auditing player
signal audit_started()

## Emitted when audit completes with penalty and message
signal audit_completed(rate_penalty: float, message: String)

## Emitted when transforming into demon form
signal demon_transformation_started()

## Emitted when reverting from demon form
signal demon_transformation_ended()

## Emitted when player is spotted
signal player_spotted(player_position: Vector2)

# ═══════════════════════════════════════════════════════════════════════
# ENUMS & CONSTANTS
# ═══════════════════════════════════════════════════════════════════════

enum State {
	DORMANT,        ## Tutorial phase - inactive
	PATROL,         ## Normal phase - roaming behavior
	AUDIT,          ## Inspecting player's tote
	DEMON_PURSUIT   ## Active chase at low Rate
}

# ═══════════════════════════════════════════════════════════════════════
# EXPORT VARIABLES (Designer Tuning)
# ═══════════════════════════════════════════════════════════════════════

@export_group("Movement")
@export var patrol_speed: float = 120.0
@export var demon_speed: float = 280.0

@export_group("Detection")
@export var detection_radius: float = 350.0
@export var vision_cone_angle: float = 120.0

@export_group("Audit")
@export var audit_duration: float = 4.5
@export var audit_penalty_poor: float = -25.0      # < 40% efficiency
@export var audit_penalty_sloppy: float = -15.0    # < 60% efficiency
@export var audit_penalty_acceptable: float = 0.0  # >= 60% efficiency

@export_group("Demon Mode")
@export var demon_rate_drain: float = -5.0  # Per second
@export var demon_trigger_threshold: float = 20.0   # Rate < 20% → demon
@export var demon_recovery_threshold: float = 45.0  # Rate > 45% → revert

@export_group("Patrol Behavior")
@export var stare_chance: float = 0.08  # 8% chance to pause and stare
@export var stare_min_duration: float = 1.5
@export var stare_max_duration: float = 2.5
@export var patrol_check_interval: float = 3.0  # Time between stare checks

# ═══════════════════════════════════════════════════════════════════════
# STATE VARIABLES
# ═══════════════════════════════════════════════════════════════════════

var current_state: State = State.DORMANT:
	set(value):
		if current_state != value:
			var old_state: State = current_state
			current_state = value
			_on_state_entered(current_state, old_state)
			state_changed.emit(current_state, old_state)
			
			if OS.is_debug_build():
				print("[Lyon] State: %s → %s" % [
					State.keys()[old_state],
					State.keys()[current_state]
				])

## Current facing direction (for sprite flipping)
var facing_direction: Vector2 = Vector2.LEFT

# ═══════════════════════════════════════════════════════════════════════
# PATROL STATE VARIABLES
# ═══════════════════════════════════════════════════════════════════════

var patrol_timer: float = 0.0
var is_staring: bool = false
var stare_timer: float = 0.0
var stare_duration: float = 0.0

# ═══════════════════════════════════════════════════════════════════════
# AUDIT STATE VARIABLES
# ═══════════════════════════════════════════════════════════════════════

var audit_timer: float = 0.0

# ═══════════════════════════════════════════════════════════════════════
# LIFECYCLE
# ═══════════════════════════════════════════════════════════════════════

func _ready() -> void:
	# Connect to GameManager signals
	if GameManager:
		GameManager.phase_transition.connect(_on_phase_transition)
		GameManager.rate_changed.connect(_on_rate_changed)
	
	# Initialize state
	current_state = State.DORMANT
	
	if OS.is_debug_build():
		print("[Lyon] Initialized in DORMANT state")


func _physics_process(delta: float) -> void:
	match current_state:
		State.DORMANT:
			_process_dormant(delta)
		State.PATROL:
			_process_patrol(delta)
		State.AUDIT:
			_process_audit(delta)
		State.DEMON_PURSUIT:
			_process_demon_pursuit(delta)
	
	# Apply movement
	move_and_slide()

# ═══════════════════════════════════════════════════════════════════════
# STATE PROCESSING
# ═══════════════════════════════════════════════════════════════════════

func _process_dormant(_delta: float) -> void:
	# No movement, no detection
	velocity = Vector2.ZERO


func _process_patrol(delta: float) -> void:
	patrol_timer += delta
	
	# Handle stare behavior
	if is_staring:
		stare_timer += delta
		velocity = Vector2.ZERO
		
		# Face player during stare
		var player: Node2D = _get_player()
		if player:
			_face_towards(player.global_position)
		
		# End stare
		if stare_timer >= stare_duration:
			is_staring = false
			stare_timer = 0.0
			patrol_timer = 0.0
		
		return
	
	# Normal patrol movement
	velocity = Vector2.LEFT * patrol_speed
	facing_direction = Vector2.LEFT
	
	# Check for random stare pause
	if patrol_timer >= patrol_check_interval:
		if randf() <= stare_chance:
			_start_stare()
		else:
			patrol_timer = 0.0
	
	# Check for player detection
	if _can_see_player():
		var player: Node2D = _get_player()
		if player:
			player_spotted.emit(player.global_position)
			current_state = State.AUDIT


func _process_audit(delta: float) -> void:
	audit_timer += delta
	
	# Lock in place
	velocity = Vector2.ZERO
	
	# Face player
	var player: Node2D = _get_player()
	if player:
		_face_towards(player.global_position)
	
	# Complete audit
	if audit_timer >= audit_duration:
		_complete_audit()


func _process_demon_pursuit(delta: float) -> void:
	# Apply constant Rate drain
	if GameManager:
		GameManager.subtract_rate(abs(demon_rate_drain) * delta)
	
	# Chase player
	var player: Node2D = _get_player()
	if player:
		var direction: Vector2 = (player.global_position - global_position).normalized()
		velocity = direction * demon_speed
		_face_towards(player.global_position)
	else:
		velocity = Vector2.ZERO
	
	# Check for Rate recovery (revert to PATROL)
	if GameManager and GameManager.current_rate >= demon_recovery_threshold:
		demon_transformation_ended.emit()
		current_state = State.PATROL

# ═══════════════════════════════════════════════════════════════════════
# STATE TRANSITIONS
# ═══════════════════════════════════════════════════════════════════════

func _on_state_entered(new_state: State, _old_state: State) -> void:
	match new_state:
		State.DORMANT:
			velocity = Vector2.ZERO
		
		State.PATROL:
			patrol_timer = 0.0
			is_staring = false
			facing_direction = Vector2.LEFT
		
		State.AUDIT:
			audit_timer = 0.0
			audit_started.emit()
		
		State.DEMON_PURSUIT:
			demon_transformation_started.emit()


func _on_phase_transition(new_phase: int) -> void:
	# Transition from DORMANT to PATROL when entering NORMAL phase
	if current_state == State.DORMANT and new_phase == GameManager.Phase.NORMAL:
		current_state = State.PATROL


func _on_rate_changed(new_rate: float) -> void:
	# Trigger demon mode if Rate drops too low (and not in DORMANT/AUDIT)
	if current_state == State.PATROL and new_rate < demon_trigger_threshold:
		current_state = State.DEMON_PURSUIT

# ═══════════════════════════════════════════════════════════════════════
# PATROL BEHAVIORS
# ═══════════════════════════════════════════════════════════════════════

func _start_stare() -> void:
	is_staring = true
	stare_timer = 0.0
	stare_duration = randf_range(stare_min_duration, stare_max_duration)
	
	if OS.is_debug_build():
		print("[Lyon] Starting stare for %.1fs" % stare_duration)

# ═══════════════════════════════════════════════════════════════════════
# AUDIT BEHAVIORS
# ═══════════════════════════════════════════════════════════════════════

func _complete_audit() -> void:
	var efficiency: float = 0.0
	var penalty: float = 0.0
	var message: String = ""
	
	if GameManager:
		efficiency = GameManager.get_tote_efficiency()
		
		# Determine penalty based on efficiency
		if efficiency < 0.4:
			penalty = audit_penalty_poor
			message = "This is unacceptable"
		elif efficiency < 0.6:
			penalty = audit_penalty_sloppy
			message = "Sloppy work"
		else:
			penalty = audit_penalty_acceptable
			message = "...Acceptable"
		
		# Apply penalty
		if penalty < 0.0:
			GameManager.subtract_rate(abs(penalty))
	
	# Emit signal
	audit_completed.emit(penalty, message)
	
	# Return to PATROL
	current_state = State.PATROL
	
	if OS.is_debug_build():
		print("[Lyon] Audit complete: %.0f%% efficiency, %.0f Rate penalty, '%s'" % [
			efficiency * 100.0,
			penalty,
			message
		])

# ═══════════════════════════════════════════════════════════════════════
# DETECTION SYSTEM
# ═══════════════════════════════════════════════════════════════════════

func _can_see_player() -> bool:
	var player: Node2D = _get_player()
	
	# No player found
	if not player:
		return false
	
	# Player is hidden
	if player.has_method("is_hidden") and player.is_hidden:
		return false
	
	# Check property variant
	if "is_hidden" in player and player.is_hidden:
		return false
	
	# Check distance
	var distance: float = global_position.distance_to(player.global_position)
	if distance > detection_radius:
		return false
	
	# Check vision cone
	var direction_to_player: Vector2 = (player.global_position - global_position).normalized()
	var angle: float = facing_direction.angle_to(direction_to_player)
	var half_cone: float = deg_to_rad(vision_cone_angle / 2.0)
	
	return abs(angle) <= half_cone


func _get_player() -> Node2D:
	return get_tree().get_first_node_in_group("player") as Node2D

# ═══════════════════════════════════════════════════════════════════════
# UTILITY METHODS
# ═══════════════════════════════════════════════════════════════════════

func _face_towards(target_position: Vector2) -> void:
	var direction: Vector2 = (target_position - global_position).normalized()
	
	# Update facing direction
	if direction.x < 0.0:
		facing_direction = Vector2.LEFT
		scale.x = 1.0  # Face left
	else:
		facing_direction = Vector2.RIGHT
		scale.x = -1.0  # Face right (flip sprite)

# ═══════════════════════════════════════════════════════════════════════
# PUBLIC API
# ═══════════════════════════════════════════════════════════════════════

## Get current state
func get_current_state() -> State:
	return current_state


## Force state change (debug/testing only)
func force_state(state: State) -> void:
	if not OS.is_debug_build():
		push_error("[Lyon] force_state should only be used in debug builds")
		return
	
	current_state = state

# ═══════════════════════════════════════════════════════════════════════
# DEBUG HELPERS
# ═══════════════════════════════════════════════════════════════════════

## Draw debug visualization (detection radius and vision cone)
func _draw() -> void:
	if not OS.is_debug_build():
		return
	
	# Draw detection radius
	draw_circle(Vector2.ZERO, detection_radius, Color(1.0, 0.0, 0.0, 0.1))
	
	# Draw vision cone
	var half_cone: float = deg_to_rad(vision_cone_angle / 2.0)
	var cone_points: PackedVector2Array = [Vector2.ZERO]
	
	for i in range(13):  # 12 segments
		var angle: float = facing_direction.angle() + lerp(-half_cone, half_cone, float(i) / 12.0)
		var point: Vector2 = Vector2(cos(angle), sin(angle)) * detection_radius
		cone_points.append(point)
	
	cone_points.append(Vector2.ZERO)
	draw_colored_polygon(cone_points, Color(1.0, 0.0, 0.0, 0.2))


## Get debug status string
func get_debug_status() -> String:
	return "State: %s | Velocity: (%.0f, %.0f) | Facing: %s" % [
		State.keys()[current_state],
		velocity.x,
		velocity.y,
		"LEFT" if facing_direction == Vector2.LEFT else "RIGHT"
	]
