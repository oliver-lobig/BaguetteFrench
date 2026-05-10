extends HSeparator
class_name SystemBarSpacer

func _ready() -> void:
	if OS.get_name() == "Android" or OS.get_name() == "iOS":
		show()
	else:
		queue_free()


func _on_use_tutorial_pressed() -> void:
	pass # Replace with function body.
