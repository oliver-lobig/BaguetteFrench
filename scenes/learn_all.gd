extends Control

func _ready() -> void:
	%DictionaryCheckbox.button_pressed = Vars.settings_data.dictionary_from_selection

func secure_words():
	if Vars.all_learn_words == []:
		Vars.all_learn_words = WordHandler.get_words_until_unit(Vars.max_unit)
	if Vars.all_learn_verbs == []:
		Vars.all_learn_verbs = Vars.verbs.values()
	Vars.save_saves("Making sure that words are selected [All Learn]")

func _on_vocab_cards_pressed() -> void:
	secure_words()
	Vars.learn_all = true
	get_tree().change_scene_to_file("res://scenes/learning_methods/learn_vocab.tscn")

func _on_hear_pressed() -> void:
	secure_words()
	Vars.learn_all = true
	get_tree().change_scene_to_file("res://scenes/learning_methods/hearing.tscn")

func _on_write_single_pressed() -> void:
	secure_words()
	Vars.learn_all = true
	Vars.word_selection_type = "single"
	get_tree().change_scene_to_file("res://scenes/learning_methods/write.tscn")

func _on_write_sentences_pressed() -> void:
	secure_words()
	Vars.learn_all = true
	Vars.word_selection_type = "sentence"
	get_tree().change_scene_to_file("res://scenes/learning_methods/write.tscn")

func _on_review_pressed() -> void:
	secure_words()
	Vars.learn_all = true
	Vars.word_selection_type = "review"
	get_tree().change_scene_to_file("res://scenes/learning_methods/write.tscn")

func _on_match_cards_pressed() -> void:
	secure_words()
	Vars.learn_all = true
	get_tree().change_scene_to_file("res://scenes/match_learn.tscn")


func _on_make_sentences_pressed() -> void:
	DisplayServer.clipboard_set(SentenceGenerator.get_sentence_from_all(10))


func _on_texture_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/select_all_learn_words.tscn")



func _on_check_button_toggled(toggled_on: bool) -> void:
	Vars.settings_data.dictionary_from_selection = toggled_on
	Vars.save_saves()


func _on_word_dictionary_pressed() -> void:
	Vars.whole_dictionary = true
	get_tree().change_scene_to_file("res://scenes/learning_methods/word_dictionary/word_dictionary.tscn")


func _on_match_cards_2_pressed() -> void:
	secure_words()
	Vars.learn_all = true
	Vars.word_selection_type = "verbs"
	get_tree().change_scene_to_file("res://scenes/learning_methods/write.tscn")
