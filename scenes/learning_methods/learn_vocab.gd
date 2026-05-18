extends Control
var words: Array = []
var word: Word
var current_id: int = 0

var bread_pos: int = 0 # Up | Down

func _ready() -> void:
	Vars.to_language_french = Vars.to_french
	if Vars.current_open_unit > Vars.max_unit:
		Vars.max_unit = Vars.current_open_unit
		Vars.save_saves("Save new max unit")

	var screen_width = get_window().get_size_with_decorations().x
	
	if Vars.learn_all == false:
		words = WordHandler.get_words_in_unit(Vars.current_open_unit)
	else:
		words = Vars.all_learn_words
	
	$SwipeCheckerLeft.length = screen_width/1.0
	$SwipeCheckerRight.length = screen_width/1.0
	
	%ScreenProgressBar.max_value = len(words)
	
	if !Vars.field_progress.has(Vars.current_open_field_id):
		Vars.field_progress[Vars.current_open_field_id] = 0
		load_word(0)
	else:
		current_id = Vars.field_progress[Vars.current_open_field_id]
		load_word(Vars.field_progress[Vars.current_open_field_id])

func load_word(word_relative_id: int):
	Vars.locked_language_french = Vars.to_language_french
	%ScreenProgressBar.value = word_relative_id + 1
	word = words[clamp(word_relative_id,0,words.size() - 1)]
	%Flip.show()
	%VocabOriginal.text = WordHandler.get_words_string(word.french) if Vars.locked_language_french == false else WordHandler.get_words_string(word.german)

	if word.description != "":
		%VocabDescription.show()
		%VocabDescription.text = word.description
	else:
		%VocabDescription.hide()
	%Translation.hide()
	if word in Vars.marked_words:
		%MarkedButton.show()
		%MarkButton.hide()
	else:
		%MarkedButton.hide()
		%MarkButton.show()
	if bread_pos == 0:
		%AnimationPlayer.play_backwards("down")
		bread_pos = 1
	await get_tree().create_timer(0.3).timeout
	%BreadRender.speek_text(%VocabOriginal.text,"fr" if Vars.locked_language_french != true else "de")

func show_word():
	%TranslationContainer.pivot_offset = %TranslationContainer.size / 2
	var anim_tween = get_tree().create_tween()
	anim_tween.set_trans(Tween.TRANS_CIRC)
	anim_tween.tween_property(%TranslationContainer,"scale",Vector2(0,1),0.3)
	await get_tree().create_timer(0.3).timeout
	anim_tween.stop()
	%Flip.hide()
	%Translation.show()
	%Translation.text = WordHandler.get_words_string(word.french) if Vars.locked_language_french == true else WordHandler.get_words_string(word.german)
	var flip_bhack = get_tree().create_tween()
	flip_bhack.set_trans(Tween.TRANS_CIRC)
	flip_bhack.tween_property(%TranslationContainer,"scale",Vector2(1,1),0.5)
	if bread_pos == 1:
		bread_pos = 0
		%AnimationPlayer.play("down")
	await get_tree().create_timer(0.3).timeout
	%BreadRender.speek_text(%Translation.text,"fr" if Vars.locked_language_french == true else "de")


func _on_flip_button_pressed() -> void:
	show_word()


func _on_swipe_checker_right_swipe_step(interpolation: float) -> void:
	interpolate_swipe(Vector2.RIGHT,interpolation)

func interpolate_swipe(direction: Vector2,interpolation: float):
	var screen_width = get_window().get_size_with_decorations().x
	var width = screen_width + %SwipeContainer.size.x / 2 + 50
	%SwipeContainer.position = interpolation * direction * width

func _on_swipe_checker_right_swipe_stopped() -> void:
	stop_swipe()

func _on_swipe_checker_right_swiped() -> void:
	current_id -= 1
	if current_id <= -1:
		current_id = 0
		var undo = get_tree().create_tween()
		undo.set_trans(Tween.TRANS_CIRC)
		undo.tween_property(%SwipeContainer,"position",Vector2.ZERO,0.3)
	else:
		var screen_width = get_window().get_size_with_decorations().x
		var width = screen_width + %SwipeContainer.size.x / 2 + 50
		%SwipeContainer.position.x = -width
		var back_tween = get_tree().create_tween()
		back_tween.set_trans(Tween.TRANS_CIRC)
		back_tween.tween_property(%SwipeContainer,"position",Vector2.ZERO,0.3)
		load_word(current_id)


func _on_swipe_checker_left_swipe_step(interpolation: float) -> void:
	interpolate_swipe(Vector2.LEFT,interpolation)


func _on_swipe_checker_left_swipe_stopped() -> void:
	stop_swipe()

func stop_swipe():
	var back_tween = get_tree().create_tween()
	back_tween.set_trans(Tween.TRANS_CIRC)
	back_tween.tween_property(%SwipeContainer,"position",Vector2.ZERO,0.3)

func _on_swipe_checker_left_swiped() -> void:
	current_id += 1
	if current_id >= len(words):
		current_id = (len(words) - 1)
		var undo = get_tree().create_tween()
		undo.set_trans(Tween.TRANS_CIRC)
		undo.tween_property(%SwipeContainer,"position",Vector2.ZERO,0.3)
	else:
		var screen_width = get_window().get_size_with_decorations().x
		var width = screen_width + %SwipeContainer.size.x / 2 + 50
		%SwipeContainer.position.x = width
		var back_tween = get_tree().create_tween()
		back_tween.set_trans(Tween.TRANS_CIRC)
		back_tween.tween_property(%SwipeContainer,"position",Vector2.ZERO,0.3)
		load_word(current_id)

func _on_mark_button_pressed() -> void:
	Vars.marked_words.append(word)
	Vars.save_saves("save word marked")
	%MarkedButton.show()
	%MarkButton.hide()

func _on_marked_button_pressed() -> void:
	Vars.marked_words.erase(word)
	Vars.save_saves("save word marked")
	%MarkedButton.hide()
	%MarkButton.show()


func _on_back_button_pressed() -> void:
	%ScreenProgressBar._on_button_pressed()
	if Vars.learn_all == false:
		if Vars.current_learn_progress_next == true:
			Vars.done_field_ids.append(Vars.current_open_field_id)
			Vars.current_learn_progress_next = false
			Vars.save_saves("save on go back")
		View.open_tab("path")
	else:
		View.open_tab("learn_all")

func _on_dictionary_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/learning_methods/word_dictionary/word_dictionary.tscn")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("back"):
		_on_back_button_pressed()


func _on_flip_button_setting_pressed() -> void:
	%FlipButtonSetting.flip_language()
