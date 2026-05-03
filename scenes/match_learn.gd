extends Control

signal hide_move_card

const VOCAB_MATCH_CARD = preload("res://scenes/learning_methods/matching/vocab_match_card.tscn")

var in_card_move: bool = false
var mouse_card_offset: Vector2 = Vector2.ZERO
var moving_word: Word
var cards_open : int = 5
var card_start_pos: Vector2 = Vector2.ZERO
var moving_card_id : int = 0
var words_left: int = 50
var max_words: int = 50

func _ready() -> void:
	Vars.to_language_french = Vars.to_french
	%ScreenProgressBar.max_value = words_left
	
	if !Vars.field_progress.has(Vars.current_open_field_id):
		Vars.field_progress[Vars.current_open_field_id] = 0
		max_words = len(WordHandler.get_words_in_unit(Vars.current_open_unit)) * 3
		words_left = max_words
	else:
		words_left = max_words - Vars.field_progress[Vars.current_open_field_id]
	
	%ScreenProgressBar.value = max_words - words_left
	
	next_cards()
	hide_move_card.connect(hide_card)

func baguette_break():
	%AnimationPlayer.play(["jump","rotate"].pick_random())
	var german = ["Toll!","Super!","Weiter so!","Cool!","Noch mal!"]
	var french = ["Super bien!","Bien!","Allez!","Super!","Encore un fois!"]
	var random = randi_range(0,1)
	var saying = ""
	var language = ""
	if random == 0:
		language = "de"
		saying = german.pick_random()
	elif random == 1:
		language = "fr"
		saying = french.pick_random()
	await get_tree().create_timer(0.3).timeout
	%BreadRender.speek_text(saying,language)
	await get_tree().create_timer(2.0).timeout
	next_cards()

func delete_moving():
	%FromWord.get_child(moving_card_id).remove_card()

func hide_card():
	%MoveCard.hide()

func close_card():
	words_left -= 1
	
	$MarginContainer/VBoxContainer/ScreenProgressBar.value = max_words - words_left
	cards_open -= 1
	if cards_open == 0:
		%PointCounter.get_points([2,4,3,3,2,1],[4,5,7,11,18,21],get_window().size / 2,get_window().size.x/3)
		baguette_break()

func next_cards() -> void:
	Vars.locked_language_french = Vars.to_language_french
	for child in %FromWord.get_children():
		child.queue_free()
	for child in %ToWord.get_children():
		child.queue_free()
	
	cards_open = 5
	var from_words = []
	var to_words = []
	var words = WordHandler.select_next_words_in_unit(Vars.current_open_unit,5,Vars.learn_all)
	if Vars.learn_all == true:
		words = WordHandler.select_next_words_in_unit(Vars.current_open_unit,5,false,Vars.all_learn_words)
	from_words.append_array(words)
	to_words.append_array(words)
	
	randomize()
	
	from_words.shuffle()
	to_words.shuffle()
	
	var card_id: int = 0
	
	for word in from_words:
		if word is Word:
			var instance = VOCAB_MATCH_CARD.instantiate()
			instance.word = word
			instance.match_scene = self
			instance.card_id = card_id
			instance.to = false
			instance.moved.connect(move_card)
			%FromWord.add_child(instance)
			card_id += 1
	
	card_id = 0
	
	for word in to_words:
		if word is Word:
			var instance = VOCAB_MATCH_CARD.instantiate()
			instance.word = word
			instance.match_scene = self
			instance.to = true
			instance.card_id = card_id
			instance.close.connect(close_card)
			instance.moved.connect(move_card)
			%ToWord.add_child(instance)
			card_id += 1

func move_card(word: Word,card_id: int,mouse_offset: Vector2,start_pos: Vector2):
	mouse_card_offset = mouse_offset
	card_start_pos = start_pos
	moving_card_id = card_id
	moving_word = word
	%MoveCard.word = word
	%MoveCard.to = false
	%MoveCard.init_vars()
	var from_card = %FromWord.get_child(card_id)
	%MoveCard.size = from_card.size
	%MoveCard.global_position = from_card.global_position
	%MoveCard.show()
	in_card_move = true

func _input(event: InputEvent) -> void:
	if event.is_action_released("click"):
		if in_card_move:
			var snap_back_tween = get_tree().create_tween()
			snap_back_tween.set_trans(Tween.TRANS_CIRC)
			snap_back_tween.tween_property(%MoveCard,"global_position",card_start_pos,0.2)
			await get_tree().create_timer(0.2).timeout
			for card in %FromWord.get_children():
				card.show_card()
			%MoveCard.hide()
			in_card_move = false
	elif event is InputEventMouseMotion:
		%MoveCard.global_position = event.global_position - mouse_card_offset#
	if event.is_action_pressed("back"):
		_on_back_button_pressed()

func _exit_tree() -> void:
	Vars.save_saves("Exiting Tree")

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


func _on_flip_button_pressed() -> void:
	%Flip.flip_language()
