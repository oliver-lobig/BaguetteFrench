extends Control


func _on_text_button_pressed() -> void:
	animate_transition()
	await get_tree().create_timer(0.4).timeout
	IntroHandler.change_to.emit("language")

func animate_transition():
	var anim_tween = get_tree().create_tween()
	anim_tween.set_trans(Tween.TRANS_CIRC)
	anim_tween.set_ease(Tween.EASE_IN)
	anim_tween.tween_property(%Content,"position",Vector2(-%Content.size.x, 0.0),.3)
