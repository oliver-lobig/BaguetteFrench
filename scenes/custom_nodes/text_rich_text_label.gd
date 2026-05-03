@tool
extends RichTextLabel

class_name TextRichTextLabel

@export_enum("Normal","Medium","SemiBold","Bold","Italic") var font_type: int = 0
@export_enum("Default","Title") var font_use: int = 0

var last_type = 0
var last_use = 0

func _ready() -> void:
	update_font()

func update_font():
	var text_font = FontManager.get_default_font_with(font_type, font_use)
	add_theme_font_override("normal_font",text_font)
	
	# RichText specific fonts used for BBCode
	add_theme_font_override("bold_font",FontManager.get_default_font_with(3, font_use))
	add_theme_font_override("bold_italics_font",FontManager.get_default_font_with(3, font_use))
	add_theme_font_override("italics_font",FontManager.get_default_font_with(4, font_use))
	add_theme_font_override("mono_font",FontManager.get_default_font_with(0, font_use))

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		if last_type != font_type:
			last_type = font_type
			update_font()
		if last_use != font_use:
			last_use = font_use
			update_font()
