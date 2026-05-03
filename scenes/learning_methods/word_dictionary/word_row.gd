extends PanelContainer

var word: Word

func _ready() -> void:
	%From.text = WordHandler.get_words_string(word.french) if Vars.to_french == false else WordHandler.get_words_string(word.german)
	%To.text = WordHandler.get_words_string(word.french) if Vars.to_french == true else WordHandler.get_words_string(word.german)
	if word.description:
		%Description.text = word.description
		%Description.show()
		$MarginContainer/VBoxContainer/HSeparator.show()
	else:
		%Description.hide()
		$MarginContainer/VBoxContainer/HSeparator.hide()
	
	Vars.search_dictionary.connect(check_search)

func check_search():
	if Vars.search_query != "":
		var search_word: String = ""
		if Vars.to_french == false:
			search_word += "Französisch: " + WordHandler.get_words_string(word.french)
		else:
			search_word += "Deutsch: " + WordHandler.get_words_string(word.german)
		if Vars.to_french == false:
			search_word += " Deutsch: " + WordHandler.get_words_string(word.german)
		else:
			search_word += " Französisch: " + WordHandler.get_words_string(word.french)
		search_word += " Beschreibung: " + word.description
		if search_word.to_lower().contains(Vars.search_query.to_lower()):
			show()
		else:
			hide()
	else:
		show()
