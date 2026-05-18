@tool
extends Node

@warning_ignore("unused_signal")
signal search_dictionary()
@warning_ignore("unused_signal")
signal downloaded_new_words()

var search_query: String = ""

var words: Array = []
var marked_words: Array = []

var learning_progress: int = 0
var field_progress: Dictionary = {}

var to_french: bool = true
var current_open_unit: int = 1
var current_open_field_id: int = 0
var current_learn_progress_next: bool = false

var current_scroll: int = 0

var word_selection_type: String = "single" # single / sentence / review
var max_unit: int = 1
var learn_all: bool = false

var learn_points: int = 0

var whole_dictionary: bool = false

var settings_data: SettingsData = SettingsData.new()

var to_language_french: bool = true
var locked_language_french: bool = true

var baguette_style_data: BaguetteStyleData = BaguetteStyleData.new()
var baguette_shop_assortment: BaguetteShopAssortment = BaguetteShopAssortment.new()


var done_field_ids: Array = []
var chapter_content: Dictionary

var all_learn_words: Array = []
var all_learn_verbs: Array = []

var update_check_request: HTTPRequest = HTTPRequest.new()

var new_word_request: HTTPRequest = HTTPRequest.new()
 
var last_save_ids: Dictionary = {
	"words":"-1",
	"path":"-1",
	"shop_assortment":"-1"
}

var verbs: Dictionary = {}

var challenge_progress: Dictionary = {
	
}

# TUTORIAL

var finished_tutorial_scenes: Array = []
var skip_tutorial: bool = false
var finished_intro: bool = false
var in_tutorial_screen: bool = false

# OWN WORDS

var own_categorys = {}

var word_edit_mode = "add" # also "edit"
var original_edit_word: Word = null
var original_edit_verb: Verb = null
var current_open_category: String = ""



func _ready() -> void:
	Vars.word_selection_type = "verbs"
	Vars.current_open_unit = 1
	OS.request_permissions()
	DirAccess.make_dir_absolute("user://data/")
	DirAccess.make_dir_absolute("user://online_local/")
	update_save_file()
	add_chapters()
	load_saves()
	randomize()
	for word in Vars.words:
		if word.uid <= 0:
			word.uid = randi_range(111111111,999999999)
	if Vars.settings_data.language == "none":
		if TranslationServer.get_locale() == "de" or TranslationServer.get_locale() == "fr":
			Vars.settings_data.language = TranslationServer.get_locale()
		else:
			Vars.settings_data.language = "de"
	TranslationServer.set_locale("ace") # To see if own Translations Server is actually working
	BaguetteTranslationServer.set_locale(Vars.settings_data.language)
	Vars.save_saves("Vars on ready")
	download_update_check_file()

func download_update_check_file():
	update_check_request.download_file = "user://online_local/updates.txt"
	update_check_request.request_completed.connect(update_check_done)
	add_child(update_check_request)
	update_check_request.request("https://oliver-lobig.github.io/BaguetteFrench/updates.txt")

func update_check_done(_result: int, _response_code: int, _headers: PackedStringArray, _body: PackedByteArray):
	var file = FileAccess.open("user://online_local/updates.txt",FileAccess.READ)
	var content = file.get_as_text()
	var lines = content.split("\n")
	
	if lines[0].strip_edges() != last_save_ids.words:
		last_save_ids["words"] = lines[0].strip_edges() 
		Vars.save_saves("Vars update new Words from Internet")
		update_word_data()

func update_word_data():
	new_word_request = HTTPRequest.new()
	View.new_content.emit("Es gibt neue Wörter!")
	new_word_request.download_file = "user://online_local/words.json"
	new_word_request.request_completed.connect(new_words_downloaded)
	add_child(new_word_request)
	new_word_request.request("https://oliver-lobig.github.io/BaguetteFrench/words.json")

func new_words_downloaded(_result: int, _response_code: int, _headers: PackedStringArray, _body: PackedByteArray):
	JsonSerializer.load_words("user://online_local/words.json")
	downloaded_new_words.emit()

func add_chapters():
	if FileAccess.file_exists("user://data/save_file.tres"):
		var save_file = ResourceLoader.load("user://data/save_file.tres")
		var preset_save_file = ResourceLoader.load("res://data/save_file.tres")
		if !save_file is SaveFile:
			return
		if save_file.chapter_content != preset_save_file.chapter_content:
			save_file.chapter_content = preset_save_file.chapter_content
		
		ResourceSaver.save(save_file,"user://data/save_file.tres")

func has_quest_with_type(type: int):
	var datetime = Time.get_datetime_dict_from_system()
	for quest_id in challenge_progress.keys():
		var quest = challenge_progress[quest_id]
		if str(quest_id).begins_with(str(datetime.year) + str(datetime.month) + str(datetime.day)):
			if quest.type == type:
				if quest.done == false:
					if quest.accepted == true:
						return true
	return false

