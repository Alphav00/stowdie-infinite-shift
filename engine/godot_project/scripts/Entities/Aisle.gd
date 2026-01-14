extends Node2D
## Aisle - Individual aisle segment with corruption states
##
## Handles visual representation of corruption levels and horror spawns.
## Corruption levels: 0=CLEAN, 1=DIRTY, 2=BLOODY
##
## @tutorial: /docs/BUILD_LOGS/STOW-AI-BUILD-001.md

# ═══════════════════════════════════════════════════════════════════════
# SIGNALS
# ═══════════════════════════════════════════════════════════════════════

## Emitted when corruption level changes
signal corruption_changed(old_level: int, new_level: int)

## Emitted when horror element spawns
signal horror_spawned(horror_type: String, position: Vector2)

# ═══════════════════════════════════════════════════════════════════════
# ENUMS & CONSTANTS
# ═══════════════════════════════════════════════════════════════════════

enum CorruptionLevel {
	CLEAN,   ## Rate > 60% - Pristine warehouse
	DIRTY,   ## Rate 20-60% - Stained and neglected
	BLOODY   ## Rate < 20% - Horror corruption
}

const BLOOD_CHANCE_NORMAL: float = 0.05   # 5% in normal phase
const BLOOD_CHANCE_DEMON: float = 0.35    # 35% in demon hour

# Graffiti message pool
const GRAFFITI_MESSAGES: PackedStringArray = [
	"STOWAWAY",
	"LEFT BEHIND",
	"RUN",
	"PROBLEM SOLVED",
	"IT'S WATCHING"
]

# ═══════════════════════════════════════════════════════════════════════
# EXPORTS
# ═══════════════════════════════════════════════════════════════════════

@export_group("Sprites")
@export var sprite_clean: Texture2D
@export var sprite_dirty: Texture2D
@export var sprite_bloody: Texture2D

@export_group("Horror Spawns")
@export var enable_blood_decals: bool = true
@export var enable_graffiti: bool = true
@export var max_decals_per_aisle: int = 3

# ═══════════════════════════════════════════════════════════════════════
# STATE VARIABLES
# ═══════════════════════════════════════════════════════════════════════

var current_corruption_level: CorruptionLevel = CorruptionLevel.CLEAN

## Reference to main sprite node
var main_sprite: Sprite2D

## Container for horror elements
var horror_container: Node2D

# ═══════════════════════════════════════════════════════════════════════
# LIFECYCLE
# ═══════════════════════════════════════════════════════════════════════

func _ready() -> void:
	_setup_nodes()
	_update_visual()


func _setup_nodes() -> void:
	# Find or create main sprite
	main_sprite = get_node_or_null("Sprite2D") as Sprite2D
	if not main_sprite:
		main_sprite = Sprite2D.new()
		main_sprite.name = "Sprite2D"
		add_child(main_sprite)
	
	# Create horror container
	horror_container = Node2D.new()
	horror_container.name = "HorrorElements"
	add_child(horror_container)

# ═══════════════════════════════════════════════════════════════════════
# CORRUPTION SYSTEM
# ═══════════════════════════════════════════════════════════════════════

func set_corruption_level(level: int) -> void:
	var old_level: CorruptionLevel = current_corruption_level
	current_corruption_level = level as CorruptionLevel
	
	if old_level != current_corruption_level:
		_update_visual()
		_spawn_horror_elements()
		corruption_changed.emit(int(old_level), int(current_corruption_level))


func get_corruption_level() -> int:
	return int(current_corruption_level)

# ═══════════════════════════════════════════════════════════════════════
# VISUAL UPDATES
# ═══════════════════════════════════════════════════════════════════════

