@tool
extends Node

var ui_translations: Dictionary = {}
var languages = []

var selected_language = ""

func _ready() -> void:
	load_translations()

func load_translations():
	var file = FileAccess.open("res://ui_translation/BaguetteFrenchFallback.txt",FileAccess.READ)
	var translation_array = []
	
	while file.get_position() < file.get_length():
		translation_array.append(file.get_csv_line(";"))
	
	for language_id in range(translation_array[0].size() - 1):
		var language_code = translation_array[0].get(language_id + 1)
		languages.append(language_code)
	
	translation_array.pop_front()
	
	for translation in translation_array:
		if translation:
			var key_translations = {}
			for language_id in range(translation_array[0].size() - 1):
				key_translations[languages[language_id]] = translation[language_id + 1]
			ui_translations[translation[0]] = key_translations

func translate(input: String):
	if selected_language == "" and ui_translations.has(input):
		return input.to_kebab_case()
	if !ui_translations.has(input):
		return input
	else:
		return ui_translations.get(input).get(selected_language)

func set_locale(locale: String):
	#TranslationServer.set_locale(locale)
	selected_language = locale
