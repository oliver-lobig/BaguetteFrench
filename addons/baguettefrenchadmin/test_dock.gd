@tool
extends Control

const WORD_ROW = preload("res://addons/baguettefrenchadmin/word_row.tscn")
const CLOTHING_ROW = preload("res://addons/baguettefrenchadmin/clothing_row.tscn")
const CHAPTER_CONTENT = preload("res://addons/baguettefrenchadmin/chapter_content.tscn")
const VERB_LINE = preload("res://addons/baguettefrenchadmin/verb_line.tscn")

var loaded_words: bool = false
## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#size = EditorInterface.get_editor_main_screen().get_parent_control().size
	#position = EditorInterface.get_editor_main_screen().get_parent_control().position
	#print_tree_pretty()

var current_adjusting_clothing_item: ClothingItem
var current_open_chapter_id: int = -1
var working_merge_id: int = 0
func _ready() -> void:
	loaded_words = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	check_changed()

func check_changed():
	if size != EditorInterface.get_editor_main_screen().get_parent_control().size or position != EditorInterface.get_editor_main_screen().get_parent_control().position:
		size = EditorInterface.get_editor_main_screen().get_parent_control().size
		position = EditorInterface.get_editor_main_screen().get_parent_control().position
#
#func _on_button_pressed() -> void:
	#size = EditorInterface.get_editor_main_screen().get_parent_control().size
	#position = EditorInterface.get_editor_main_screen().get_parent_control().position
	#print_tree_pretty()

func load_clothes():
	for child in %ClothingItems.get_children():
		child.queue_free()
	for item in Vars.baguette_shop_assortment.assortment.values():
		var instance = CLOTHING_ROW.instantiate()
		instance.item = item
		instance.adjust_transform.connect(open_adjust)
		%ClothingItems.add_child(instance)

func load_words():
	for child in %Words.get_children():
		child.queue_free()
	for word in Vars.words:
		var instance = WORD_ROW.instantiate()
		instance.word = word
		instance.words_french = word.french
		instance.word_id = word.id
		instance.is_plural = word.is_plural
		instance.words_german = word.german
		instance.description = word.description
		instance.type = word.sentence_type
		instance.unit_id = word.unit_id
		instance.grammatical_gender = word.grammatical_gender
		%Words.add_child(instance)

func load_verbs():
	for child in %Verbs.get_children():
		child.queue_free()
	for verb in Vars.verbs.values():
		var instance = VERB_LINE.instantiate()
		instance.verb = verb
		%Verbs.add_child(instance)

func _on_button_pressed() -> void:
	$Words.show()
	if loaded_words == false:
		loaded_words = true
		load_words()
	$Main.hide()


func _on_words_back_button_pressed() -> void:
	$Main.show()
	$Words.hide()
	$Clothes.hide()


func _on_load_words_button_pressed() -> void:
	$Words.hide()
	$LoadWords.show()


func _on_load_words_back_pressed() -> void:
	$Main.show()
	$LoadWords.hide()


func _on_load_words_pressed() -> void:
	pass#var database = SQLite.new()
	#database.path = "res://words.db"
	#database.open_db()
	#var word_id: int = 0
	#for word in database.select_rows("words_table","",["*"]):
		#var word_object = Word.new()
		#print(word)
		#word_object.german = [word.get("word_german")]
		#word_object.french = [word.word_french]
		#word_object.id = word_id
		#word_object.description = word.description
		#if !Vars.words.has(word_object):
			#Vars.words.append(word_object)
		#word_id += 1
	#
	#database.close_db()
	#
	#Vars.save_saves()


func _on_save_words_pressed() -> void:
	Vars.save_saves()
	
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	
	var predata: SaveFile
	if FileAccess.file_exists("res://data/save_file.tres"):
		predata = ResourceLoader.load("res://data/save_file.tres")
		if !predata is SaveFile:
			printerr("Couldn't save Peload-File! It has the wrong content.")
			return
		var clean_words = []
		var marked_words = []
		for word in Vars.words:
			var new_word = (word as Word).duplicate(true)
			new_word.learn_score = 0
			new_word.trys = 0
			new_word.trys_correct = 0
			if word in Vars.marked_words:
				marked_words.append(new_word)
			clean_words.append(new_word)
		var clean_verbs = {}
		for verb in Vars.verbs.values():
			var new_verb = verb.duplicate(true)
			for version in new_verb.versions.values():
				version.learn_score = 0
				version.trys = 0
				version.trys_correct = 0
			(verb as Verb).infinitive.learn_score = 0
			(verb as Verb).infinitive.trys = 0
			(verb as Verb).infinitive.trys_correct = 0
			clean_verbs[verb.uid] = verb
		predata.verbs = clean_verbs
		predata.words = clean_words
		predata.marked_words = marked_words
		ResourceSaver.save(predata,"res://data/save_file.tres")


