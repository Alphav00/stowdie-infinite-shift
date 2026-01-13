# InputRouter.gd
# Singleton managing mobile touch input gestures (tap, swipe, drag)
extends Node

## ENUMS
enum Zone {
	TOP_SCREEN,
	BOTTOM_SCREEN,
	UNDEFINED
}

## SIGNALS
signal tap_detected(position: Vector2, zone: Zone)
signal swipe_detected(direction: Vector2, velocity: float)
signal swipe_detected_in_zone(direction: Vector2, velocity: float, zone: Zone)
signal drag_started(position: Vector2, zone: Zone)
signal drag_updated(delta: Vector2, position: Vector2, zone: Zone)
signal drag_ended(position: Vector2, zone: Zone)

## CONSTANTS
const SWIPE_THRESHOLD: float = 50.0
const SWIPE_VELOCITY_THRESHOLD: float = 500.0
const TAP_DURATION_MAX: float = 0.2
const TAP_DISTANCE_MAX: float = 20.0
const SCREEN_SPLIT_Y: float = 960.0  # Split at 1920/2

## STATE
var touch_start_position: Vector2 = Vector2.ZERO
var touch_current_position: Vector2 = Vector2.ZERO
var touch_start_time: float = 0.0
var is_touching: bool = false
var touch_zone: Zone = Zone.UNDEFINED

func _ready() -> void:
	print("[InputRouter] Initialized - Gesture detection active")

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		_handle_touch(event)
	elif event is InputEventScreenDrag:
		_handle_drag(event)

func _handle_touch(event: InputEventScreenTouch) -> void:
	if event.pressed:
		# Touch started
		is_touching = true
		touch_start_position = event.position
		touch_current_position = event.position
		touch_start_time = Time.get_ticks_msec() / 1000.0
		touch_zone = _get_zone(event.position)
		
		drag_started.emit(touch_start_position, touch_zone)
	else:
		# Touch ended
		if not is_touching:
			return
		
		is_touching = false
		touch_current_position = event.position
		var touch_duration = (Time.get_ticks_msec() / 1000.0) - touch_start_time
		var touch_distance = touch_start_position.distance_to(touch_current_position)
		
		if touch_duration < TAP_DURATION_MAX and touch_distance < TAP_DISTANCE_MAX:
			# TAP detected
			tap_detected.emit(touch_current_position, touch_zone)
		elif touch_distance > SWIPE_THRESHOLD:
			# SWIPE detected
			var swipe_direction = (touch_current_position - touch_start_position).normalized()
			var swipe_velocity = touch_distance / touch_duration
			
			if swipe_velocity > SWIPE_VELOCITY_THRESHOLD:
				swipe_detected.emit(swipe_direction, swipe_velocity)
				swipe_detected_in_zone.emit(swipe_direction, swipe_velocity, touch_zone)
		
		drag_ended.emit(touch_current_position, touch_zone)

func _handle_drag(event: InputEventScreenDrag) -> void:
	if not is_touching:
		return
	
	var previous_position = touch_current_position
	touch_current_position = event.position
	var drag_delta = touch_current_position - previous_position
	
	drag_updated.emit(drag_delta, touch_current_position, touch_zone)

func _get_zone(position: Vector2) -> Zone:
	if position.y < SCREEN_SPLIT_Y:
		return Zone.TOP_SCREEN
	else:
		return Zone.BOTTOM_SCREEN

## UTILITY FUNCTIONS
func is_swipe_up(direction: Vector2, threshold: float = 0.7) -> bool:
	return direction.y < -threshold

func is_swipe_down(direction: Vector2, threshold: float = 0.7) -> bool:
	return direction.y > threshold

func is_swipe_left(direction: Vector2, threshold: float = 0.7) -> bool:
	return direction.x < -threshold

func is_swipe_right(direction: Vector2, threshold: float = 0.7) -> bool:
	return direction.x > threshold
