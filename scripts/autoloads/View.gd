extends Node

signal change_to_tab(tab: String)
@warning_ignore("unused_signal")
signal new_content(content: String)

var current_camera: CameraShake = null

func open_tab(tab: String):
	get_tree().change_scene_to_file("res://scenes/tabs.tscn")
	change_to_tab.emit(tab)
