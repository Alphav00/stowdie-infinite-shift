extends Node2D
## AisleSpawner - Infinite scrolling aisle manager with object pooling
##
## Manages pool of 6 aisle segments that scroll left and recycle.
## Speed scales based on Rate (180-450px/s).
## Corruption level updates based on Rate thresholds.
##
## @tutorial: /docs/BUILD_LOGS/STOW-AI-BUILD-001.md

# ═══════════════════════════════════════════════════════════════════════
# SIGNALS
# ═══════════════════════════════════════════════════════════════════════

## Emitted when aisle spawns (or recycles)
signal aisle_spawned(aisle: Node2D, aisle_id: String)

## Emitted when aisle moves past despawn point
signal aisle_despawned(aisle_id: String)

## Emitted when scroll speed changes
signal scroll_speed_changed(new_speed: float)

## Emitted when corruption level changes
signal corruption_level_changed(level: int)

# ═══════════════════════════════════════════════════════════════════════
# EXPORTS
# ═══════════════════════════════════════════════════════════════════════

@export_group("Scrolling")
@export var base_scroll_speed: float = 180.0
@export var max_scroll_speed: float = 450.0
@export var scroll_enabled: bool = true

@export_group("Object Pooling")
@export var pool_size: int = 6
@export var aisle_spacing: float = 800.0
@export var spawn_x: float = 1200.0
@export var despawn_x: float = -900.0

@export_group("Aisle Scene")
@export var aisle_scene: PackedScene

# ═══════════════════════════════════════════════════════════════════════
# STATE VARIABLES
# ═══════════════════════════════════════════════════════════════════════

## Current scroll speed (updated based on Rate)
var current_scroll_speed: float = 180.0

## Current corruption level (0=CLEAN, 1=DIRTY, 2=BLOODY)
var current_corruption_level: int = 0

## Pool of aisle instances
var aisle_pool: Array[Node2D] = []

## Counter for unique aisle IDs
var aisle_id_counter: int = 0

# ═══════════════════════════════════════════════════════════════════════
# LIFECYCLE
# ═══════════════════════════════════════════════════════════════════════

func _ready() -> void:
	# Connect to GameManager signals
	if GameManager:
		GameManager.rate_changed.connect(_on_rate_changed)
		GameManager.phase_transition.connect(_on_phase_transition)
	
	# Initialize aisle pool
	_initialize_pool()
	
	if OS.is_debug_build():
		print("[AisleSpawner] Initialized with %d aisles" % pool_size)


func _process(delta: float) -> void:
	if not scroll_enabled:
		return
	
	# Update scroll speed based on current Rate
	_update_scroll_speed()
	
	# Move all aisles
	_scroll_aisles(delta)
	
	# Check for recycling
	_check_recycling()

# ═══════════════════════════════════════════════════════════════════════
# POOL MANAGEMENT
# ═══════════════════════════════════════════════════════════════════════

func _initialize_pool() -> void:
	# Create aisle instances
	for i in range(pool_size):
		var aisle: Node2D = _create_aisle()
		
		# Position aisles in a row
		aisle.position.x = spawn_x + (i * aisle_spacing)
		aisle.position.y = 0.0
		
		aisle_pool.append(aisle)
		add_child(aisle)
		
		var aisle_id: String = "aisle_%d" % aisle_id_counter
		aisle.set_meta("aisle_id", aisle_id)
		aisle_id_counter += 1
		
		# Set initial corruption
		if aisle.has_method("set_corruption_level"):
			aisle.set_corruption_level(current_corruption_level)
		
		aisle_spawned.emit(aisle, aisle_id)


func _create_aisle() -> Node2D:
	if aisle_scene:
		return aisle_scene.instantiate() as Node2D
	else:
		# Fallback: create simple sprite placeholder
		var aisle := Node2D.new()
		aisle.name = "Aisle_Placeholder"
		
		# Add visual placeholder (colored rectangle)
		var sprite := ColorRect.new()
		sprite.size = Vector2(64, 128)
		sprite.position = Vector2(-32, -64)
		sprite.color = Color(0.35, 0.35, 0.4, 1.0)
		aisle.add_child(sprite)
		
		return aisle

