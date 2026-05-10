extends Control

func _ready() -> void:
	if Vars.finished_intro == false:
		get_tree().change_scene_to_file.call_deferred("res://scenes/intro/intro_composition.tscn")
	else:
		get_tree().change_scene_to_file.call_deferred("res://scenes/tabs.tscn")
