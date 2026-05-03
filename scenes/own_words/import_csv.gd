extends Control

var file_content: String = ""
var file_lines: Array = []

func _ready() -> void:
	for category in Vars.own_categorys:
		%SelectCategory.add_item(category)
func _on_load_csv_pressed() -> void:
	%FileDialog.show()

func split_escaped(string: String):
	var is_escaped: bool = false
	var current_part: String = ""
	var output = []
	for id in range(string.length() - 1):
		var two_chars = string[id]
		if two_chars == "\"":
			is_escaped = !is_escaped
		elif string[id] == ";":
			if is_escaped == false:
				output.append(current_part)
				current_part = ""
			else:
				current_part += string[id]
		else:
			current_part += string[id]
	if current_part != "":
		output.append(current_part)
	return output

func _on_file_dialog_file_selected(path: String) -> void:
	var file = FileAccess.open(path, FileAccess.READ)
	var content = file.get_as_text()
	file_content = content
	file_lines = file_content.split("\n")#.replace("\r","\n").replace("\t","\n").split("\n")

func throw_error(error: String):
	%Error.text = error
	%Error.show()

func _on_action_button_pressed() -> void:
	if %SelectCategory.selected == 0:
		throw_error("Bitte gib die Kategorie des Wortes an.")
		return
	if file_content == "":
		throw_error("Bitte wähle eine CSV-Datei aus!")
		return
	if %French.text == "":
		throw_error("Bitte wähle eine Spalten-ID für Französisch aus!")
		return
	if %German.text == "":
		throw_error("Bitte wähle eine Spalten-ID für Deutsch aus!")
		return
	if %Description.text == "":
		throw_error("Bitte wähle eine Spalten-ID für die Beschreibung aus!")
		return
	if %GrammaticalGender.text == "":
		throw_error("Bitte wähle eine Spalten-ID für das Geschlecht aus!")
		return
	var category = %SelectCategory.get_item_text(%SelectCategory.selected)
	var id = 0
	for row in file_lines:
		if id == 0 and %SkipFirstLine.button_pressed:
			id += 1
		else:
			id += 1
			var parts = split_escaped(row)
			if parts.size() <= int(%French.text):
				pass
			else:
				if parts[int(%French.text)] == "":
					pass
				else:
					var french = parts[int(%French.text)].split("; ")
					var german = parts[int(%German.text)].split("; ")
					var description = parts[int(%Description.text)]
					var grammatical_gender = ["UNSET","M","W","KEINE"].find(parts[int(%GrammaticalGender.text)]) if ["UNSET","M","W","KEINE"].find(parts[int(%GrammaticalGender.text)]) != -1 else 0
					var uid = randi_range(111111111,999999999)
					var word: Word = Word.new()
					word.description = description
					word.french = french
					word.german = german
					word.grammatical_gender = grammatical_gender
					word.uid = uid
					Vars.own_categorys[category]["words"].append(word)
	Vars.save_saves()
	Vars.current_open_category = category
	get_tree().change_scene_to_file("res://scenes/own_words/word_category.tscn")


func _on_back_button_pressed() -> void:
	View.open_tab("own_words")
