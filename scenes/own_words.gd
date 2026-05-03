extends Control


func _on_add_category_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/own_words/add_category.tscn")

func _ready() -> void:
	for category in Vars.own_categorys.values():
		var instance = TextButton.new()
		instance.text = category["name"]
		instance.add_theme_font_size_override("font_size",32)
		instance.custom_minimum_size.y = 64
		instance.pressed.connect(open_category.bind(category["id"]))
		%Categorys.add_child(instance)

func open_category(category_id: String):
	Vars.current_open_category = category_id
	get_tree().change_scene_to_file("res://scenes/own_words/word_category.tscn")


func _on_add_words_pressed() -> void:
	Vars.word_edit_mode = "add"
	get_tree().change_scene_to_file("res://scenes/own_words/add_custom_word.tscn")


func _on_import_words_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/own_words/import_csv.tscn")
