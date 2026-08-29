extends Control

const REPEAT = preload("uid://c1kdw02vmkire")
const REPEAT_ON = preload("uid://8t21bfl4ehxn")

const SHUFFLE = preload("uid://b38i2lg70da2x")
const SHUFFLE_ON = preload("uid://d0kyt80p7wqy8")


var words: Array = []
var word: Word
var current_id: int = 0

var word_history = []
var history_id: int = 0

var bread_pos: int = 0 # Up | Down

var infinirepeat_on: bool = false
var shuffle_mode: bool = false

func _ready() -> void:
	Vars.to_language_french = Vars.to_french
	if Vars.current_open_unit > Vars.max_unit:
		Vars.max_unit = Vars.current_open_unit
		Vars.save_saves("Save new max unit")

	var screen_width = get_window().get_size_with_decorations().x
	
	if Vars.learn_all == false:
		%Shuffle.hide()
		%Correct.hide()
		%Wrong.hide()
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

func load_word(word_relative_id: int, back = false):
	Vars.locked_language_french = Vars.to_language_french
	%ScreenProgressBar.value = word_relative_id + 1
	
	if shuffle_mode == false:
		word = words[clamp(word_relative_id,0,words.size() - 1)]
	else:
		if back == true:
			if history_id > 0:
				history_id -= 1
				word = word_history[history_id]
		else:
			word_history.append(word)
			word = WordHandler.select_next_word_from_words(Vars.all_learn_words)
	
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
	SpeakHandler.set_callback(DisplayServer.TTSUtteranceEvent.TTS_UTTERANCE_ENDED, say_word_again)

func say_word_again(air):
	await get_tree().create_timer(2.5).timeout
	if infinirepeat_on:
		if %Translation.visible == false:
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

func _on_swipe_checker_right_swiped(switch_side = false) -> void:
	current_id -= 1
	if current_id <= -1:
		current_id = 0
		var undo = get_tree().create_tween()
		undo.set_trans(Tween.TRANS_CIRC)
		undo.tween_property(%SwipeContainer,"position",Vector2.ZERO,0.3)
	else:
		var screen_width = get_window().get_size_with_decorations().x
		var width = screen_width + %SwipeContainer.size.x / 2 + 50
		%SwipeContainer.position.x = -width if switch_side == false else width
		var back_tween = get_tree().create_tween()
		back_tween.set_trans(Tween.TRANS_CIRC)
		back_tween.tween_property(%SwipeContainer,"position",Vector2.ZERO,0.3)
		load_word(current_id, shuffle_mode)


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
	if current_id >= len(words) and shuffle_mode == false:
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


func _on_button_pressed() -> void:
	infinirepeat_on = !infinirepeat_on
	if infinirepeat_on:
		%InfiniRepeat.texture_normal = REPEAT_ON
	else:
		%InfiniRepeat.texture_normal = REPEAT


func _on_shuffle_pressed() -> void:
	shuffle_mode = !shuffle_mode
	if shuffle_mode:
		load_word(current_id)
		%Shuffle.texture_normal = SHUFFLE_ON
	else:
		current_id = 0
		load_word(current_id)
		%Shuffle.texture_normal = SHUFFLE


func _on_correct_pressed() -> void:
	_on_swipe_checker_right_swiped(true)
	word.trys += 1
	word.trys_correct += 1 if Vars.word_selection_type != "review" else 3
	var word_skill_level: float = word.trys_correct / word.trys
	word.learn_score += 5 + (10 * word_skill_level)


func _on_wrong_pressed() -> void:
	_on_swipe_checker_right_swiped(true)
	word.trys += 1
	
