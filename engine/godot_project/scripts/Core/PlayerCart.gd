extends CharacterBody2D
## PlayerCart - Top screen player controller
##
## Vertical-only movement with drag input.
## Stow mechanic: Swipe UP in correct zone when tote full.
## Hide mechanic: Swipe DOWN near shelf, invisible for 2.5s.
##
## @tutorial: /docs/BUILD_LOGS/STOW-AI-BUILD-001.md

# ═══════════════════════════════════════════════════════════════════════
# SIGNALS
# ═══════════════════════════════════════════════════════════════════════

## Emitted when stow is executed (success/failure)
signal stow_executed(success: bool, score: int, aisle_id: String)

## Emitted when hide state changes
signal hide_state_changed(is_hidden: bool)

## Emitted when stow readiness changes (tote full/empty)
signal stow_ready_changed(is_ready: bool)

# ═══════════════════════════════════════════════════════════════════════
# EXPORTS
# ═══════════════════════════════════════════════════════════════════════

@export_group("Movement")
@export var move_speed: float = 250.0
@export var min_y: float = 100.0
@export var max_y: float = 860.0

@export_group("Stow Zone")
@export var stow_zone_min_y: float = 300.0
@export var stow_zone_max_y: float = 500.0
@export var stow_penalty: float = -10.0

@export_group("Hide Mechanic")
@export var hide_duration: float = 2.5
@export var hide_cooldown: float = 1.0
@export var hide_min_distance_to_shelf: float = 100.0

# ═══════════════════════════════════════════════════════════════════════
# STATE VARIABLES
# ═══════════════════════════════════════════════════════════════════════

## Is player currently hidden (invisible to Lyon)
var is_hidden: bool = false:
	set(value):
		if is_hidden != value:
			is_hidden = value
			hide_state_changed.emit(is_hidden)
			_update_visibility()

## Can player stow (tote is full)
var can_stow: bool = false:
	set(value):
		if can_stow != value:
			can_stow = value
			stow_ready_changed.emit(can_stow)

## Hide timer
var hide_timer: float = 0.0

## Hide cooldown timer
var hide_cooldown_timer: float = 0.0

## Is player currently dragging (for input handling)
var is_dragging: bool = false

# ═══════════════════════════════════════════════════════════════════════
# LIFECYCLE
# ═══════════════════════════════════════════════════════════════════════

func _ready() -> void:
	# Add to "player" group for Lyon detection
	add_to_group("player")
	
	# Connect to InputRouter signals
	if InputRouter:
		InputRouter.swipe_detected_in_zone.connect(_on_swipe_detected)
		InputRouter.drag_started.connect(_on_drag_started)
		InputRouter.drag_updated.connect(_on_drag_updated)
		InputRouter.drag_ended.connect(_on_drag_ended)
	
	# Connect to GameManager signals
	if GameManager:
		GameManager.tote_filled.connect(_on_tote_filled)
	
	if OS.is_debug_build():
		print("[PlayerCart] Initialized at position: ", position)


func _process(delta: float) -> void:
	# Update hide duration
	if is_hidden:
		hide_timer += delta
		if hide_timer >= hide_duration:
			is_hidden = false
			hide_timer = 0.0
	
	# Update hide cooldown
	if hide_cooldown_timer > 0.0:
		hide_cooldown_timer -= delta


func _physics_process(_delta: float) -> void:
	# Apply velocity and move
	move_and_slide()
	
	# Clamp position to bounds
	position.y = clampf(position.y, min_y, max_y)

# ═══════════════════════════════════════════════════════════════════════
# INPUT HANDLERS
# ═══════════════════════════════════════════════════════════════════════

func _on_drag_started(_pos: Vector2, zone: int) -> void:
	# Only respond to TOP zone drags
	if zone != InputRouter.Zone.TOP:
		return
	
	is_dragging = true


func _on_drag_updated(delta: Vector2, _pos: Vector2, zone: int) -> void:
	# Only respond to TOP zone drags
	if zone != InputRouter.Zone.TOP or not is_dragging:
		return
	
	# Move vertically with drag (no horizontal movement)
	velocity.y = delta.y / get_process_delta_time()


func _on_drag_ended(_pos: Vector2, zone: int) -> void:
	if zone != InputRouter.Zone.TOP:
		return
	
	is_dragging = false
	velocity = Vector2.ZERO


func _on_swipe_detected(direction: Vector2, _velocity_val: float, zone: int) -> void:
	# Only respond to TOP zone swipes
	if zone != InputRouter.Zone.TOP:
		return
	
	# Determine swipe type
	if direction.y < -0.5:  # Upward swipe
		_attempt_stow()
	elif direction.y > 0.5:  # Downward swipe
		_attempt_hide()

# ═══════════════════════════════════════════════════════════════════════
# STOW MECHANIC
# ═══════════════════════════════════════════════════════════════════════

