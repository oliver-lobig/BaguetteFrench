extends Control

signal moved(word: Word, id: int, mouse_offset: Vector2,card_pos: Vector2)
signal close

var word: Word
var to: bool = false
var card_id: int = 0
var match_scene: Control

var card_open: bool = true

var in_focus: bool = false

func _ready() -> void:
	init_vars()
	spawn()

func init_vars():
	if word:
		if to == false:
			%VocabOriginal.text = WordHandler.get_words_string(word.french) if Vars.locked_language_french == false else WordHandler.get_words_string(word.german)
			%WordContainer.show()
			%MatchTo.hide()
		elif to == true:
			%VocabOriginalTo.text = WordHandler.get_words_string(word.french) if Vars.locked_language_french == true else WordHandler.get_words_string(word.german)
			if word.description:
				%VocabDescriptionTo.text = word.description
				%VocabDescriptionTo.show()
			else:
				%VocabDescriptionTo.hide()
			%WordContainer.hide()
			%MatchTo.show()

func spawn():
	
	if to == false:
		await get_tree().process_frame
		%WordContainer.pivot_offset.x = size.x / 2
		%MarginContainerWord.hide()
		await get_tree().create_timer(0.2*card_id).timeout
		var anim_tween = get_tree().create_tween()
		anim_tween.set_trans(Tween.TRANS_CIRC)
		anim_tween.tween_property(%WordContainer,"scale",Vector2(0,1),0.3)
		await get_tree().create_timer(0.4).timeout
		anim_tween.stop()
		
		var anim_tween_back = get_tree().create_tween()
		anim_tween_back.set_trans(Tween.TRANS_CIRC)
		%MarginContainerWord.show()
		anim_tween_back.tween_property(%WordContainer,"scale",Vector2(1,1),0.3)
		
	else:
		await get_tree().process_frame
		%MatchTo.pivot_offset.x = size.x / 2
		%MarginContainerTo.hide()
		await get_tree().create_timer(0.2*card_id).timeout
		var anim_tween = get_tree().create_tween()
		anim_tween.set_trans(Tween.TRANS_CIRC)
		anim_tween.tween_property(%MatchTo,"scale",Vector2(0,1),0.3)
		await get_tree().create_timer(0.3).timeout
		anim_tween.stop()
		
		var anim_tween_back = get_tree().create_tween()
		anim_tween_back.set_trans(Tween.TRANS_CIRC)
		
		%MarginContainerTo.show()
		
		anim_tween_back.tween_property(%MatchTo,"scale",Vector2(1,1),0.3)
	

func _on_button_button_down() -> void:
	if card_open == true:
		if to == false:
			%WordContainer.hide()
			var offset = get_global_mouse_position() - global_position
			moved.emit(word, card_id, offset, global_position)

func show_card():
	no_hover()
	if card_open == true:
		%WordContainer.show()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if event.global_position.x < global_position.x:
			exit_focus()
		elif event.global_position.x > global_position.x + size.x:
			exit_focus()
		elif event.global_position.y < global_position.y:
			exit_focus()
		elif event.global_position.y > global_position.y + size.y:
			exit_focus()
		else:
			if in_focus == false:
				enter_focus()
			in_focus = true
	
	if event.is_action_released("click"):
		if word and match_scene and match_scene.moving_word and card_open and in_focus:
			no_hover()
			if to:
				if WordHandler.is_correct_match(match_scene.moving_word,word):
					correct_match(word,match_scene.moving_word)
				else:
					word.trys += 1
					match_scene.moving_word.trys += 1

func correct_match(word: Word, with: Word):
	card_open = false
	close.emit()
	match_scene.hide_move_card.emit()
	match_scene.delete_moving()
	var anim_tween = get_tree().create_tween()
	anim_tween.set_trans(Tween.TRANS_CIRC)
	anim_tween.tween_property(%MatchTo,"scale",Vector2(0,1),0.5)
	await get_tree().create_timer(0.5).timeout
	%MatchTo.hide()
	
	word.trys += 1
	word.trys_correct += 1
	
	with.trys += 1
	with.trys_correct += 1
	
	word.learn_score += 2 + (word.trys_correct / word.trys)
	with.learn_score += 2 + (with.trys_correct / with.trys)

func remove_card():
	card_open = false
	%WordContainer.hide()
	no_hover()

func exit_focus():
	if in_focus == true:
		in_focus = false
		no_hover()

func enter_focus():
	if match_scene:
		if match_scene.in_card_move:
			if card_open == true:
				%Selected.show()

func no_hover():
	%Selected.hide()