func update_save_file():
	
	var replacements = {
		"res://ClothingItem.gd":"res://scripts/classes/ClothingItem.gd",
		"res://BaguetteShopAssortment.gd":"res://scripts/classes/BaguetteShopAssortment.gd",
		"res://BaguetteStyleData.gd":"res://scripts/classes/BaguetteStyleData.gd",
		"res://settings.gd":"res://scripts/classes/settings.gd",
		"res://scripts/save_file.gd":"res://scripts/classes/save_file.gd",
		"res://word.gd":"res://scripts/classes/word.gd",
		"res://Verb.gd":"res://scripts/classes/Verb.gd"
	}
	
	if FileAccess.file_exists("user://data/save_file.tres"):
			
		var file = FileAccess.open("user://data/save_file.tres",FileAccess.READ_WRITE)
		var content = file.get_as_text()
		
		var content_temp = content
		
		var replaced = false
		var old_content = ""
		
		for replacement in replacements.keys():
			old_content = content
			content = content.replace(replacement,replacements.get(replacement))
			if content != old_content:
				replaced = true
		
		if replaced:
			print("Savefile-Version is outdated! Upgrading filetype.")
			
			var file_temp = FileAccess.open("user://data/save_file_temp.tres",FileAccess.READ_WRITE)
			
			var new_file_backup = FileAccess.open("user://data/save_file_preupdate_" + str(int(floor(Time.get_unix_time_from_system()))) + ".tres",FileAccess.WRITE)
			new_file_backup.store_string(content_temp)
		
		var new_file = FileAccess.open("user://data/save_file.tres",FileAccess.WRITE)
		new_file.store_string(content)
		
		var new_file_test = FileAccess.open("user://data/save_file_test.tres",FileAccess.WRITE)
		new_file_test.store_string(content)

func load_saves():
	#print("Loaded *LAG*") # This is used to find out where things are loaded, to minimize the use of this expensive function.
	var save_file: SaveFile
	if !FileAccess.file_exists("user://data/save_file.tres"):
		save_file = ResourceLoader.load("res://data/save_file.tres")
		ResourceSaver.save(save_file,"user://data/save_file.tres")
	else:
		save_file = ResourceLoader.load("user://data/save_file.tres")
		if !save_file is SaveFile:
			return
	var read_only_save_file = ResourceLoader.load("res://data/save_file.tres")
	baguette_shop_assortment = read_only_save_file.baguette_shop_assortment
	verbs = save_file.verbs
	for verb in read_only_save_file.verbs:
		if !verbs.has(verb):
			verbs[verb] = read_only_save_file.verbs[verb]
		else:
			for version in verbs[verb].versions.keys():
				verbs[verb].versions[version].german = read_only_save_file.verbs[verb].versions[version].german
				verbs[verb].versions[version].french = read_only_save_file.verbs[verb].versions[version].french
			if !verbs[verb].suffix.is_read_only():
				verbs[verb].suffix["german"] = read_only_save_file.verbs[verb].suffix["german"]
				verbs[verb].suffix["french"] = read_only_save_file.verbs[verb].suffix["french"]
	for verb in verbs:
		if !verb in read_only_save_file.verbs:
			verbs.erase(verb)
	finished_tutorial_scenes = save_file.finished_tutorial_scenes
	skip_tutorial = save_file.skip_tutorial
	finished_intro = save_file.finished_intro
	baguette_style_data = save_file.baguette_style_data
	max_unit = save_file.max_unit
	all_learn_words = save_file.all_learn_words
	all_learn_verbs = save_file.all_learn_verbs
	settings_data = save_file.settings_data
	to_french = settings_data.to_french
	to_language_french = settings_data.to_french
	learn_points = save_file.learn_points
	challenge_progress = save_file.challenge_progress
	current_scroll = save_file.current_scroll
	field_progress = save_file.field_progress
	own_categorys = save_file.own_categorys
	last_save_ids = save_file.last_save_ids
	words = save_file.words
	marked_words = save_file.marked_words
	done_field_ids = save_file.done_field_ids
	
	chapter_content = save_file.chapter_content
	var gem_bus_id = AudioServer.get_bus_index("PointParticle")
	AudioServer.set_bus_mute(gem_bus_id, settings_data.jewel_volume == -40)
	AudioServer.set_bus_volume_db(gem_bus_id, settings_data.jewel_volume)

func save_saves(context: String = "none"):
	#print("Saved *LAG* | ",context)  # This is used to find out where things are saved, to minimize the use of this expensive function.
	var save_file: SaveFile = SaveFile.new()
	save_file.done_field_ids = done_field_ids
	save_file.chapter_content = chapter_content
	save_file.baguette_shop_assortment = baguette_shop_assortment
	save_file.baguette_style_data = baguette_style_data
	save_file.max_unit = max_unit
	save_file.verbs = verbs
	save_file.last_save_ids = last_save_ids
	save_file.all_learn_words = all_learn_words
	save_file.all_learn_verbs = all_learn_verbs
	save_file.settings_data = settings_data
	save_file.challenge_progress = challenge_progress
	save_file.own_categorys = own_categorys
	save_file.learn_points = learn_points
	save_file.current_scroll = current_scroll
	save_file.field_progress = field_progress
	save_file.words = words
	save_file.marked_words = marked_words
	save_file.finished_tutorial_scenes = finished_tutorial_scenes
	save_file.skip_tutorial = skip_tutorial
	save_file.finished_intro = finished_intro
	var save_path = "user://data/save_file.tres" if !Engine.is_editor_hint() else "user://data/save_file_editor.tres"
	var error = ResourceSaver.save(save_file,save_path)
	if error != OK:
		print("Saving error: ", error)
