@tool
extends Button

class_name TextButton

@export_enum("Normal","Medium","SemiBold","Bold","Italic") var font_type: int = 3
@export_enum("Default","Title") var font_use: int = 0

@export var quickchange_enabled: bool = false

var original_text = ""

var last_text = ""
var last_language = ""

var last_type = 0
var last_use = 0

func _ready() -> void:
	if quickchange_enabled:
		last_language = BaguetteTranslationServer.selected_language
		original_text = text
		text = BaguetteTranslationServer.translate(original_text)
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
	if !Engine.is_editor_hint():
		if quickchange_enabled:
			if BaguetteTranslationServer.selected_language != last_language:
				text = BaguetteTranslationServer.translate(original_text)
				last_language = BaguetteTranslationServer.selected_language
		else:
			if text != last_text:
				if BaguetteTranslationServer.ui_translations.has(text):
					text = BaguetteTranslationServer.translate(text)
