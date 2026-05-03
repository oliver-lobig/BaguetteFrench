@tool
extends HBoxContainer

@export var verb: Verb = Verb.new()

@onready var word_fields = {
	"s1":%S1,
	"s2":%S2,
	"s3":%S3,
	"p1":%P1,
	"p2":%P2,
	"p3":%P3,
	"pc":%PC
}
var content = ""

func _ready() -> void:
	$Infinitive/French.text = WordHandler.get_words_string(verb.infinitive.french)
	$Infinitive/German.text = WordHandler.get_words_string(verb.infinitive.german)
	
	%ID.text = str(verb.uid)
	
	
	$UnitEnum.clear()
	for item in Definitions.Units.keys():
		$UnitEnum.add_item(item)
	%UnitEnum.selected = verb.category
	for field_name in word_fields.keys():
		var field_node = word_fields[field_name]
		field_node.get_node("French").text = WordHandler.get_words_string(verb.versions[field_name].french)
		field_node.get_node("German").text = WordHandler.get_words_string(verb.versions[field_name].german)
	
	%SuffixDe.text = WordHandler.get_words_string(verb.suffix["german"])
	%SuffixFr.text = WordHandler.get_words_string(verb.suffix["french"])
	update_search_content()
	
	AdminVars.send_query.connect(handle_search)

func update_verb():
	update_search_content()
	Vars.verbs[verb.uid] = verb
	Vars.save_saves()

func _on_infinitive_new_version(german: String, french: String) -> void:
	verb.infinitive.german = german.split("; ")
	verb.infinitive.french = french.split("; ")
	update_infinitive(german, french)
	update_verb()

func update_version(version: String, german: String, french: String):
	
	#if verb.versions[version].german.is_read_only() or verb.versions[version].french.is_read_only():
	var new_word = Word.new()
	for w in verb.versions[version].german:
		new_word.german.append(w)
	for w in verb.versions[version].french:
		new_word.french.append(w)
	new_word.learn_score = verb.versions[version].learn_score
	new_word.trys = verb.versions[version].trys
	new_word.trys_correct = verb.versions[version].trys_correct
	new_word.description = verb.versions[version].description
	verb.versions[version] = new_word
	verb.versions[version].german = german.split("; ")
	verb.versions[version].french = french.split("; ")

func update_infinitive(german: String, french: String):
	var new_word = Word.new()
	for w in verb.infinitive.german:
		new_word.german.append(w)
	for w in verb.infinitive.french:
		new_word.french.append(w)
	new_word.learn_score = verb.infinitive.learn_score
	new_word.trys = verb.infinitive.trys
	new_word.trys_correct = verb.infinitive.trys_correct
	new_word.description = verb.infinitive.description
	verb.infinitive = new_word
	verb.infinitive.german = german.split("; ")
	verb.infinitive.french = french.split("; ")

func _on_s_1_new_version(german: String, french: String) -> void:
	update_version("s1",german,french)
	update_verb()

func _on_s_2_new_version(german: String, french: String) -> void:
	update_version("s2",german,french)
	update_verb()

func _on_s_3_new_version(german: String, french: String) -> void:
	update_version("s3",german,french)
	update_verb()

func _on_p_1_new_version(german: String, french: String) -> void:
	update_version("p1",german,french)
	update_verb()

func _on_p_2_new_version(german: String, french: String) -> void:
	update_version("p2",german,french)
	update_verb()

func _on_p_3_new_version(german: String, french: String, source) -> void:
	update_version("p3",german,french)
	update_verb()

func _on_pc_new_version(german: String, french: String) -> void:
	update_version("pc",german,french)
	update_verb()

func _on_suffix_fr_text_changed(new_text: String) -> void:
	var suffixes = {
		"french": new_text.split("; "),
		"german": verb.suffix["german"]
	}
	verb.suffix = suffixes
	update_verb()

func _on_suffix_de_text_changed(new_text: String) -> void:
	var suffixes = {
		"german": new_text.split("; "),
		"french": verb.suffix["french"]
	}
	verb.suffix = suffixes
	update_verb()

func update_search_content():
	var content = "suffix: " + WordHandler.get_words_string(verb.suffix.french) + " - " + WordHandler.get_words_string(verb.suffix.german)
	for version in word_fields.keys():
		var german_text = WordHandler.get_words_string(verb.versions[version].german)
		var french_text = WordHandler.get_words_string(verb.versions[version].french)
		var version_text = version + ": " + french_text + " - " + german_text
		content += version_text
	content += "infinitive: " + WordHandler.get_words_string(verb.infinitive.french) + " - " + WordHandler.get_words_string(verb.infinitive.german)

func handle_search():
	if AdminVars.search_query == "":
		show()
	elif AdminVars.search_query.to_lower() in content.to_lower():
		show()
	else:
		hide()

func _on_delete_button_pressed() -> void:
	Vars.verbs.erase(verb.uid)
	queue_free()


func _on_unit_enum_item_selected(index: int) -> void:
	verb.category = index
	update_verb()


func _on_verb_field_new_version(german: String, french: String) -> void:
	for part in %VBoxContainer.get_children():
		for field_group in part.get_children():
			if field_group is HBoxContainer:
				field_group.get_node("French").text = french
				field_group.get_node("German").text = german


func _on_button_pressed() -> void:
	%VerbField.visible = !%VerbField.visible
