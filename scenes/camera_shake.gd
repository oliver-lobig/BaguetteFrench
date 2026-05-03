extends Camera2D
class_name CameraShake

var max_strength = 0.0
var current_strength = 0.0
var whole_length = 0.0
var cam_speed = 3.0
var time_passed = 0.0
var running: bool = false

var shake_direction: Vector2 = Vector2()
var shake_rotation: float = 0.0

func _ready() -> void:
	View.current_camera = self

func shake(strength: float = 150.0, speed: float = 66.0, length: float = 2.0):
	if Vars.settings_data.use_camera_shake == true:
		current_strength += strength
		if current_strength > strength * 2:
			current_strength = strength * 2
		max_strength = strength
		cam_speed = speed
		whole_length = length
		running = true

func _process(delta: float) -> void:
	if running == true:
		if current_strength >= 0.0:
			current_strength -= (max_strength * delta) / whole_length
		else:
			running = false
		time_passed += delta
		if time_passed > 1 / cam_speed :
			time_passed = 0
			shake_direction = Vector2(randf_range(-1.0,1.0),randf_range(-1.0,1.0)).normalized()
			shake_rotation = shake_direction.angle_to_point(Vector2(0.0,0.0))
		offset = offset.lerp(shake_direction * current_strength,8 * delta)
		rotation_degrees = lerpf(rotation_degrees, shake_rotation * (current_strength / 40),8 * delta)
	else:
		rotation_degrees = lerpf(rotation_degrees, 0,8 * delta)
		offset = offset.lerp(Vector2.ZERO,8*delta)
