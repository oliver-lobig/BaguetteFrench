extends Control

var this_verb: Verb = Verb.new()

func throw_error(error: String):
	%Error.text = error
	%Error.show()

func _ready() -> void:
	for type in %Types.get_children():
		type.updated_content.connect(verb_field_updated_content)
	var selecting_id: int = 0
	var index: int = 1
	for category in Vars.own_categorys:
		%SelectCategory.add_item(category)
		if category == Vars.current_open_category:
			selecting_id = index
		index += 1
	%SelectCategory.selected = selecting_id
	
	if Vars.word_edit_mode == "edit":
		this_verb = Vars.original_edit_verb
		%WordButton.hide()
		%ViewTitle.text = tr("EDIT_VERB")
		%ActionButton.text = tr("EDIT_VERB")
		%Infinitive.get_node("%German").text = WordHandler.get_words_string(Vars.original_edit_verb.infinitive.german)
		%Infinitive.get_node("%French").text = WordHandler.get_words_string(Vars.original_edit_verb.infinitive.french)
		%Suffix.get_node("%German").text = WordHandler.get_words_string(Vars.original_edit_verb.suffix["german"])
		%Suffix.get_node("%French").text = WordHandler.get_words_string(Vars.original_edit_verb.suffix["french"])
		for type in %Types.get_children():
			if type.type in Vars.original_edit_verb.versions.keys():
				type.get_node("%German").text = WordHandler.get_words_string(Vars.original_edit_verb.versions[type.type].german)
				type.get_node("%French").text = WordHandler.get_words_string(Vars.original_edit_verb.versions[type.type].french)
		

func _on_word_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/own_words/add_custom_word.tscn")


func verb_field_updated_content(field_type: Variant, french: Variant, german: Variant) -> void:
	if field_type == "infinitive":
		this_verb.infinitive.french = french.split("; ")
		this_verb.infinitive.german = german.split("; ")
	if field_type == "suffix":
		this_verb.suffix["french"] = french.split("; ")
		this_verb.suffix["german"] = german.split("; ")
	if field_type in this_verb.versions.keys():
		this_verb.versions[field_type].french = french.split("; ")
		this_verb.versions[field_type].german = german.split("; ")


func _on_action_button_pressed() -> void:
	if add_verb():
		if Vars.current_open_category == "":
			Vars.current_open_category = %SelectCategory.get_item_text(%SelectCategory.selected)
		get_tree().change_scene_to_file("res://scenes/own_words/word_category.tscn")

func add_verb():
	for option in %Types.get_children():
		if option.get_node("%French").text == "":
			throw_error("Bitte gib " + tr(option.placeholder_french) + " an.")
			return false
		if option.get_node("%German").text == "":
			throw_error("Bitte gib " + tr(option.placeholder_german) + " an.")
			return false
	if %SelectCategory.selected == 0:
		throw_error("Bitte gib die Kategorie des Wortes an.")
		return false
	var unit_id = %SelectCategory.get_item_text(%SelectCategory.selected)
	if not "verbs" in Vars.own_categorys[unit_id].keys():
		Vars.own_categorys[unit_id]["verbs"] = []
	
	this_verb.uid = Vars.original_edit_verb.uid if Vars.word_edit_mode == "edit" else randi_range(111111111,999999999)
	
	if Vars.word_edit_mode == "add":
		Vars.own_categorys[unit_id]["verbs"].append(this_verb)
	Vars.save_saves()
	return true

func _on_back_button_pressed() -> void:
	if Vars.current_open_category == "":
		View.open_tab("own_words")
	else:
		get_tree().change_scene_to_file("res://scenes/own_words/word_category.tscn")


func _on_next_pressed() -> void:
	if add_verb():
		Vars.word_edit_mode = "add"
		get_tree().reload_current_scene()
