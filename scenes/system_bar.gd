extends HSeparator
class_name SystemBarSpacer

func _ready() -> void:
	if OS.get_name() == "Android" or OS.get_name() == "iOS":
		show()
	else:
		queue_free()
