extends Control

const H_ALIGNMENT = preload("res://scenes/learning_path/lesson_element.tscn")

var time = 0.0
var scaled_bg_size: Vector2 = Vector2(640,40216)

func calculate_scale() -> float:
	var viewport_size = Vector2(ProjectSettings.get("display/window/size/viewport_width"),ProjectSettings.get("display/window/size/viewport_height"))
	var window_size = get_window().size
	var expand_scale = 0.0
	
	if (window_size.x / viewport_size.x) > (window_size.y / viewport_size.y):
		expand_scale = min(window_size.y / viewport_size.y,1.0) 
	else:
		expand_scale = min(window_size.x / viewport_size.x,1.0)
	return expand_scale

func set_bg_pos():
	var expand_multiplyer = Vector2(1,1)
	var original_size = Vector2(ProjectSettings.get_setting("display/window/size/viewport_width"),ProjectSettings.get_setting("display/window/size/viewport_height"))
	var window_size = get_window().size
	if !OS.get_name() == "Android":
		$TextureRect.scale.x = (window_size.x / scaled_bg_size.x) / calculate_scale()
	$TextureRect.position.y = -$ScrollContainer.scroll_vertical

func get_unit_fields() -> Array:
	var fields = []
	for unit in Definitions.unit_sequence:
		var unit_fields = []
		for field in Vars.chapter_content[unit]:
			unit_fields.append(field)
		fields.append(unit_fields)
	return fields

func add_unit_fields(unit_field_data: Array = []):
	var unit_id = 0
	var field_id = 0
	var last_uid: int = -1
	var had_next: bool = false
	for unit in unit_field_data:
		
		var unit_color = get_unit_color(unit_id)
		var normal = load("res://assets/scenes/learning_path/" + unit_color + "/button_up.png")
		var down = load("res://assets/scenes/learning_path/" + unit_color + "/button_down.png")
		var hover = load("res://assets/scenes/learning_path/" + unit_color + "/button_hover.png")
		var disabeld = load("res://assets/scenes/learning_path/" + unit_color + "/button_disabled.png")
		var focus = load("res://assets/scenes/learning_path/" + unit_color + "/button_focus.png")
		
		
		for field in unit:
			
			var instance = H_ALIGNMENT.instantiate()
			if !Vars.done_field_ids.has(field.id) and had_next == false:
				had_next = true
				instance.is_next = true
			instance.time = time
			instance.field_type = field.type
			instance.field_id = field_id
			instance.field_uid = field.id
			instance.field_before_uid = last_uid
			last_uid = field.id
			instance.unit_id = unit_id
			instance.connect("open_learn",opened_learn)
			instance.unit_title = Definitions.unit_names.get(Definitions.unit_sequence.get(unit_id))
			instance.get_node("Button").texture_normal = normal
			instance.get_node("Button").texture_pressed = down
			instance.get_node("Button").texture_hover = hover
			instance.get_node("Button").texture_focused = focus
			instance.get_node("Button").texture_disabled = disabeld
			%VBoxContainer.add_child(instance)
			time += PI / 4
			field_id += 1
		unit_id += 1
	
	var spacer = HSeparator.new()
	spacer.add_theme_constant_override("separation",160)
	%VBoxContainer.add_child(spacer)
	%VBoxContainer.get_children()[-1].add_theme_stylebox_override("seperator",StyleBoxEmpty.new())

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

func add_button():
	var instance = H_ALIGNMENT.instantiate()
	instance.time = time
	instance.connect("open_learn",opened_learn)
	%VBoxContainer.add_child(instance)
	time += PI / 8

func opened_learn():
	Vars.current_scroll = $ScrollContainer.scroll_vertical
	Vars.save_saves("Openend Lean interface")

func _ready() -> void:
	set_bg_pos()
	add_unit_fields(get_unit_fields())
	$Lines._draw()
	await get_tree().process_frame
	$ScrollContainer.scroll_vertical = Vars.current_scroll
	

func _process(delta: float) -> void:
	set_bg_pos()
	if OS.get_name() != "Android":
		set_bg_pos()
	else:
		$TextureRect.position.y = -$ScrollContainer.scroll_vertical

func _on_scroll_container_scroll_ended() -> void:
	Vars.current_scroll = $ScrollContainer.scroll_vertical
	
	if OS.get_name() != "Android":
		set_bg_pos()
	else:
		$TextureRect.position.y = -$ScrollContainer.scroll_vertical
