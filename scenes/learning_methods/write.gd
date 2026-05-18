extends Control

var word: Word
var flip_tween: Tween
var score_tween: Tween

var is_correct: bool

var word_shown: bool = false

var words_correct: int = 0
var words_need: int = 0

var baguette_pos: int = 0 # UP | DOWN

#Extra for VERBS
var from_verb: Verb = null
var selected_suffix_id: int = 0

func _ready() -> void:
	if Vars.word_selection_type == "single":
		%PointCounter.challenge_type = 2
	elif Vars.word_selection_type == "sentence":
		%PointCounter.challenge_type = 1
	elif Vars.word_selection_type == "verbs":
		%PointCounter.challenge_type = 6
	elif Vars.word_selection_type == "review":
		%PointCounter.challenge_type = 5
	%PointCounter.reload_quest_type()
	Vars.to_language_french = Vars.to_french
	%VocabDescription.text = ""
	%VocabOriginal.text = ""
	%Translation.text = ""
	
	words_need = len(WordHandler.get_words_in_unit(Vars.current_open_unit)) if Vars.word_selection_type != "sentence" else len(WordHandler.get_words_with_type_in_unit(Vars.current_open_unit,Definitions.SentenceTypes.COMPLETE))
	%ScreenProgressBar.max_value = words_need
	
	if !Vars.field_progress.has(Vars.current_open_field_id):
		Vars.field_progress[Vars.current_open_field_id] = 0
		words_correct = 0
	else:
		words_correct = Vars.field_progress[Vars.current_open_field_id]
		
	%ScreenProgressBar.value = words_correct
	
	next()
	get_tree().root.connect("go_back_requested",go_back)


func go_back():
	if Vars.learn_all == false:
		View.open_tab("path")
	else:
		View.open_tab("learn_all")

func check():
	
	%Translation.hide()
	%AnimationPlayer.play_backwards("down")
	var container_size = %WordContainer.size
	var container_pos = %WordContainer.global_position
	
	var user_translation = %Translation.text
	if not word:
		return
	var real_translations = []
	if !is_verb_mode():
		real_translations = word.french if Vars.locked_language_french == true else word.german
	else:
		real_translations = [WordHandler.get_verb_full_text(word,from_verb,"french",selected_suffix_id)] if Vars.locked_language_french == true else [WordHandler.get_verb_full_text(word,from_verb,"german",selected_suffix_id)]
	is_correct = WordHandler.check_correct(user_translation,real_translations,"french" if Vars.locked_language_french else "german")
	if is_correct == false:
		if View.current_camera:
			View.current_camera.shake(40,15,.7)
		%TranslationShow.text = WordHandler.get_wrong_part(user_translation,real_translations,"french" if Vars.locked_language_french else "german")
	else:
		%TranslationShow.text = %Translation.text
	%TranslationShow.show()
	flip()
	await get_tree().create_timer(0.3).timeout
	$%VocabOriginal.text = WordHandler.get_words_string(real_translations)
	if baguette_pos == 1:
		baguette_pos = 0
		%AnimationPlayer.play_backwards("down")
		%BreadRender.speek_text(%VocabOriginal.text,"fr" if Vars.locked_language_french == true else "de")
	#SpeakHandler.tts_speak(%VocabOriginal.text,50,1.0,1.0,"fr" if Vars.to_french == true else "de")
	word_shown = true
	
	if is_correct == false:
		$%Translation.add_theme_color_override("font_readonly_color",Color(0.953, 0.357, 0.412, 1.0))
	else:
		$%Translation.add_theme_color_override("font_readonly_color",Color(0.224, 0.702, 0.455, 1.0))
		
		%PointCounter.get_points([5,7,3,1],[2,4,5,11],container_pos + (container_size / 2),container_size.y / 2)
	
	%ButtonA.text = BaguetteTranslationServer.translate("CORRECT_BUTTON") if is_correct == false else BaguetteTranslationServer.translate("WRONG_BUTTON")
	%ButtonB.text = BaguetteTranslationServer.translate("NEXT_BUTTON")
	
	await get_tree().create_timer(0.5).timeout
	
	word.trys += 1 
	
	if is_correct == true:
		if Vars.word_selection_type == "review":
			word.trys += 2
		
		
		
		word.trys_correct += 1 if Vars.word_selection_type != "review" else 3
		var word_skill_level: float = word.trys_correct / word.trys
		
		words_correct += 1
		word.learn_score += 5 + (10 * word_skill_level)
		update_score_bar()
	score_tween = get_tree().create_tween()
	score_tween.set_trans(Tween.TRANS_SPRING)
	score_tween.tween_property(%LearnState,"value",word.learn_score,0.5)

func flip():
	%WordContainer.pivot_offset = %WordContainer.size / 2
	flip_tween = get_tree().create_tween()
	flip_tween.set_trans(Tween.TRANS_CIRC)
	flip_tween.tween_property(%WordContainer,"scale",Vector2(0,1),0.3)
	flip_tween.tween_property(%WordContainer,"scale",Vector2(1,1),0.3)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("back"):
		_on_back_button_pressed()

func _exit_tree() -> void:
	Vars.save_saves("Save Words exit write tree")
	if flip_tween:
		flip_tween.kill()
	if score_tween:
		score_tween.kill()

func is_verb_mode():
	return from_verb != null

