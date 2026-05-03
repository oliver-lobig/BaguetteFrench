extends Control

var similar_to: Word = null
var continue_to: String = "category"

func _ready() -> void:
	var selecting_id: int = 0
	var index: int = 1
	for category in Vars.own_categorys:
		%SelectCategory.add_item(category)
		if category == Vars.current_open_category:
			selecting_id = index
		index += 1
	%SelectCategory.selected = selecting_id
	if Vars.word_edit_mode == "edit":
		%VerbButton.hide()
		%ViewTitle.text = tr("EDIT_WORD")
		%ActionButton.text = tr("EDIT_WORD")
		%French.text = WordHandler.get_words_string(Vars.original_edit_word.french)
		%German.text = WordHandler.get_words_string(Vars.original_edit_word.german)
		%Description.text = Vars.original_edit_word.description
		%SelectGender.selected = Vars.original_edit_word.grammatical_gender

func _on_back_button_pressed() -> void:
	if Vars.current_open_category == "":
		View.open_tab("own_words")
	else:
		get_tree().change_scene_to_file("res://scenes/own_words/word_category.tscn")

func throw_error(error: String):
	%Error.text = error
	%Error.show()

func _on_button_pressed() -> void:
	continue_to = "category"
	if add_word():
		if Vars.current_open_category == "":
			Vars.current_open_category = %SelectCategory.get_item_text(%SelectCategory.selected)
		get_tree().change_scene_to_file("res://scenes/own_words/word_category.tscn")
func add_word(hard_add: bool = false):
	if %French.text == "":
		throw_error("Bitte gib das Wort auf Französisch an.")
		return false
	if %German.text == "":
		throw_error("Bitte gib das Wort auf Deutsch an.")
		return false
	if %SelectGender.selected == 0:
		throw_error("Bitte gib das grammatikalische Geschlecht des Wortes an. Du kannst auch 'Keins' auswählen.")
		return false
	if %SelectCategory.selected == 0:
		throw_error("Bitte gib die Kategorie des Wortes an.")
		return false
	var new_word: Word = Word.new() if Vars.word_edit_mode == "add" else Vars.original_edit_word
	new_word.uid = Vars.original_edit_word.uid if Vars.word_edit_mode == "edit" else randi_range(111111111,999999999)
	new_word.german = %German.text.split("; ")
	new_word.french = %French.text.split("; ")
	new_word.description = %Description.text
	new_word.grammatical_gender = int(%SelectGender.selected)
	new_word.unit_id = -2
	var unit_id = %SelectCategory.get_item_text(%SelectCategory.selected)
	if Vars.word_edit_mode == "add":
		if hard_add == false:
			similar_to = new_word
			var match_id = Vars.words.find_custom(is_too_similar)
			if match_id != -1:
				found_duplicate(Vars.words[match_id], false)
				return false
			for own_category in Vars.own_categorys:
				match_id = Vars.own_categorys[own_category].words.find_custom(is_too_similar)
				if match_id != -1:
					found_duplicate(Vars.own_categorys[own_category].words[match_id], true, Vars.own_categorys[own_category]["name"])
					return false
		Vars.own_categorys[unit_id]["words"].append(new_word)
	Vars.save_saves()
	return true

func is_too_similar(word: Word):
	var french_similar = WordHandler.get_words_string(word.french).similarity(WordHandler.get_words_string(similar_to.french))
	var german_similar = WordHandler.get_words_string(word.german).similarity(WordHandler.get_words_string(similar_to.german))
	return french_similar + german_similar > 1.2

func found_duplicate(word: Word, is_custom: bool, custom_unit_name = ""):
	%DuplicateDescription.text = "DE: " + WordHandler.get_words_string(word.german) + "\n" + \
	"FR: " + WordHandler.get_words_string(word.french) 
	if is_custom == false:
		%DuplicateDescription.text += "\n >" + Definitions.unit_names[word.unit_id] + "<"
	else:
		%DuplicateDescription.text += "\n >" + custom_unit_name + "<"
	%FoundDuplicate.show()

func _on_next_pressed() -> void:
	continue_to = "reload"
	if add_word():
		Vars.word_edit_mode = "add"
		get_tree().reload_current_scene()


func _on_verb_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/own_words/add_custom_verb.tscn")


func _on_dont_delete_pressed() -> void:
	get_tree().reload_current_scene()


func _on_delete_pressed() -> void:
	if add_word(true):
		if continue_to == "category":
			View.open_tab("own_words")
		else:
			Vars.word_edit_mode = "add"
			get_tree().reload_current_scene()


func _on_stop_pressed() -> void:
	%FoundDuplicate.hide()
