extends Node2D
signal swipe_step(interpolation: float)
signal swiped()
signal swipe_stopped()

@export var direction: Vector2 = Vector2.RIGHT
@export var length: float = 100.0
@export var max_wrong: float = 0.5
@export var max_time: float = 0.5
@export var swipe_min: float = 1.0

var in_check: bool = false
var start_pos: Vector2
var swipe_time: float = 0.0

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		in_check = true
		swipe_time = max_time
		start_pos = event.position
	elif  event.is_action_released("click"):
		if in_check:
			in_check = false
			var new_pos: Vector2 = event.position
			var relative: Vector2 = new_pos - start_pos
			var relative_vector = relative.normalized()
			var difference: Vector2 = relative_vector - direction
			var wrong: float = abs(difference.x) + abs(difference.y)
			if wrong <= max_wrong:
				var axis_value = abs(relative.x) if direction == Vector2.RIGHT or direction == Vector2.LEFT else abs(relative.y)
				var interpolation_simple = axis_value / length
				var interpolation_clean = clamp(interpolation_simple,0,1)
				if interpolation_clean >= swipe_min:
					swiped.emit()
				else:
					swipe_stopped.emit()
			else:
				swipe_stopped.emit()
	if event is InputEventMouseMotion:
		if in_check:
			var new_pos: Vector2 = event.position
			var relative: Vector2 = new_pos - start_pos
			var relative_vector = relative.normalized()
			var difference: Vector2 = relative_vector - direction
			var wrong: float = abs(difference.x) + abs(difference.y)
			if wrong <= max_wrong:
				var axis_value = abs(relative.x) if direction == Vector2.RIGHT or direction == Vector2.LEFT else abs(relative.y)
				var interpolation_simple = axis_value / length
				var interpolation_clean = clamp(interpolation_simple,0,1)
				self.swipe_step.emit(interpolation_clean)

func _process(delta: float) -> void:
	if in_check:
		swipe_time -= delta
		if swipe_time <= 0:
			in_check = false
			swipe_stopped.emit()
