extends Control

func _on_back_button_pressed() -> void:
	View.open_tab("settings")


func _on_credits_path_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/credits_path.tscn")


func _on_licence_pressed() -> void:
	OS.shell_open("https://www.gnu.org/licenses/gpl-3.0-standalone.html")


func _on_itch_io_pressed() -> void:
	OS.shell_open("https://olli-games.itch.io/baguettefrench")


func _on_git_hub_pressed() -> void:
	OS.shell_open("https://github.com/oliver-lobig/baguettefrench")
