extends Control


func _ready() -> void:
	%Content.size = %ContentAnchor.size
	%Content.position.x = %ContentAnchor.size.x
	%Content.position.y = 0
	animate_transition_in()


func _process(delta: float) -> void:
	if %Content.size != %ContentAnchor.size:
		%Content.size = %ContentAnchor.size

func animate_transition_in():
	var anim_tween = get_tree().create_tween()
	anim_tween.set_trans(Tween.TRANS_CIRC)
	anim_tween.set_ease(Tween.EASE_OUT)
	anim_tween.tween_property(%Content,"position",Vector2(0.0,0.0),.5)


func _on_use_tutorial_pressed() -> void:
	Vars.skip_tutorial = false
	Vars.save_saves("Dont skip tutorial")
	%UseTutorial.disabled = true
	%SkipTutorial.disabled = false
	%DoneButton.disabled = false

func _on_skip_tutorial_pressed() -> void:
	Vars.skip_tutorial = true
	Vars.save_saves("Skip tutorial")
	%UseTutorial.disabled = false
	%SkipTutorial.disabled = true
	%DoneButton.disabled = false


func _on_done_button_pressed() -> void:
	Vars.finished_intro = true
	Vars.save_saves()
	get_tree().change_scene_to_file("res://scenes/tabs.tscn")
