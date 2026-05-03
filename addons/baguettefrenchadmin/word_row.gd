@tool
extends HBoxContainer

var word: Word
var words_french = []
var words_german = []
var description = ""
var type = 0
var unit_id = 0
var is_plural = false
var word_id: int = 0
var grammatical_gender: int = 0
var content: String = ""

func _ready() -> void:
	$FrenchWord.grab_focus()
	%UID.text = "[" + str(word.uid)+"]"
	$ID.text = str(word_id) + "."
	$FrenchWord.text = make_array_string(words_french)
	$GermanWord.text = make_array_string(words_german)
	AdminVars.reload_id.connect(reload_id)
	$FrenchLength.text = str(len(words_french))
	$GermanLength.text = str(len(words_german))
	$IsPlural.button_pressed = is_plural
	$TypeEnum.clear()
	for item in Definitions.SentenceTypes.keys():
		$TypeEnum.add_item(item)
	$TypeEnum.selected = type
	$UnitEnum.clear()
	for item in Definitions.Units.keys():
		$UnitEnum.add_item(item)
	$UnitEnum.selected = unit_id
	
	$GrammaticalGenderEnum.clear()
	for item in Definitions.GrammaticalGenders.keys():
		$GrammaticalGenderEnum.add_item(item)
	$GrammaticalGenderEnum.selected = grammatical_gender
	$Description.text = description
	if word in Vars.marked_words:
		self.modulate = Color.AQUAMARINE
		$IsMarked.button_pressed = true
	else:
		self.modulate = Color.WHITE
		$IsMarked.button_pressed = false
	
	AdminVars.send_query.connect(handle_search)
	
	await get_tree().process_frame
	
	update_search_content()

func update_search_content():
	content = "french: " + make_array_string(words_french) + \
	 " german: " + make_array_string(words_german) + \
	 " description: " + description + \
	" type: " + $TypeEnum.get_item_text($TypeEnum.selected) + \
	" unit: " + $UnitEnum.get_item_text($UnitEnum.selected) + \
	" grammatical_gender: " + $GrammaticalGenderEnum.get_item_text($GrammaticalGenderEnum.selected) + \
	" is_plural: " + str($IsPlural.button_pressed) + \
	" is_marked: " + str($IsMarked.button_pressed)

func make_array_string(input: Array) -> String:
	var new_string = ""
	for w in input:
		if new_string != "":
			new_string += "; "
		new_string += w
	return new_string

func change_word():
	var new_french = Array($FrenchWord.text.split("; "))
	var new_german = Array($GermanWord.text.split("; "))
	var new_description = $Description.text
	var new_type = int($TypeEnum.selected)
	var new_id =  int($UnitEnum.selected)
	var new_is_plural = $IsPlural.button_pressed
	var new_grammatical_gender =  int($GrammaticalGenderEnum.selected)
	
	var word_object = WordHandler.get_word_from_id(word_id)
	word_object.french = new_french
	word_object.german = new_german
	word_object.is_plural = new_is_plural
	word_object.description = new_description
	word_object.grammatical_gender = new_grammatical_gender
	word_object.sentence_type = new_type
	word_object.unit_id = new_id
	word_object.id = word_id
	word_object.uid = word.uid
	word = word_object
	Vars.words.erase(WordHandler.get_word_from_id(word_id))
	if Vars.words.insert(word_id,word_object) != OK:
		printerr("ID of Word "+ str(words_german) + " Not Possible to add! Appending at end.")
		Vars.words.append(word_object)

func reload_id():
	if word is Word:
		word_id = word.id
		$ID.text = str(word_id) + "."
func _on_french_word_text_changed(new_text: String) -> void:
	change_word()
	update_search_content()


func _on_german_word_text_changed(new_text: String) -> void:
	change_word()
	update_search_content()


func _on_description_text_changed(new_text: String) -> void:
	change_word()
	update_search_content()


func _on_type_text_changed(new_text: String) -> void:
	change_word()
	update_search_content()


func _on_unit_id_text_submitted(new_text: String) -> void:
	change_word()
	update_search_content()


func _on_type_enum_item_selected(index: int) -> void:
	change_word()
	update_search_content()


func _on_unit_enum_item_selected(index: int) -> void:
	change_word()
	update_search_content()


func _on_grammatical_gender_enum_item_selected(index: int) -> void:
	change_word()
	update_search_content()


func _on_is_plural_toggled(toggled_on: bool) -> void:
	change_word()
	update_search_content()


func _on_is_marked_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		if not word in Vars.marked_words:
			if word:
				Vars.marked_words.append(word)
				self.modulate = Color.AQUAMARINE
	else:
		if word in Vars.marked_words:
			self.modulate = Color.WHITE
			Vars.marked_words.erase(word)
	update_search_content()

func handle_search():
	if AdminVars.search_query == "":
		show()
	elif AdminVars.search_query.to_lower() in content.to_lower():
		show()
	else:
		hide()


func _on_delete_button_pressed() -> void:
	AdminVars.remove_word(word)
	queue_free()