func _on_reload_words_pressed() -> void:
	load_words()


func _on_add_word_pressed() -> void:
	var word = Word.new()
	var id = Vars.words.size()
	Vars.words.append(word)
	randomize()
	word.id = id
	word.uid = randi_range(111111111,999999999)
	var instance = WORD_ROW.instantiate()
	instance.word = word
	instance.words_french = word.french
	instance.word_id = word.id
	instance.is_plural = word.is_plural
	instance.words_german = word.german
	instance.description = word.description
	instance.type = word.sentence_type
	instance.unit_id = word.unit_id
	instance.grammatical_gender = word.grammatical_gender
	%Words.add_child(instance)
	await get_tree().process_frame
	%ScrollContainer.scroll_vertical = %Words.size.y + 64


func _on_search_query_text_changed(new_text: String) -> void:
	AdminVars.search_query = new_text
	AdminVars.send_query.emit()


func _on_button_2_pressed() -> void:
	load_clothes()
	$Main.hide()
	$Clothes.show()


func _on_reload_clothes_pressed() -> void:
	load_clothes()


func _on_add_clothes_pressed() -> void:
	var id: int = -1
	while id == -1:
		var item_id: int = randi_range(20000,99999)
		if !Vars.baguette_shop_assortment.assortment.has(item_id):
			id = item_id
	
	var creation_time = Time.get_unix_time_from_system()
	
	var item = ClothingItem.new()
	item.id = id
	item.creation_time = creation_time
	
	var instance = CLOTHING_ROW.instantiate()
	instance.adjust_transform.connect(open_adjust)
	instance.item = item
	%ClothingItems.add_child(instance)
	Vars.baguette_shop_assortment.assortment[id] = item

func open_adjust(item: ClothingItem):
	current_adjusting_clothing_item = item
	
	$Clothes.hide()
	$ChangeClothingPosition.show()
	
	match item.type:
		"hats":
			%BreadRender.override_hat = item.id
		"faces":
			%BreadRender.override_face = item.id
		"shirts":
			%BreadRender.override_shirt = item.id
		"pants":
			%BreadRender.override_pants = item.id
	
	%BreadRender.always_talk = true
	%BreadRender.start_talk()
	%BreadRender.load_style()

func _on_offset_x_value_changed(value: float) -> void:
	current_adjusting_clothing_item.offset.x = value
	%BreadRender.update_positions()

func _on_offset_y_value_changed(value: float) -> void:
	current_adjusting_clothing_item.offset.y = value
	%BreadRender.update_positions()

func _on_scale_x_value_changed(value: float) -> void:
	current_adjusting_clothing_item.scale.x = value
	%BreadRender.update_positions()

func _on_scale_y_value_changed(value: float) -> void:
	current_adjusting_clothing_item.scale.y = value
	%BreadRender.update_positions()


func _on_done_pressed() -> void:
	Vars.save_saves()
	%BreadRender.always_talk = false
	$ChangeClothingPosition.hide()
	$Clothes.show()


func _on_button_3_pressed() -> void:
	$Main.hide()
	$ChangeChapterContent.show()
	for child in %Chapters.get_children():
		child.queue_free()
	for chapter in Definitions.unit_sequence:
		var chapter_name = Definitions.unit_names.get(chapter)
		var button: Button = Button.new()
		button.text = str(chapter) + " | " + chapter_name + " | " + str(WordHandler.get_words_in_unit(chapter).size()) + " | " + str(WordHandler.get_verbs_in_unit(chapter).size())
		button.connect("pressed",load_chapter.bind(button))
		%Chapters.add_child(button)

func load_chapter(button: Button):
	for b in %Chapters.get_children():
		b.disabled = b == button
	if current_open_chapter_id != -1:
		save_content()
	var chapter_id = int(button.text.split(" | ")[0])
	current_open_chapter_id = chapter_id
	for child in %ChapterContent.get_children():
		child.queue_free()
	if !Vars.chapter_content.has(chapter_id):
		return
	var current_id = 0
	for content in Vars.chapter_content.get(chapter_id):
		var instance = CHAPTER_CONTENT.instantiate()
		instance.field_id = content.get("id")
		instance.field_type = content.get("type")
		instance.id = current_id
		instance.connect("up",chapter_up)
		instance.connect("delete",delete_content)
		instance.connect("down",chapter_down)
		%ChapterContent.add_child(instance)
		current_id += 1

func chapter_up(id: int):
	var new_id = max(id - 1,0)
	%ChapterContent.get_child(id).id = new_id
	%ChapterContent.move_child(%ChapterContent.get_child(id),new_id)

