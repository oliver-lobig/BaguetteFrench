extends Node

const ACTIVE = true

func _input(event: InputEvent) -> void:
	if ACTIVE:
		if event.is_action_pressed("reload"):
			get_tree().reload_current_scene()

func calc_average_value(probs,mappings):
	var val = 0.0
	for i in range(1000):
		val += Utils.roll_random(probs,mappings)
	
	return val / 1000.0
