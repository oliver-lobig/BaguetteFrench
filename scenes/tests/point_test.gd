extends Control

func _on_button_pressed() -> void:
	%PointCounter.get_points([5,7,3,1],[5,7,8,18],%Button.global_position + (%Button.size / 2), 128, 700)