func chapter_down(id: int):
	var new_id = min(id + 1,%ChapterContent.get_child_count() - 1)
	%ChapterContent.get_child(id).id = new_id
	%ChapterContent.move_child(%ChapterContent.get_child(id),new_id)

func _on_back_content_pressed() -> void:
	$Main.show()
	$ChangeChapterContent.hide()
	save_content()


func _on_add_chapter_content_pressed() -> void:
	var instance = CHAPTER_CONTENT.instantiate()
	randomize()
	instance.field_id = randi_range(0,100000000)
	instance.id = %ChapterContent.get_child_count()
	instance.connect("up",chapter_up)
	instance.connect("delete",delete_content)
	instance.connect("down",chapter_down)
	%ChapterContent.add_child(instance)

func delete_content(id: int):
	%ChapterContent.get_child(id).queue_free()
	await get_tree().process_frame
	reload_ids()

func save_content():
	var all_content = []
	for content in %ChapterContent.get_children():
		var data: Dictionary = {}
		data.id = content.get_id()
		data.type = content.get_type()
		all_content.append(data)
	var temp_dict = Vars.chapter_content.duplicate_deep()
	temp_dict[current_open_chapter_id] = all_content
	if current_open_chapter_id != -1:
		Vars.chapter_content = temp_dict

func reload_ids():
	var current_id: int = 0
	for content in %ChapterContent.get_children():
		content.id = current_id
		current_id += 1


func _on_save_pressed() -> void:
	save_content()
	Vars.save_saves()


func _on_save_basic_pressed() -> void:
	save_content()
	var save_file: SaveFile = load("res://data/save_file.tres")
	save_file.chapter_content = Vars.chapter_content
	ResourceSaver.save(save_file,"res://data/save_file.tres")


func _on_back_merge_pressed() -> void:
	$Merge.hide()
	$Main.show()


func _on_button_4_pressed() -> void:
	$Merge.show()
	$Main.hide()


func _on_save_merge_pressed() -> void:
	Vars.save_saves()

func check_words_same(word_a: Word, word_b: Word,language: String):
	var words_a = word_a.german if language == "german" else word_a.french
	var words_b = word_b.german if language == "german" else word_b.french
	var same: bool = false
	for input_word in words_a:
		var is_same: bool = WordHandler.check_correct(input_word,words_b,language,false)
		if is_same == true and word_a.description.similarity(word_b.description) >= 0.8:
			same = true
	return same if word_a.id != word_b.id else false

func _on_next_merge_pressed() -> void:
	var max_checks: int = 0
	var words_size = Vars.words.size()
	var found: bool = false
	
	if working_merge_id >= words_size**2:
		working_merge_id = 0
	var same_words = []
	while max_checks <= 100000 and found == false:
		var word_id_a: int = working_merge_id % words_size
		var word_id_b: int = floor(working_merge_id / words_size)
		var word_a = WordHandler.get_word_from_id(word_id_a)
		if word_a == null:
			break
		var word_b = WordHandler.get_word_from_id(word_id_b)
		if word_b == null:
			break
		var same = check_words_same(word_a,word_b,%LanguageMerge.text)
		if same == true:
			found = true
			print(max_checks, " | ", working_merge_id)
			same_words = [word_a,word_b]
		working_merge_id += 1
		max_checks += 1
		if max_checks % 5000 == 0:
			print(max_checks, " | ", working_merge_id)
			await get_tree().process_frame
	for child in %MergeWords.get_children():
		child.queue_free()
	for word in same_words:
		var instance = WORD_ROW.instantiate()
		instance.word = word
		instance.words_french = word.french
		instance.word_id = word.id
		instance.is_plural = word.is_plural
		instance.words_german = word.german
		instance.description = word.description
		instance.type = word.sentence_type
		instance.unit_id = word.unit_id
		instance.grammatical_gender = word.grammatical_gender
		%MergeWords.add_child(instance)


func _on_export_words_json_pressed() -> void:
	JsonSerializer.export_words(Vars.words,"user://json_exports/words.json")


func _on_button_5_pressed() -> void:
	$Main.hide()
	$Verbs.show()
	load_verbs()


func _on_verbs_back_button_pressed() -> void:
	$Main.show()
	$Verbs.hide()


func _on_add_verb_pressed() -> void:
	var new_verb = Verb.new()
	new_verb.uid = randi_range(111111111,999999999)
	var instance = VERB_LINE.instantiate()
	instance.verb = new_verb
	%Verbs.add_child(instance)
	Vars.verbs[new_verb.uid] = new_verb


func _on_load_verbs_button_pressed() -> void:
	load_verbs()
