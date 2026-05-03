@tool
extends TextEdit

class_name TextTextEdit

@export_enum("Normal","Medium","SemiBold","Bold","Italic") var font_type: int = 0
@export_enum("Default","Title") var font_use: int = 0

var last_type = 0
var last_use = 0

func _ready() -> void:
	update_font()

func update_font():
	var text_font = FontManager.get_default_font_with(font_type, font_use)
	add_theme_font_override("font",text_font)

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		if last_type != font_type:
			last_type = font_type
			update_font()
		if last_use != font_use:
			last_use = font_use
			update_font()
