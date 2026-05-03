extends Control

const CUSTOM_WORD_ROW = preload("res://scenes/own_words/custom_word_row.tscn")
const CUSTOM_VERB_ROW = preload("res://scenes/own_words/custom_verb_row.tscn")

func _ready() -> void:
	var this_category = Vars.own_categorys[Vars.current_open_category]
	%Title.text = this_category["name"]
	for word in this_category["words"]:
		var word_text = WordHandler.get_words_string(word.french) + " - " + WordHandler.get_words_string(word.german) + " | " + word.description
		var instance = CUSTOM_WORD_ROW.instantiate()
		instance.text = word_text
		instance.word = word
		instance.pressed.connect(open_edit_word.bind(word))
		%Words.add_child(instance)
	if this_category.has("verbs"):
		for verb in this_category["verbs"]:
			var verb_text = WordHandler.get_words_string(verb.infinitive.french) + " - " + WordHandler.get_words_string(verb.infinitive.german)
			var instance = CUSTOM_VERB_ROW.instantiate()
			instance.text = verb_text
			instance.verb = verb
			instance.pressed.connect(open_edit_verb.bind(verb))
			%Verbs.add_child(instance)

func open_edit_word(word: Word):
	Vars.word_edit_mode = "edit"
	Vars.original_edit_word = word
	get_tree().change_scene_to_file("res://scenes/own_words/add_custom_word.tscn")

func open_edit_verb(verb: Verb):
	Vars.word_edit_mode = "edit"
	Vars.original_edit_verb = verb
	get_tree().change_scene_to_file("res://scenes/own_words/add_custom_verb.tscn")

func _on_delete_button_pressed() -> void:
	%ReallyDelete.show()


func _on_dont_delete_pressed() -> void:
	%ReallyDelete.hide()


func _on_delete_pressed() -> void:
	Vars.own_categorys.erase(Vars.current_open_category)
	Vars.save_saves()
	View.open_tab("own_words")


func _on_back_button_pressed() -> void:
	Vars.current_open_category = ""
	View.open_tab("own_words")


func _on_add_verb_pressed() -> void:
	Vars.word_edit_mode = "add"
	get_tree().change_scene_to_file("res://scenes/own_words/add_custom_verb.tscn")


func _on_add_word_pressed() -> void:
	Vars.word_edit_mode = "add"
	get_tree().change_scene_to_file("res://scenes/own_words/add_custom_word.tscn")