func _update_visual() -> void:
	if not main_sprite:
		return
	
	# Update sprite based on corruption level
	match current_corruption_level:
		CorruptionLevel.CLEAN:
			if sprite_clean:
				main_sprite.texture = sprite_clean
			else:
				# Fallback: light gray
				main_sprite.modulate = Color(0.7, 0.7, 0.75, 1.0)
		
		CorruptionLevel.DIRTY:
			if sprite_dirty:
				main_sprite.texture = sprite_dirty
			else:
				# Fallback: darker, desaturated
				main_sprite.modulate = Color(0.5, 0.5, 0.55, 1.0)
		
		CorruptionLevel.BLOODY:
			if sprite_bloody:
				main_sprite.texture = sprite_bloody
			else:
				# Fallback: very dark with red tint
				main_sprite.modulate = Color(0.3, 0.2, 0.25, 1.0)

# ═══════════════════════════════════════════════════════════════════════
# HORROR SPAWNS
# ═══════════════════════════════════════════════════════════════════════

func _spawn_horror_elements() -> void:
	# Clear existing horror elements
	_clear_horror_elements()
	
	# Only spawn in DIRTY and BLOODY levels
	if current_corruption_level == CorruptionLevel.CLEAN:
		return
	
	# Determine spawn chance
	var spawn_chance: float = BLOOD_CHANCE_NORMAL
	if GameManager and GameManager.is_demon_hour():
		spawn_chance = BLOOD_CHANCE_DEMON
	
	# Spawn blood decals
	if enable_blood_decals and current_corruption_level >= CorruptionLevel.DIRTY:
		_spawn_blood_decals(spawn_chance)
	
	# Spawn graffiti
	if enable_graffiti and current_corruption_level == CorruptionLevel.BLOODY:
		_spawn_graffiti()


func _spawn_blood_decals(spawn_chance: float) -> void:
	var num_decals: int = 0
	
	for i in range(max_decals_per_aisle):
		if randf() > spawn_chance:
			continue
		
		num_decals += 1
		
		# Create blood decal placeholder
		var decal := ColorRect.new()
		decal.size = Vector2(randf_range(16.0, 32.0), randf_range(12.0, 24.0))
		decal.color = Color(0.54, 0.0, 0.0, 0.8)  # Dark red
		
		# Random position on aisle
		decal.position = Vector2(
			randf_range(-30.0, 30.0),
			randf_range(-50.0, 50.0)
		)
		
		horror_container.add_child(decal)
		horror_spawned.emit("blood_decal", decal.position)
	
	if OS.is_debug_build() and num_decals > 0:
		print("[Aisle] Spawned %d blood decals" % num_decals)


func _spawn_graffiti() -> void:
	# 50% chance to spawn graffiti in bloody level
	if randf() > 0.5:
		return
	
	# Create graffiti text
	var label := Label.new()
	label.text = GRAFFITI_MESSAGES.pick_random()
	label.add_theme_font_size_override("font_size", 16)
	label.add_theme_color_override("font_color", Color(0.4, 0.9, 0.4, 0.9))  # Sickly green
	
	# Random position
	label.position = Vector2(
		randf_range(-40.0, 40.0),
		randf_range(-40.0, 40.0)
	)
	
	# Random rotation
	label.rotation_degrees = randf_range(-15.0, 15.0)
	
	horror_container.add_child(label)
	horror_spawned.emit("graffiti", label.position)
	
	if OS.is_debug_build():
		print("[Aisle] Spawned graffiti: '%s'" % label.text)


func _clear_horror_elements() -> void:
	if not horror_container:
		return
	
	# Remove all children
	for child in horror_container.get_children():
		child.queue_free()

# ═══════════════════════════════════════════════════════════════════════
# PUBLIC API
# ═══════════════════════════════════════════════════════════════════════

## Check if aisle has stow zone (future enhancement)
func has_stow_zone() -> bool:
	return false


## Get stow zone position (future enhancement)
func get_stow_zone_position() -> Vector2:
	return Vector2.ZERO

# ═══════════════════════════════════════════════════════════════════════
# DEBUG
# ═══════════════════════════════════════════════════════════════════════

func get_debug_status() -> String:
	return "Corruption: %s | Horror Elements: %d" % [
		CorruptionLevel.keys()[current_corruption_level],
		horror_container.get_child_count() if horror_container else 0
	]
