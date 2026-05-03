extends Control

const WORD_ROW = preload("res://scenes/learning_methods/word_dictionary/word_row.tscn")

func _ready() -> void:
	%Loading.show()
	await get_tree().process_frame
	load_words()

func load_words():
	await get_tree().process_frame
	var extra_words = Vars.words if Vars.settings_data.dictionary_from_selection == false else Vars.all_learn_words
	var words = WordHandler.get_words_in_unit(Vars.current_open_unit) if Vars.whole_dictionary == false else extra_words
	for word in words:
		var instance = WORD_ROW.instantiate()
		instance.word = word
		%Words.add_child(instance)
	%Loading.hide()
	if Vars.whole_dictionary == true:
		var spacer = HSeparator.new()
		spacer.add_theme_constant_override("separation",160)
		spacer.add_theme_stylebox_override("seperator",StyleBoxEmpty.new())
		%Words.add_child(spacer)



func _on_search_text_changed(new_text: String) -> void:
	Vars.search_query = new_text
	Vars.search_dictionary.emit()


func _on_back_button_pressed() -> void:
	if Vars.whole_dictionary == false:
		get_tree().change_scene_to_file("res://scenes/learning_methods/learn_vocab.tscn")
	else:
		View.open_tab("learn_all")
		Vars.whole_dictionary = false
