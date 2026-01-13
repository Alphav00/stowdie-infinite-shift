# AudioController.gd
# Singleton managing all audio (music, SFX, 3D positional audio)
extends Node

## SIGNALS
signal music_changed(track_name: String)
signal sfx_played(sfx_name: String)

## AUDIO BUSES
const MUSIC_BUS = "Music"
const SFX_BUS = "SFX"

## SFX POOL
const SFX_POOL_SIZE: int = 32
var sfx_players: Array[AudioStreamPlayer] = []
var sfx_3d_players: Array[AudioStreamPlayer2D] = []
var next_sfx_index: int = 0
var next_sfx_3d_index: int = 0

## MUSIC
var current_music: AudioStreamPlayer
var music_crossfade_tween: Tween

## SFX LIBRARY
var sfx_library: Dictionary = {}

## MUSIC TRACKS
var music_tracks: Dictionary = {
	"shift_start": "res://assets/audio/music/BGM_ShiftStart.ogg",
	"demon_hour": "res://assets/audio/music/BGM_DemonHour.ogg",
}

func _ready() -> void:
	_initialize_audio_buses()
	_create_sfx_pool()
	_create_music_player()
	_load_sfx_library()
	print("[AudioController] Initialized - SFX Pool: %d" % SFX_POOL_SIZE)

func _initialize_audio_buses() -> void:
	# Note: In production, buses would be set up in AudioBusLayout
	# This is a placeholder for runtime configuration
	pass

func _create_sfx_pool() -> void:
	for i in range(SFX_POOL_SIZE):
		var player = AudioStreamPlayer.new()
		player.bus = SFX_BUS
		add_child(player)
		sfx_players.append(player)
		
		var player_3d = AudioStreamPlayer2D.new()
		player_3d.bus = SFX_BUS
		player_3d.max_distance = 2000.0
		add_child(player_3d)
		sfx_3d_players.append(player_3d)

func _create_music_player() -> void:
	current_music = AudioStreamPlayer.new()
	current_music.bus = MUSIC_BUS
	current_music.volume_db = 0.0
	add_child(current_music)

func _load_sfx_library() -> void:
	# Placeholder - in production, scan assets/audio/sfx/ directory
	sfx_library = {
		"scanner_beep": "res://assets/audio/sfx/Scanner_Beep.wav",
		"scanner_cursed": "res://assets/audio/sfx/Scanner_Cursed.wav",
		"stow_success": "res://assets/audio/sfx/Stow_Success.wav",
		"stow_fail": "res://assets/audio/sfx/Stow_Fail.wav",
		"lyon_roar": "res://assets/audio/sfx/Lyon_Roar.wav",
		"item_explode": "res://assets/audio/sfx/Item_Explode.wav",
		"tap_suppress": "res://assets/audio/sfx/Tap_Suppress.wav",
		"possession_start": "res://assets/audio/sfx/Possession_Start.wav",
		"hide_enter": "res://assets/audio/sfx/Hide_Enter.wav",
		"alarm": "res://assets/audio/sfx/Alarm.wav",
	}

## MUSIC CONTROL
func play_music(track_name: String, crossfade_duration: float = 2.0) -> void:
	if not track_name in music_tracks:
		push_error("[AudioController] Music track not found: %s" % track_name)
		return
	
	var track_path = music_tracks[track_name]
	if not ResourceLoader.exists(track_path):
		print("[AudioController] Music file missing: %s" % track_path)
		return
	
	var new_stream = load(track_path)
	
	if current_music.playing:
		_crossfade_music(new_stream, crossfade_duration)
	else:
		current_music.stream = new_stream
		current_music.play()
	
	music_changed.emit(track_name)
	print("[AudioController] 🎵 Playing: %s" % track_name)

func _crossfade_music(new_stream: AudioStream, duration: float) -> void:
	if music_crossfade_tween:
		music_crossfade_tween.kill()
	
	music_crossfade_tween = create_tween()
	music_crossfade_tween.set_parallel(true)
	
	# Fade out current
	music_crossfade_tween.tween_property(current_music, "volume_db", -80.0, duration)
	
	# Wait for fade, then swap
	music_crossfade_tween.chain()
	music_crossfade_tween.tween_callback(func():
		current_music.stop()
		current_music.stream = new_stream
		current_music.volume_db = -80.0
		current_music.play()
	)
	
	# Fade in new
	music_crossfade_tween.chain()
	music_crossfade_tween.tween_property(current_music, "volume_db", 0.0, duration)

func stop_music(fade_duration: float = 1.0) -> void:
	if music_crossfade_tween:
		music_crossfade_tween.kill()
	
	music_crossfade_tween = create_tween()
	music_crossfade_tween.tween_property(current_music, "volume_db", -80.0, fade_duration)
	music_crossfade_tween.tween_callback(current_music.stop)

## SFX CONTROL
func play_sfx(sfx_name: String, volume_db: float = 0.0) -> void:
	if not sfx_name in sfx_library:
		push_error("[AudioController] SFX not found: %s" % sfx_name)
		return
	
	var sfx_path = sfx_library[sfx_name]
	if not ResourceLoader.exists(sfx_path):
		print("[AudioController] SFX file missing: %s" % sfx_path)
		return
	
	var player = sfx_players[next_sfx_index]
	next_sfx_index = (next_sfx_index + 1) % SFX_POOL_SIZE
	
	if player.playing:
		player.stop()
	
	player.stream = load(sfx_path)
	player.volume_db = volume_db
	player.play()
	
	sfx_played.emit(sfx_name)

func play_sfx_3d(sfx_name: String, position: Vector2, volume_db: float = 0.0) -> void:
	if not sfx_name in sfx_library:
		push_error("[AudioController] SFX not found: %s" % sfx_name)
		return
	
	var sfx_path = sfx_library[sfx_name]
	if not ResourceLoader.exists(sfx_path):
		print("[AudioController] SFX file missing: %s" % sfx_path)
		return
	
	var player = sfx_3d_players[next_sfx_3d_index]
	next_sfx_3d_index = (next_sfx_3d_index + 1) % SFX_POOL_SIZE
	
	if player.playing:
		player.stop()
	
	player.stream = load(sfx_path)
	player.volume_db = volume_db
	player.global_position = position
	player.play()
	
	sfx_played.emit(sfx_name)

## VOLUME CONTROL
func set_music_volume(volume_db: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(MUSIC_BUS), volume_db)

func set_sfx_volume(volume_db: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(SFX_BUS), volume_db)

func get_music_volume() -> float:
	return AudioServer.get_bus_volume_db(AudioServer.get_bus_index(MUSIC_BUS))

func get_sfx_volume() -> float:
	return AudioServer.get_bus_volume_db(AudioServer.get_bus_index(SFX_BUS))
