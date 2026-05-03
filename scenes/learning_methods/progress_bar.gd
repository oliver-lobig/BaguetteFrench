extends ProgressBar

@export var subtract_one: bool = true
@export var can_skip: bool = false

func _ready() -> void:
	if can_skip:
		%Skip.show()
	else:
		%Skip.hide()
	if !Vars.done_field_ids.has(Vars.current_open_field_id):
		show()
	else:
		hide()
	if Vars.learn_all:
		hide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("add_point"):
		if DevTools.ACTIVE == true:
			value += 1
	elif event.is_action_pressed("skip"):
		if DevTools.ACTIVE == true:
			can_skip = true
			%Skip.show()

func _on_value_changed(value: float) -> void:
	if !Vars.done_field_ids.has(Vars.current_open_field_id):
		Vars.field_progress[Vars.current_open_field_id] = value - 1 if subtract_one == true else value
		#Vars.save_saves("Progress bar changed value")
		
		if max_value > 0:
			if value == max_value:
				%Done.show()
				Vars.current_learn_progress_next = true
			else:
				%Done.hide()
				Vars.current_learn_progress_next = false
		else:
			%Done.hide()
			Vars.current_learn_progress_next = false


func _on_button_pressed() -> void:
	if !Vars.done_field_ids.has(Vars.current_open_field_id):
		if Vars.current_learn_progress_next == true:
			View.open_tab("path")
			Vars.done_field_ids.append(Vars.current_open_field_id)
			Vars.current_learn_progress_next = false
			Vars.save_saves("Progress bar pressed done")


func _on_skip_pressed() -> void:
	if can_skip:
		value = max_value
