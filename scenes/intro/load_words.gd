extends Control

const CHECK_LARGE = preload("uid://b0bcc1brm81cj")


var state: int = 0
var loop_anim_tween: Tween

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


func _on_text_button_pressed() -> void:
	if state == 0:
		state = 1
		loop_anim_tween = get_tree().create_tween()
		loop_anim_tween.set_loops()
		loop_anim_tween.set_trans(Tween.TRANS_CIRC)
		loop_anim_tween.set_ease(Tween.EASE_IN_OUT)
		loop_anim_tween.tween_property(%DownloadIcon,"custom_minimum_size",Vector2(0,128+32),1.0)
		loop_anim_tween.tween_property(%DownloadIcon,"custom_minimum_size",Vector2(0,128),1.0)
		%ActionButton.text = "LOADING"
		%ActionButton.disabled = true
		Vars.downloaded_new_words.connect(finished_download)
		Vars.update_word_data()
	if state == 2:
		animate_transition()
		await get_tree().create_timer(0.4).timeout
		IntroHandler.change_to.emit("info")

func animate_transition():
	var anim_tween = get_tree().create_tween()
	anim_tween.set_trans(Tween.TRANS_CIRC)
	anim_tween.set_ease(Tween.EASE_IN)
	anim_tween.tween_property(%Content,"position",Vector2(-%Content.size.x, 0.0),.3)


func finished_download():
	await get_tree().create_timer(1.0).timeout #So you can see the beautiful download animation.
	loop_anim_tween.kill()
	state = 2
	var anim_tween = get_tree().create_tween()
	anim_tween.set_trans(Tween.TRANS_CIRC)
	anim_tween.set_ease(Tween.EASE_IN_OUT)
	anim_tween.tween_property(%DownloadIcon,"custom_minimum_size",Vector2(0,128),1.0)
	%ActionButton.text = "NEXT_BUTTON"
	%DownloadIcon.texture = CHECK_LARGE
	%ActionButton.disabled = false
