extends SystemBarSpacer
@export var height_offset: float = 0.0
@export var standard_size: float = 48.0

func _process(delta: float) -> void:
	if OS.get_name() == "Android" or OS.get_name() == "iOS":
		if DisplayServer.virtual_keyboard_get_height() > 10:
			custom_minimum_size.y = (DisplayServer.virtual_keyboard_get_height() / get_viewport_transform().get_scale().y) + height_offset
		else:
			custom_minimum_size.y = standard_size + height_offset