# ═══════════════════════════════════════════════════════════════════════
# SCROLLING
# ═══════════════════════════════════════════════════════════════════════

func _scroll_aisles(delta: float) -> void:
	var scroll_delta: float = -current_scroll_speed * delta
	
	for aisle in aisle_pool:
		if aisle:
			aisle.position.x += scroll_delta


func _check_recycling() -> void:
	for aisle in aisle_pool:
		if not aisle:
			continue
		
		# Aisle passed despawn point
		if aisle.position.x < despawn_x:
			_recycle_aisle(aisle)


func _recycle_aisle(aisle: Node2D) -> void:
	# Find rightmost aisle
	var rightmost_x: float = despawn_x
	for other_aisle in aisle_pool:
		if other_aisle and other_aisle != aisle:
			rightmost_x = max(rightmost_x, other_aisle.position.x)
	
	# Reposition to right of rightmost aisle
	aisle.position.x = rightmost_x + aisle_spacing
	
	# Update corruption level
	if aisle.has_method("set_corruption_level"):
		aisle.set_corruption_level(current_corruption_level)
	
	# Generate new ID
	var aisle_id: String = "aisle_%d" % aisle_id_counter
	aisle.set_meta("aisle_id", aisle_id)
	aisle_id_counter += 1
	
	# Emit signals
	var old_id: String = aisle.get_meta("aisle_id", "") as String
	if old_id:
		aisle_despawned.emit(old_id)
	
	aisle_spawned.emit(aisle, aisle_id)

# ═══════════════════════════════════════════════════════════════════════
# SPEED & CORRUPTION UPDATES
# ═══════════════════════════════════════════════════════════════════════

func _update_scroll_speed() -> void:
	if not GameManager:
		return
	
	# Calculate speed based on Rate
	# Lower Rate = faster scroll
	var rate_normalized: float = GameManager.current_rate / 100.0
	var new_speed: float = lerp(max_scroll_speed, base_scroll_speed, rate_normalized)
	
	if not is_equal_approx(new_speed, current_scroll_speed):
		current_scroll_speed = new_speed
		scroll_speed_changed.emit(current_scroll_speed)


func _update_corruption_level() -> void:
	if not GameManager:
		return
	
	var rate: float = GameManager.current_rate
	var new_level: int = 0
	
	# Determine corruption level based on Rate thresholds
	if rate > 60.0:
		new_level = 0  # CLEAN
	elif rate > 20.0:
		new_level = 1  # DIRTY
	else:
		new_level = 2  # BLOODY
	
	if new_level != current_corruption_level:
		current_corruption_level = new_level
		corruption_level_changed.emit(current_corruption_level)
		
		# Update all aisles to new corruption level
		for aisle in aisle_pool:
			if aisle and aisle.has_method("set_corruption_level"):
				aisle.set_corruption_level(current_corruption_level)

# ═══════════════════════════════════════════════════════════════════════
# SIGNAL HANDLERS
# ═══════════════════════════════════════════════════════════════════════

func _on_rate_changed(_new_rate: float) -> void:
	_update_corruption_level()


func _on_phase_transition(_new_phase: int) -> void:
	_update_corruption_level()

# ═══════════════════════════════════════════════════════════════════════
# PUBLIC API
# ═══════════════════════════════════════════════════════════════════════

## Get current scroll speed
func get_scroll_speed() -> float:
	return current_scroll_speed


## Get current corruption level
func get_corruption_level() -> int:
	return current_corruption_level


## Pause/resume scrolling
func set_scroll_enabled(enabled: bool) -> void:
	scroll_enabled = enabled

# ═══════════════════════════════════════════════════════════════════════
# DEBUG
# ═══════════════════════════════════════════════════════════════════════

func get_debug_status() -> String:
	return "Speed: %.0f px/s | Corruption: %d | Aisles: %d" % [
		current_scroll_speed,
		current_corruption_level,
		aisle_pool.size()
	]