func next():
	Vars.locked_language_french = Vars.to_language_french
	%Translation.add_theme_color_override("font_color",Color(0.145, 0.149, 0.153))
	flip()
	word_shown = false
	
	await get_tree().create_timer(0.3).timeout
	
	%Translation.text = ""
	%TranslationShow.hide()
	%Translation.show()
	%ButtonA.text = BaguetteTranslationServer.translate("SHOW_BUTTON")
	%ButtonB.text = BaguetteTranslationServer.translate("DONE_BUTTON")
	
	if Vars.word_selection_type == "single":
		if Vars.learn_all == false:
			word = WordHandler.select_next_word_in_unit(Vars.current_open_unit)
		else:
			word = WordHandler.select_next_word_from_words(Vars.all_learn_words)
	elif Vars.word_selection_type == "sentence":
		var result = {}
		if Vars.learn_all == false:
			result = WordHandler.select_next_verb_with_category(Vars.current_open_unit)
		else:
			result = WordHandler.select_next_verb(Vars.all_learn_verbs)
		if result.selected_word == null or randi_range(0,10) > 6:
			from_verb = null
			selected_suffix_id = 0
			if Vars.learn_all == false:
				word = WordHandler.select_next_word_in_unit_with_type(Vars.current_open_unit,Definitions.SentenceTypes.COMPLETE)
			else:
				WordHandler.filter_type = Definitions.SentenceTypes.COMPLETE
				word = WordHandler.select_next_word_from_words(Vars.all_learn_words.filter(WordHandler.word_has_type))
		else:
			word = result.selected_word
			from_verb = result.selected_verb
			selected_suffix_id = randi_range(0,from_verb.suffix.german.size()-1)
	elif Vars.word_selection_type == "review":
		if Vars.learn_all == false:
			word = WordHandler.select_next_word_in_unit_for_review(Vars.current_open_unit)
		else:
			word = WordHandler.select_next_review_word_from_words(Vars.all_learn_words)
	elif Vars.word_selection_type == "verbs":
		# Need change for all learn
		var result = {}
		if Vars.learn_all == false:
			result = WordHandler.select_next_verb_with_category(Vars.current_open_unit)
		else:
			result = WordHandler.select_next_verb(Vars.all_learn_verbs)
		word = result.selected_word
		from_verb = result.selected_verb
		selected_suffix_id = randi_range(0,from_verb.suffix.german.size()-1)
		
	if Vars.locked_language_french:
		%VocabOriginal.text = WordHandler.get_words_string(word.german) if !is_verb_mode() else WordHandler.get_verb_full_text(word,from_verb,"german",selected_suffix_id)
	else:
		%VocabOriginal.text = WordHandler.get_words_string(word.french) if !is_verb_mode() else WordHandler.get_verb_full_text(word,from_verb,"french",selected_suffix_id)
	if word.description != "":
		%VocabDescription.text = word.description
		%VocabDescription.show()
	else:
		%VocabDescription.hide()
	
	if baguette_pos == 0:
		baguette_pos = 1
		%AnimationPlayer.play("down")
		%BreadRender.speek_text(%VocabOriginal.text,"fr" if Vars.locked_language_french != true else "de")
	#SpeakHandler.tts_speak(%VocabOriginal.text,50,1.0,1.0,"fr" if Vars.to_french != true else "de")
	
	score_tween = get_tree().create_tween()
	score_tween.tween_property(%LearnState,"value",word.learn_score,0.2)
	
	if word in Vars.marked_words:
		%MarkedButton.show()
		%MarkButton.hide()
	else:
		%MarkedButton.hide()
		%MarkButton.show()

func _on_done_pressed() -> void:
	if word_shown == false:
		check()
	else:
		next()


func _on_button_a_pressed() -> void:
	if word_shown == false:
		flip()
		await get_tree().create_timer(0.3).timeout
		var real_translations = []
		if !is_verb_mode():
			real_translations = word.french if Vars.locked_language_french == true else word.german
		else:
			real_translations = [WordHandler.get_verb_full_text(word,from_verb,"french",selected_suffix_id)] if Vars.locked_language_french == true else [WordHandler.get_verb_full_text(word,from_verb,"german",selected_suffix_id)]
		$%VocabOriginal.text = WordHandler.get_words_string(real_translations)
		word_shown = true
		is_correct = false
		%ButtonA.text = BaguetteTranslationServer.translate("CORRECT_BUTTON")
		%ButtonB.text = BaguetteTranslationServer.translate("NEXT_BUTTON")
	else:
		wrong_detection()

func wrong_detection():
	if is_correct == true:
		%PointCounter.revert()
		word.learn_score -= 10.0
	else:
		var word_skill_level: float = word.trys_correct / word.trys if word.trys != 0 else 1
		%PointCounter.get_points([5,7,3,1],[2,4,5,11],%WordContainer.global_position + (%WordContainer.size / 2),%WordContainer.size.y / 2)
		words_correct += 1
		word.trys_correct += 1 if Vars.word_selection_type != "review" else 3
		word.learn_score += 5 + (10 * word_skill_level)
		update_score_bar()
	next()

func update_score_bar():
	%ScreenProgressBar.value = words_correct

func _on_back_button_pressed() -> void:
	if Vars.learn_all == false:
		if Vars.current_learn_progress_next == true:
			View.open_tab("path")
			Vars.done_field_ids.append(Vars.current_open_field_id)
			Vars.current_learn_progress_next = false
		else:
			View.open_tab("path")
	else:
		View.open_tab("learn_all")

func _on_mark_button_pressed() -> void:
	Vars.marked_words.append(word)
	%MarkedButton.show()
	%MarkButton.hide()

func _on_marked_button_pressed() -> void:
	Vars.marked_words.erase(word)
	
	%MarkedButton.hide()
	%MarkButton.show()

func _process(delta: float) -> void: 
	if OS.get_name() == "Android" or OS.get_name() == "iOS":
		%SystemBarSpacer2.custom_minimum_size.y = max(((DisplayServer.virtual_keyboard_get_height() / 2)  - (%Translation.size.y - 128)),0)


func _on_flip_button_pressed() -> void:
	%Flip.flip_language()
