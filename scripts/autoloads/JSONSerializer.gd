@tool
extends Node

func _ready() -> void:
	DirAccess.make_dir_absolute("user://json_exports/")

func load_words(path: String):
	if not FileAccess.file_exists(path):
		printerr("Cannot Load JSON: Path is wrong (", path ,")")
		return
	var file_access = FileAccess.open(path,FileAccess.READ)
	var json_string = file_access.get_line()
	file_access.close()
	
	var json := JSON.new()
	var error := json.parse(json_string)
	if error:
		print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
		return
	var words = json.data.words
	var current_ids = []
	var word_ids = []
	for word in words:
		word_ids.append(int(word.uid))
	for current_word in Vars.words:
		if !current_word.uid in word_ids:
			Vars.words.erase(current_word)
			AdminVars.reload_ids()
	for word in Vars.words:
		current_ids.append(word.uid)
	for word in words:
		if !int(word.uid) in current_ids:
			var new_word = get_word_from_dict(word)
			new_word.id = Vars.words.size()
			Vars.words.append(new_word)
		else:
			var current_word = WordHandler.get_word_from_uid(int(word.uid))
			if word.german != current_word.german:
				current_word.german = word.german
			if word.french != current_word.french:
				current_word.french = word.french
			if word.description != current_word.description:
				current_word.description = word.description
			if word.is_plural != current_word.is_plural:
				current_word.is_plural = word.is_plural
			if word.grammatical_gender != current_word.grammatical_gender:
				current_word.grammatical_gender = word.grammatical_gender
			if word.sentence_type != current_word.sentence_type:
				current_word.sentence_type = word.sentence_type
			if word.unit_id != current_word.unit_id:
				current_word.unit_id = word.unit_id

func get_word_from_dict(word_data: Dictionary) -> Word:
	var word: Word = Word.new()
	word.id = word_data.id
	word.german = word_data.german
	word.french = word_data.french
	word.description = word_data.description
	word.learn_score = word_data.learn_score
	word.trys_correct = word_data.trys_correct
	word.trys = word_data.trys
	word.is_plural = word_data.is_plural
	word.grammatical_gender = word_data.grammatical_gender
	word.sentence_type = word_data.sentence_type
	word.unit_id = word_data.unit_id
	word.uid = word_data.uid
	return word

func export_words(words: Array,save_path: String):
	var json_data: Dictionary = {}
	var json_words: Array = []
	for word in words:
		var word_data: Dictionary = {
			"id":word.id,
			"german":word.german,
			"french":word.french,
			"description":word.description,
			"learn_score":word.learn_score,
			"trys_correct":word.trys_correct,
			"trys":word.trys,
			"is_plural":word.is_plural,
			"grammatical_gender":word.grammatical_gender,
			"sentence_type":word.sentence_type,
			"unit_id":word.unit_id,
			"uid":word.uid
		}
		json_words.append(word_data)
	json_data["words"] = json_words
	var new_json_string = JSON.stringify(json_data)
	var file_access_save = FileAccess.open(save_path,FileAccess.WRITE)
	if not file_access_save:
		print("An error happened while saving data: ", FileAccess.get_open_error())
		return
	file_access_save.store_line(new_json_string)
	file_access_save.close()
