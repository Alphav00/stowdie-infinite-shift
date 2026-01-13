# GameManager.gd
# Singleton autoload managing global game state, Rate system, and phase transitions
extends Node

## ENUMS
enum Phase {
	TUTORIAL = 0,
	NORMAL = 1,
	DEMON_HOUR = 2
}

## SIGNALS
signal rate_changed(new_rate: float)
signal phase_transition(new_phase: Phase)
signal tote_filled(efficiency: float)
signal game_over(final_score: int)
signal score_updated(new_score: int)

## STATE
var current_rate: float = 100.0:
	set(value):
		current_rate = clamp(value, 0.0, 100.0)
		rate_changed.emit(current_rate)
		_check_phase_transition()
		if current_rate <= 0.0:
			_trigger_game_over()

var current_phase: Phase = Phase.TUTORIAL:
	set(value):
		if value != current_phase:
			current_phase = value
			phase_transition.emit(current_phase)

var current_score: int = 0:
	set(value):
		current_score = max(0, value)
		score_updated.emit(current_score)

var is_paused: bool = false
var session_start_time: float = 0.0

## REFERENCES
var bottom_tote: Node = null  # Set by ToteContainer when ready

## CONSTANTS
const RATE_DRAIN_PER_SECOND: float = 2.0
const PHASE_2_THRESHOLD: float = 60.0
const PHASE_3_THRESHOLD: float = 20.0

func _ready() -> void:
	session_start_time = Time.get_ticks_msec() / 1000.0
	current_phase = Phase.TUTORIAL
	print("[GameManager] Initialized - Rate: %.1f, Phase: %s" % [current_rate, Phase.keys()[current_phase]])

func _process(delta: float) -> void:
	if not is_paused and current_phase != Phase.TUTORIAL:
		_drain_rate(delta)

## RATE MANAGEMENT
func add_rate(amount: float) -> void:
	current_rate += amount
	print("[GameManager] Rate +%.1f → %.1f%%" % [amount, current_rate])

func subtract_rate(amount: float) -> void:
	current_rate -= amount
	print("[GameManager] Rate -%.1f → %.1f%%" % [amount, current_rate])

func _drain_rate(delta: float) -> void:
	var drain_amount = RATE_DRAIN_PER_SECOND * delta
	if current_phase == Phase.DEMON_HOUR:
		drain_amount *= 2.5  # Demon Hour drains 2.5x faster
	current_rate -= drain_amount

func _check_phase_transition() -> void:
	var new_phase: Phase = current_phase
	
	if current_rate <= PHASE_3_THRESHOLD:
		new_phase = Phase.DEMON_HOUR
	elif current_rate <= PHASE_2_THRESHOLD:
		new_phase = Phase.NORMAL
	elif current_rate > PHASE_2_THRESHOLD and current_phase != Phase.TUTORIAL:
		new_phase = Phase.NORMAL
	
	if new_phase != current_phase:
		current_phase = new_phase

## SCORE MANAGEMENT
func add_score(points: int) -> void:
	current_score += points

## TOTE MANAGEMENT
func get_tote_efficiency() -> float:
	if bottom_tote and bottom_tote.has_method("calculate_packing_efficiency"):
		return bottom_tote.calculate_packing_efficiency()
	return 0.0

func get_tote_score() -> int:
	if bottom_tote and bottom_tote.has_method("get_score_value"):
		return bottom_tote.get_score_value()
	return 0

func clear_tote() -> void:
	if bottom_tote and bottom_tote.has_method("clear_tote"):
		bottom_tote.clear_tote()

## GAME FLOW
func trigger_alarm() -> void:
	print("[GameManager] ⚠️ ALARM TRIGGERED")
	# AudioController should handle the alarm sound
	if has_node("/root/AudioController"):
		get_node("/root/AudioController").play_sfx("alarm")

func trigger_screen_shake(duration: float, intensity: float) -> void:
	print("[GameManager] 📳 Screen shake: %.1fs @ %.1f intensity" % [duration, intensity])
	# Camera shake implementation would go here or be handled by viewport

func _trigger_game_over() -> void:
	is_paused = true
	var session_duration = (Time.get_ticks_msec() / 1000.0) - session_start_time
	print("[GameManager] 💀 GAME OVER - Score: %d, Time: %.1fs" % [current_score, session_duration])
	game_over.emit(current_score)

func restart_game() -> void:
	current_rate = 100.0
	current_score = 0
	current_phase = Phase.TUTORIAL
	is_paused = false
	session_start_time = Time.get_ticks_msec() / 1000.0
	get_tree().reload_current_scene()

## DEBUG
func _input(event: InputEvent) -> void:
	if OS.is_debug_build():
		if event is InputEventKey and event.pressed:
			match event.keycode:
				KEY_F1:  # Add Rate
					add_rate(20.0)
				KEY_F2:  # Subtract Rate
					subtract_rate(20.0)
				KEY_F3:  # Force Demon Hour
					current_rate = 15.0
