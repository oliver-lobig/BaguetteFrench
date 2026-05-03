extends Control

func flip_language():
	Vars.to_language_french = !Vars.to_language_french
	%To.text = "-> " + tr("SETTINGS_LANGUAGE_FRENCH") if Vars.to_language_french == true else "-> " + tr("SETTINGS_LANGUAGE_GERMAN")
	var anim_tween = get_tree().create_tween()
	%To.show()
	$Icon.show()
	$Circle.position = get_global_mouse_position() + Vector2(-64,-64)
	anim_tween.set_trans(Tween.TRANS_SINE)
	anim_tween.tween_property(%To,"self_modulate",Color.WHITE,.4)
	anim_tween.tween_property($Icon,"scale",Vector2(-1.5,1.5),.3)
	anim_tween.tween_property($Icon,"scale",Vector2(2,2),.4)
	anim_tween.tween_property($Icon,"scale",Vector2(-2.5,2.5),.5)
	anim_tween.tween_property($Icon,"scale",Vector2(0,3),.3)
	var circ_tween = get_tree().create_tween()
	circ_tween.set_trans(Tween.TRANS_QUAD)
	$Circle.scale = Vector2.ONE
	$Circle.modulate = Color(0.027, 0.737, 0.878, 0.188)
	$Circle.show()
	circ_tween.tween_property($Circle,"scale",Vector2(60,60),1.5)
	await get_tree().create_timer(1.9).timeout
	var transparent_tween = get_tree().create_tween()
	transparent_tween.set_trans(Tween.TRANS_QUAD)
	transparent_tween.tween_property($Circle,"modulate",Color.TRANSPARENT,.5)
	transparent_tween.tween_property(%To,"self_modulate",Color.TRANSPARENT,.4)
	$Icon.hide()
	await get_tree().create_timer(.9).timeout
	%To.hide()
	$Circle.hide()
