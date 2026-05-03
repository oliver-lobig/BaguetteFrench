extends Control

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/credits.tscn")


func _on_label_meta_clicked(meta: Variant) -> void:
	OS.shell_open(str(meta))
