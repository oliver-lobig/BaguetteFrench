extends Node2D

signal done()

@export var start_point: Vector2
@export var end_point: Vector2
@export var radius: float
@export var end_time: float
@export var speed: float

var time_elapsed: float = 0.0
var movement_dir: Vector2
var anim_tween: Tween = null
var strech: float = .8
func _ready() -> void:
	var rand_dir = Vector2(randf_range(-1,1),randf_range(-1,1)).normalized()
	movement_dir = rand_dir
	var offset = rand_dir * radius * randf()
	
	var button_scale = Vars.settings_data.jewel_size
	$Button.scale = Vector2(button_scale,button_scale)
	
	global_position = start_point + offset
	anim_tween = get_tree().create_tween()
	anim_tween.set_trans(Tween.TRANS_CIRC)
	anim_tween.tween_property(self,"strech",1.3,0.3)
	anim_tween.tween_property(self,"strech",1.0,.6)
	
func _process(delta: float) -> void:
	var button_scale = Vars.settings_data.jewel_size
	
	$Button.scale = Vector2(button_scale,button_scale) * clampf(time_elapsed * 10,0.0,1.0) * Vector2(1,strech)
	time_elapsed += delta
	var dir_amount = clamp((-(min(time_elapsed,end_time) - (end_time / 3))) ** 2,0,.5)
	
	var dir_offset = movement_dir * 10 * speed * dir_amount / end_time ** 2
	var move_offset = global_position.direction_to(end_point) * speed
	
	var going_offset = (dir_offset + move_offset) * delta
	global_position += going_offset
	
	if global_position.distance_to(end_point) < (abs(going_offset.x) + abs(going_offset.y)) / 2:
		done.emit()
		anim_tween.kill()
		queue_free()
