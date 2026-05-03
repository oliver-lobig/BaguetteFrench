extends Control

var selected_units = []
var selected_own_units = []
var all_selected_words = []
var all_selected_verbs = []

func _ready() -> void:
	load_units()

func load_units():
	for unit in Definitions.unit_sequence:
		var unit_name = Definitions.unit_names.get(unit)
		var instance = TextCheckBox.new()
		instance.text = unit_name
		instance.toggled.connect(reload_selection)
		instance.mouse_filter = Control.MOUSE_FILTER_PASS
		%ActiveUnits.add_child(instance)
	for unit in Vars.own_categorys:
		var unit_name = unit
		var instance = TextCheckBox.new()
		instance.text = unit_name
		instance.toggled.connect(reload_selection)
		instance.mouse_filter = Control.MOUSE_FILTER_PASS
		%OwnUnits.add_child(instance)

func reload_selection(_air: bool):

	selected_units = []
	var unit_sequence_id: int = 0
	for unit_node in %ActiveUnits.get_children():
		if unit_node.button_pressed:
			selected_units.append(Definitions.unit_sequence.get(unit_sequence_id))
		unit_sequence_id += 1
	unit_sequence_id = 0
	for unit_node in %OwnUnits.get_children():
		if unit_node.button_pressed:
			selected_own_units.append(Vars.own_categorys.keys()[unit_sequence_id])
		unit_sequence_id += 1
	var unit_words = Vars.words.filter(word_in_units)
	var unit_verbs = Vars.verbs.values().filter(verb_in_units)
	for unit in selected_own_units:
		unit_words.append_array(Vars.own_categorys[unit]["words"])
		unit_verbs.append_array(Vars.own_categorys[unit]["verbs"])
	if %OnlyMarked.button_pressed:
		var selected_words = unit_words.filter(word_selected)
		all_selected_words = selected_words
	else:
		all_selected_words = unit_words
	all_selected_verbs = unit_verbs
	%SelectedWords.text = str(all_selected_words.size()) + tr("SELECTED_WORDS") + " + " +str( all_selected_verbs.size())

func word_in_units(word: Word):
	return word.unit_id in selected_units

func verb_in_units(verb: Verb):
	return verb.category in selected_units

func word_selected(word: Word):
	return word in Vars.marked_words


func _on_check_box_2_pressed() -> void:
	var unit_sequence_id: int = 0
	for child in %ActiveUnits.get_children():
		if unit_sequence_id < Vars.max_unit:
			child.button_pressed = true
		else:
			child.button_pressed = false
		unit_sequence_id += 1


func _on_texture_button_pressed() -> void:
	Vars.all_learn_words = all_selected_words
	Vars.all_learn_verbs = all_selected_verbs
	Vars.save_saves()
	View.open_tab("learn_all")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("back"):
		_on_texture_button_pressed()
