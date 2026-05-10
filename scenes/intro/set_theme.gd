extends Control

func _ready() -> void:
	%Content.size = %ContentAnchor.size
	%Content.position.x = %ContentAnchor.size.x
	%Content.position.y = 0
	animate_transition_in()


func animate_transition_in():
	var anim_tween = get_tree().create_tween()
	anim_tween.set_trans(Tween.TRANS_CIRC)
	anim_tween.set_ease(Tween.EASE_OUT)
	anim_tween.tween_property(%Content,"position",Vector2(0.0,0.0),.5)

func _process(delta: float) -> void:
	if %Content.size != %ContentAnchor.size:
		%Content.size = %ContentAnchor.size

func _on_button_pressed() -> void:
	%LightMode.disabled = true
	%DarkMode.disabled = false
	
	var theme_path: String = "res://assets/extra_themes/spring_theme.tres"
	Vars.settings_data.current_theme_path = theme_path
	Vars.save_saves("Theme selected")
	IntroHandler.update_theme.emit()


func _on_dark_mode_pressed() -> void:
	%LightMode.disabled = false
	%DarkMode.disabled = true
	
	var theme_path: String = "res://assets/learn_scene_theme.tres"
	Vars.settings_data.current_theme_path = theme_path
	Vars.save_saves("Theme selected")
	IntroHandler.update_theme.emit()


func _on_next_button_pressed() -> void:
	animate_transition()
	await get_tree().create_timer(0.4).timeout
	IntroHandler.change_to.emit("download")

func animate_transition():
	var anim_tween = get_tree().create_tween()
	anim_tween.set_trans(Tween.TRANS_CIRC)
	anim_tween.set_ease(Tween.EASE_IN)
	anim_tween.tween_property(%Content,"position",Vector2(-%Content.size.x, 0.0),.3)