func _attempt_stow() -> void:
	# Check if tote is full
	if not can_stow:
		if OS.is_debug_build():
			print("[PlayerCart] Cannot stow - tote not full")
		return
	
	# Check if in stow zone
	var in_zone: bool = position.y >= stow_zone_min_y and position.y <= stow_zone_max_y
	
	if in_zone:
		_execute_stow_success()
	else:
		_execute_stow_failure()


func _execute_stow_success() -> void:
	if not GameManager:
		return
	
	var score: int = GameManager.get_tote_score()
	var aisle_id: String = _get_nearest_aisle_id()
	
	# Clear tote
	GameManager.clear_tote()
	can_stow = false
	
	# Emit signal
	stow_executed.emit(true, score, aisle_id)
	
	if OS.is_debug_build():
		print("[PlayerCart] Stow SUCCESS! Score: %d, Aisle: %s" % [score, aisle_id])


func _execute_stow_failure() -> void:
	# Apply penalty
	if GameManager:
		GameManager.subtract_rate(abs(stow_penalty))
		GameManager.trigger_alarm()
	
	# Emit signal
	stow_executed.emit(false, 0, "")
	
	if OS.is_debug_build():
		print("[PlayerCart] Stow FAILED! Wrong zone. Penalty: %.0f Rate" % stow_penalty)


func _get_nearest_aisle_id() -> String:
	# TODO: Query AisleSpawner for nearest aisle
	# For now, return placeholder
	return "aisle_placeholder"

# ═══════════════════════════════════════════════════════════════════════
# HIDE MECHANIC
# ═══════════════════════════════════════════════════════════════════════

func _attempt_hide() -> void:
	# Check cooldown
	if hide_cooldown_timer > 0.0:
		if OS.is_debug_build():
			print("[PlayerCart] Hide on cooldown: %.1fs remaining" % hide_cooldown_timer)
		return
	
	# Check if near shelf (future: raycast or area detection)
	# For now, assume always near shelf if in valid Y range
	var near_shelf: bool = position.y >= min_y and position.y <= max_y
	
	if near_shelf:
		_execute_hide()
	else:
		if OS.is_debug_build():
			print("[PlayerCart] Not near shelf to hide")


func _execute_hide() -> void:
	is_hidden = true
	hide_timer = 0.0
	hide_cooldown_timer = hide_cooldown + hide_duration
	
	if OS.is_debug_build():
		print("[PlayerCart] Hiding for %.1fs" % hide_duration)


func _update_visibility() -> void:
	# Update visual representation
	if is_hidden:
		modulate = Color(1.0, 1.0, 1.0, 0.3)  # Semi-transparent
	else:
		modulate = Color(1.0, 1.0, 1.0, 1.0)  # Fully visible

# ═══════════════════════════════════════════════════════════════════════
# GAMEMANAGER SIGNAL HANDLERS
# ═══════════════════════════════════════════════════════════════════════

func _on_tote_filled(efficiency: float) -> void:
	# Tote was just cleared, so we're no longer ready to stow
	can_stow = false
	
	if OS.is_debug_build():
		print("[PlayerCart] Tote filled at %.0f%% efficiency, now cleared" % (efficiency * 100.0))


# ═══════════════════════════════════════════════════════════════════════
# PUBLIC API
# ═══════════════════════════════════════════════════════════════════════

## Check if player is in stow zone
func is_in_stow_zone() -> bool:
	return position.y >= stow_zone_min_y and position.y <= stow_zone_max_y


## Manually set stow readiness (e.g., from tutorial)
func set_can_stow(value: bool) -> void:
	can_stow = value


## Get current hide state
func get_is_hidden() -> bool:
	return is_hidden


## Force hide (debug/testing)
func force_hide(duration: float = -1.0) -> void:
	if not OS.is_debug_build():
		return
	
	is_hidden = true
	hide_timer = 0.0
	
	if duration > 0.0:
		hide_duration = duration

# ═══════════════════════════════════════════════════════════════════════
# DEBUG
# ═══════════════════════════════════════════════════════════════════════

func _draw() -> void:
	if not OS.is_debug_build():
		return
	
	# Draw stow zone indicator
	var zone_start: float = stow_zone_min_y - position.y
	var zone_end: float = stow_zone_max_y - position.y
	var zone_height: float = zone_end - zone_start
	
	draw_rect(
		Rect2(-20, zone_start, 40, zone_height),
		Color(0.0, 1.0, 0.0, 0.2)
	)


func get_debug_status() -> String:
	return "Pos: (%.0f, %.0f) | Hidden: %s | CanStow: %s | HideCooldown: %.1fs" % [
		position.x,
		position.y,
		"YES" if is_hidden else "NO",
		"YES" if can_stow else "NO",
		hide_cooldown_timer
	]
