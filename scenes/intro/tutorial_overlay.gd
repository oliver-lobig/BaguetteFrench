@tool
extends Control

var info_count: int = 0
var tutorial_queue: Array = []

@export var tutorial_scene_name = ""

var current_slide_id: int = 0
var waiting: bool = false

func _ready() -> void:
	if Engine.is_editor_hint():
		hide()
	else:
		show()
		if Vars.skip_tutorial or Vars.finished_tutorial_scenes.has(tutorial_scene_name):
			queue_free()
			return
		if Vars.in_tutorial_screen:
			hide()
			waiting = true
			return
		setup_tutorial()

func _process(delta: float) -> void:
	if !Engine.is_editor_hint():
		if waiting:
			if !Vars.in_tutorial_screen:
				waiting = false
				setup_tutorial()

func setup_tutorial():
	show()
	Vars.in_tutorial_screen = true
	for child in %Slides.get_children():
		child.hide()
		info_count += 1
	for i in range(info_count):
		var slide_node = get_node("Slides/Slide"+str(i + 1))
		if slide_node == null:
			printerr("Wrong tutorial overlay setup! Please name slides with 'Slide1', ...")
			return
		tutorial_queue.append(slide_node)
	%SetupProgress.max_value = info_count

	if info_count == 1:
		%NextButton.text = "DONE_BUTTON"
	elif info_count == 0:
		Vars.in_tutorial_screen = false
		queue_free()
		
		
		return
	
	tutorial_queue.get(current_slide_id).show()
	%SetupProgress.new_value = current_slide_id
	%SetupProgress.load_value()

func _on_next_button_pressed() -> void:

	current_slide_id += 1
	
	%SetupProgress.new_value = current_slide_id + 1
	%SetupProgress.load_value()
	
	if info_count - current_slide_id == 1:
		%NextButton.text = "DONE_BUTTON"
	elif info_count - current_slide_id == 0:
		Vars.in_tutorial_screen = false
		Vars.finished_tutorial_scenes.append(tutorial_scene_name)
		Vars.save_saves("tutorial finished")
		queue_free()
		return
	
	for child in %Slides.get_children():
		child.hide()
	
	tutorial_queue.get(current_slide_id).show()
