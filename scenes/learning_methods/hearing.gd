extends Control

var speak_speed: float = 1.0
var interval_time: float = 3.0
var to: String
var word: Word
var words_max: int
var words_done: int = 0
var last_uids: Array = []

var bread_position: int = 1 # UP | DOWN

func _ready() -> void:
	Vars.to_language_french = Vars.to_french
	words_max = len(WordHandler.get_words_in_unit(Vars.current_open_unit))
	%ScreenProgressBar.max_value = words_max
	
	if !Vars.field_progress.has(Vars.current_open_field_id):
		Vars.field_progress[Vars.current_open_field_id] = 0
		words_done = 0
	else:
		words_done = Vars.field_progress[Vars.current_open_field_id]
	
	%ScreenProgressBar.value = words_done
	
	load_next_word()
	#await get_tree().process_frame
	#if Vars.current_open_field_id == Vars.learning_progress:
		#View.open_tab("path")
		#Vars.learning_progress += 1
		#Vars.current_learn_progress_next = false
		#Vars.save_saves()
	#else:
		#View.open_tab("path")

func load_next_word():
	Vars.locked_language_french = Vars.to_language_french
	if Vars.learn_all == false:
		word = WordHandler.select_next_word_in_unit(Vars.current_open_unit,last_uids)
	else:
		word = WordHandler.select_next_word_from_words(Vars.all_learn_words,last_uids)
	
	last_uids.append(word.uid)
	if last_uids.size() > 3:
		last_uids.pop_front()
	
	var from = WordHandler.get_words_string(word.german) if Vars.locked_language_french == true else WordHandler.get_words_string(word.french) 
	
	%TranslationContainer.pivot_offset = %TranslationContainer.size / 2
	%WordContainer.pivot_offset = %WordContainer.size / 2
	
	var anim_tween = get_tree().create_tween()
	anim_tween.set_trans(Tween.TRANS_CIRC)
	anim_tween.tween_property(%TranslationContainer,"scale",Vector2(0,1),0.2)
	anim_tween.tween_property(%WordContainer,"scale",Vector2(0,1),0.2)
	
	await get_tree().create_timer(0.2).timeout
	
	$%Translation.hide()
	await get_tree().create_timer(0.2).timeout
	%VocabOriginal.text = from
	%VocabDescription.text = word.description
	
	var back_tween = get_tree().create_tween()
	back_tween.set_trans(Tween.TRANS_CIRC)
	back_tween.tween_property(%TranslationContainer,"scale",Vector2(1,1),0.2)
	back_tween.tween_property(%WordContainer,"scale",Vector2(1,1),0.2)
	
	
	to = WordHandler.get_words_string(word.french) if Vars.locked_language_french == true else WordHandler.get_words_string(word.german)
	
	%Translation.text = to
	if bread_position == 1:
		bread_position = 0
		%AnimationPlayer.play_backwards("down")
	%BreadRender.speek_text(from,"de",0.1,speak_speed,true)
	if word.description.length() >= 1:
		%VocabDescription.show()
		SpeakHandler.tts_speak(from,75,1.0,speak_speed,"de" if Vars.locked_language_french == true else "fr")
		%BreadRender.speek_text(word.description,"de",0.1,speak_speed,true)
		SpeakHandler.tts_speak(word.description,50,1.0,1.0,"de",1)
	else:
		%VocabDescription.hide()
		SpeakHandler.tts_speak(from,75,1.0,speak_speed,"de" if Vars.locked_language_french == true else "fr",1)
	
	SpeakHandler.set_callback(DisplayServer.TTSUtteranceEvent.TTS_UTTERANCE_ENDED,call_funtion_tts)
	
	if word in Vars.marked_words:
		%MarkedButton.show()
		%MarkButton.hide()
	else:
		%MarkedButton.hide()
		%MarkButton.show()

func call_funtion_tts(id: int):
	if id == 1:
		wait_and_speak()
	if id == 2:
		word.trys += 2
		word.trys_correct += 2
		word.learn_score += 5 * (word.trys_correct / word.trys)
		%PointCounter.get_points([5,2],[1,2],get_window().size / 2, get_window().size.x / 3)
		words_done += 1
		update_score_bar()
		load_next_word()

func update_score_bar():
	if %ScreenProgressBar.value != %ScreenProgressBar.max_value and %ScreenProgressBar.max_value > 0:
		%ScreenProgressBar.value = words_done

func wait_and_speak():
	await get_tree().create_timer(interval_time).timeout
	%TranslationContainer.pivot_offset = %TranslationContainer.size / 2
	var anim_tween = get_tree().create_tween()
	anim_tween.set_trans(Tween.TRANS_CIRC)
	anim_tween.tween_property(%TranslationContainer,"scale",Vector2(0,1),0.2)
	await get_tree().create_timer(0.2).timeout
	$%Translation.show()
	var back_tween = get_tree().create_tween()
	back_tween.set_trans(Tween.TRANS_CIRC)
	back_tween.tween_property(%TranslationContainer,"scale",Vector2(1,1),0.2)
	%BreadRender.speek_text(to,"de",0.1,speak_speed,true)
	if bread_position == 0:
		bread_position = 1
		%AnimationPlayer.play("down")
	SpeakHandler.tts_speak(to,75,1.0,speak_speed,"fr" if Vars.locked_language_french == true else "de",2)
	SpeakHandler.set_callback(DisplayServer.TTSUtteranceEvent.TTS_UTTERANCE_ENDED,call_funtion_tts)


func _on_interval_timer_slider_value_changed(value: float) -> void:
	interval_time = value
	%IntervalTimeLabel.text = str(interval_time) + "s"


func _on_speak_speed_slider_value_changed(value: float) -> void:
	speak_speed = value
	%SpeakSpeedLabel.text = str(speak_speed) + "x"


func _on_back_button_pressed() -> void:
	if Vars.learn_all == false:
		if Vars.current_learn_progress_next == true:
			View.open_tab("path")
			Vars.done_field_ids.append(Vars.current_open_field_id)
			Vars.current_learn_progress_next = false
			Vars.save_saves("back save")
		else:
			View.open_tab("path")
	else:
		View.open_tab("learn_all")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("back"):
		_on_back_button_pressed()

func _on_mark_button_pressed() -> void:
	Vars.marked_words.append(word)
	Vars.save_saves("marked save")
	%MarkedButton.show()
	%MarkButton.hide()

func _on_marked_button_pressed() -> void:
	Vars.marked_words.erase(word)
	Vars.save_saves("marked 2 save")
	%MarkedButton.hide()
	%MarkButton.show()


func _on_flip_button_pressed() -> void:
	%Flip.flip_language()
