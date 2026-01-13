# SaveManager.gd
# Singleton managing save data persistence (high scores, settings, unlocks)
extends Node

## CONSTANTS
const SAVE_PATH = "user://stowdie_save.json"
const BACKUP_SAVE_PATH = "user://stowdie_save_backup.json"

## SIGNALS
signal save_loaded()
signal save_failed(error: String)
signal high_score_updated(new_high_score: int)

## DATA STRUCTURE
var save_data: Dictionary = {
	"high_score": 0,
	"total_shifts": 0,
	"total_time_played": 0.0,
	"settings": {
		"music_volume": 0.0,
		"sfx_volume": 0.0,
	},
	"unlocks": [],
	"version": "0.1.0"
}

func _ready() -> void:
	load_game()
	print("[SaveManager] Initialized - Save path: %s" % SAVE_PATH)

## SAVE/LOAD
func save_game() -> bool:
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		var error = FileAccess.get_open_error()
		push_error("[SaveManager] Failed to open save file: %s" % error)
		save_failed.emit("Failed to open save file: %s" % error)
		return false
	
	var json_string = JSON.stringify(save_data, "\t")
	file.store_string(json_string)
	file.close()
	
	# Create backup
	_create_backup()
	
	print("[SaveManager] 💾 Game saved successfully")
	return true

func load_game() -> bool:
	if not FileAccess.file_exists(SAVE_PATH):
		print("[SaveManager] No save file found, using defaults")
		save_game()  # Create initial save
		return true
	
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		var error = FileAccess.get_open_error()
		push_error("[SaveManager] Failed to open save file: %s" % error)
		
		# Try to load backup
		if _load_backup():
			return true
		
		save_failed.emit("Failed to load save file: %s" % error)
		return false
	
	var json_string = file.get_as_text()
	file.close()
	
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	
	if parse_result != OK:
		push_error("[SaveManager] Save file corrupted, loading backup")
		if _load_backup():
			return true
		return false
	
	save_data = json.get_data()
	save_loaded.emit()
	print("[SaveManager] 📂 Save loaded - High Score: %d" % save_data.high_score)
	return true

func _create_backup() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		DirAccess.copy_absolute(SAVE_PATH, BACKUP_SAVE_PATH)

func _load_backup() -> bool:
	if not FileAccess.file_exists(BACKUP_SAVE_PATH):
		return false
	
	var file = FileAccess.open(BACKUP_SAVE_PATH, FileAccess.READ)
	if file == null:
		return false
	
	var json_string = file.get_as_text()
	file.close()
	
	var json = JSON.new()
	if json.parse(json_string) != OK:
		return false
	
	save_data = json.get_data()
	save_game()  # Restore from backup
	print("[SaveManager] 🔄 Loaded from backup")
	return true

## HIGH SCORE
func check_and_update_high_score(score: int) -> bool:
	if score > save_data.high_score:
		save_data.high_score = score
		save_game()
		high_score_updated.emit(score)
		print("[SaveManager] 🏆 NEW HIGH SCORE: %d" % score)
		return true
	return false

func get_high_score() -> int:
	return save_data.high_score

## STATISTICS
func increment_total_shifts() -> void:
	save_data.total_shifts += 1
	save_game()

func add_playtime(seconds: float) -> void:
	save_data.total_time_played += seconds
	save_game()

func get_total_shifts() -> int:
	return save_data.total_shifts

func get_total_playtime() -> float:
	return save_data.total_time_played

## SETTINGS
func set_music_volume(volume_db: float) -> void:
	save_data.settings.music_volume = volume_db
	AudioController.set_music_volume(volume_db)
	save_game()

func set_sfx_volume(volume_db: float) -> void:
	save_data.settings.sfx_volume = volume_db
	AudioController.set_sfx_volume(volume_db)
	save_game()

func get_music_volume() -> float:
	return save_data.settings.music_volume

func get_sfx_volume() -> float:
	return save_data.settings.sfx_volume

func apply_settings() -> void:
	AudioController.set_music_volume(save_data.settings.music_volume)
	AudioController.set_sfx_volume(save_data.settings.sfx_volume)

## UNLOCKS
func unlock_item(item_id: String) -> void:
	if item_id not in save_data.unlocks:
		save_data.unlocks.append(item_id)
		save_game()
		print("[SaveManager] 🔓 Unlocked: %s" % item_id)

func is_unlocked(item_id: String) -> bool:
	return item_id in save_data.unlocks

## RESET
func reset_save_data() -> void:
	save_data = {
		"high_score": 0,
		"total_shifts": 0,
		"total_time_played": 0.0,
		"settings": {
			"music_volume": 0.0,
			"sfx_volume": 0.0,
		},
		"unlocks": [],
		"version": "0.1.0"
	}
	save_game()
	print("[SaveManager] ⚠️ Save data reset")
