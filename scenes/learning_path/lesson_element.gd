@tool
extends HBoxContainer

signal open_learn()

const GEM = preload("res://assets/scenes/learning_path/icons/gem.png")
const GEM_BROKEN = preload("res://assets/scenes/learning_path/icons/gems/gem_broken.png")
const GEM_DISABLED = preload("res://assets/scenes/learning_path/icons/gems/gem_disabled.png")

@export var time: float = 0.0
@export var field_type: int = 0
@export var unit_id: int = 0
@export var unit_title: String = ""
@export var field_id: int = 0
@export var field_uid: int = 0
@export var field_before_uid: int = 0
@export var is_next: bool = false

func get_unit_color(unit_id: int) -> String:
	var color_id = unit_id % 3
	var color_name = ""
	match color_id:
		0:
			color_name = "green"
		1:
			color_name = "blue"
		2:
			color_name = "red"
	return color_name

func _ready() -> void:
	var multiplyer = 4.0
	var sinus = (2 ** sin(time * 0.5)) + ((2 ** sin(time * 1)) / 2)
	if sinus >= 0:
		$Control.size_flags_stretch_ratio = (abs(sinus) / multiplyer) * multiplyer
		$Control2.size_flags_stretch_ratio = 1.0
	else:
		$Control.size_flags_stretch_ratio = 1.0
		$Control2.size_flags_stretch_ratio = (abs(sinus) / multiplyer) * multiplyer
	for child in $Button.get_children():
		if child is TextureRect:
			child.position.y = 0
	if field_type == Definitions.FieldTypes.LEARNING:
		$Control.text = unit_title
		match get_unit_color(unit_id):
			"green":
				$Line2D.default_color = Color(0.251, 0.976, 0.608,0.5)
			"blue":
				$Line2D.default_color = Color(0.024, 0.745, 0.882,0.5)
			"red":
				$Line2D.default_color = Color(0.957, 0.357, 0.412,0.5)
		$Line2D.show()
		$Button/Learning.show()
	else:
		$Control.text = ""
		$Line2D.hide()
		$Button/Learning.hide()
	
	if field_type == Definitions.FieldTypes.LISTEN_AND_SPEEK:
		$Button/Hearing.show()
	else:
		$Button/Hearing.hide()
	
	if field_type == Definitions.FieldTypes.MATCH:
		$Button/Match.show()
	else:
		$Button/Match.hide()
	
	if field_type == Definitions.FieldTypes.SINGLE_VOCAB:
		$Button/SingleVocab.show()
	else:
		$Button/SingleVocab.hide()
	
	if field_type == Definitions.FieldTypes.SENTENCES:
		$Button/Sentence.show()
	else:
		$Button/Sentence.hide()
	
	if field_type == Definitions.FieldTypes.REPETITION:
		$Button/Repeat.show()
	else:
		$Button/Repeat.hide()
	
	if field_type == Definitions.FieldTypes.VERBS:
		$Button/Verbs.show()
	else:
		$Button/Verbs.hide()
	
	if field_type != Definitions.FieldTypes.GEM:
		if is_next:
			$Button.grab_focus()
	
	if field_type == Definitions.FieldTypes.GEM:
		if !Vars.field_progress.has(field_uid):
			if is_next:
				$Button.texture_normal = GEM
				$Button.texture_pressed = GEM
				$Button.texture_hover = GEM
				$Button.texture_focused = GEM
				$Button.texture_disabled = GEM
				$Button.disabled = false
			else:
				$Button.texture_normal = GEM_DISABLED
				$Button.texture_pressed = GEM_DISABLED
				$Button.texture_hover = GEM_DISABLED
				$Button.texture_focused = GEM_DISABLED
				$Button.texture_disabled = GEM_DISABLED
		else:
			$Button.texture_disabled = GEM_BROKEN
			$Button.disabled = true
	
	if !Vars.done_field_ids.has(field_uid) and !is_next:
		
		$Button.disabled = true
		for child in $Button.get_children():
			if child is TextureRect:
				child.position.y = 7
				child.modulate = Color(1,1,1,0.2)
	elif field_type != Definitions.FieldTypes.GEM:
		$Button.disabled = false
		for child in $Button.get_children():
			if child is TextureRect:
				child.position.y = 0
				child.modulate = Color(1,1,1,1)



func _on_button_button_down() -> void:
	for child in $Button.get_children():
		if child is TextureRect:
			child.position.y = 5


func _on_button_button_up() -> void:
	for child in $Button.get_children():
		if child is TextureRect:
			child.position.y = 0


func _on_button_mouse_entered() -> void:
	for child in $Button.get_children():
		if child is TextureRect:
			child.position.y = 2


func _on_button_mouse_exited() -> void:
	if $Button.button_pressed == false:
		for child in $Button.get_children():
			if child is TextureRect:
				child.position.y = 0


func _on_button_pressed() -> void:
	open_learn.emit()
	Vars.learn_all = false
	var real_id = Definitions.unit_sequence[unit_id]
	Vars.current_open_unit = real_id
	Vars.current_open_field_id = field_uid
	
	if field_type == Definitions.FieldTypes.SINGLE_VOCAB:
		Vars.word_selection_type = "single"
		get_tree().change_scene_to_file("res://scenes/learning_methods/write.tscn")
	elif field_type == Definitions.FieldTypes.LEARNING:
		get_tree().change_scene_to_file("res://scenes/learning_methods/learn_vocab.tscn")
	elif field_type == Definitions.FieldTypes.MATCH:
		get_tree().change_scene_to_file("res://scenes/match_learn.tscn")
	elif field_type == Definitions.FieldTypes.SENTENCES:
		Vars.word_selection_type = "sentence"
		get_tree().change_scene_to_file("res://scenes/learning_methods/write.tscn")
	elif field_type == Definitions.FieldTypes.LISTEN_AND_SPEEK:
		get_tree().change_scene_to_file("res://scenes/learning_methods/hearing.tscn")
	elif field_type == Definitions.FieldTypes.GEM:
		get_tree().change_scene_to_file("res://scenes/learning_path/extra_points.tscn")
	elif field_type == Definitions.FieldTypes.REPETITION:
		Vars.word_selection_type = "review"
		get_tree().change_scene_to_file("res://scenes/learning_methods/write.tscn")
	elif field_type == Definitions.FieldTypes.VERBS:
		Vars.word_selection_type = "verbs"
		get_tree().change_scene_to_file("res://scenes/learning_methods/write.tscn")
