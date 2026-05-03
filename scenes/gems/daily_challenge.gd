extends PanelContainer

@export var id: int = 0

var type_names = {
	0: "SENTENCE_CHALLENGE",
	1: "WRITE_CHALLENGE",
	2: "HEAR_CHALLENGE",
	3: "MATCH_CHALLENGE",
	4: "REVIEW_CHALLENGE",
	5: "VERB_CHALLENGE"
}

var seed_value = 0
var type = 0

func _ready() -> void:
	var datetime_dict = Time.get_datetime_dict_from_system()
	seed_value = int(str(datetime_dict.year) + str(datetime_dict.month) + str(datetime_dict.day) + str(id))
	if seed_value in Vars.challenge_progress:
		if Vars.challenge_progress[seed_value]["accepted"] == true:
			%AcceptTask.disabled = true
		if Vars.challenge_progress[seed_value]["done"] == true:
			%Completed.show()
			%ButtonVisual.hide()
	seed(seed_value)
	type = randi_range(0,5)
	var amount = 5 * randi_range(2,10)
	var reward = int(floor(amount * randf_range(4.0,7.0)))
	if type == 3:
		amount *= 2
	var title = tr(type_names[type]) % ("[color=orange]" + str(amount)+ "[/color]")
	%Title.text = title
	%Reward.text = str(reward)
	if not seed_value in Vars.challenge_progress.keys():
		Vars.challenge_progress[seed_value] = {
			"progress": 0,
			"type": type,
			"accepted": false,
			"done": false,
			"amount": amount,
			"reward": reward
		}
		update_challenge_list()
	%Completage.text = str(Vars.challenge_progress[seed_value]["progress"])+"/"+str(amount)
	match type:
		0:
			%Sentence.show()
		1:
			%SingleVocab.show()
		2:
			%Hearing.show()
		3:
			%Match.show()
		4:
			%Repeat.show()
		5:
			%Verbs.show()

func update_challenge_list():
	var datetime_dict = Time.get_datetime_dict_from_system()
	var old_seeds = []
	for seed_id in Vars.challenge_progress.keys():
		if !str(seed_id).begins_with(str(datetime_dict.year) + str(datetime_dict.month) + str(datetime_dict.day)):
			old_seeds.append(seed_id)
	for old_seed in old_seeds:
		Vars.challenge_progress.erase(old_seed)

func _on_button_pressed() -> void:
	Vars.learn_all = true
	match type:
		0:
			_on_write_sentences_pressed()
		1:
			_on_write_single_pressed()
		2:
			_on_hear_pressed()
		3:
			_on_match_cards_pressed()
		4:
			_on_review_pressed()
		5:
			_on_match_cards_2_pressed()

# Imported from learn_all.gd

func secure_words():
	if Vars.all_learn_words == []:
		Vars.all_learn_words = WordHandler.get_words_until_unit(Vars.max_unit)
	if Vars.all_learn_verbs == []:
		Vars.all_learn_verbs = Vars.verbs.values()
	Vars.save_saves("Making sure that words are selected [All Learn]")


func _on_hear_pressed() -> void:
	_on_accept_task_pressed()
	secure_words()
	Vars.learn_all = true
	get_tree().change_scene_to_file("res://scenes/learning_methods/hearing.tscn")

func _on_write_single_pressed() -> void:
	_on_accept_task_pressed()
	secure_words()
	Vars.learn_all = true
	Vars.word_selection_type = "single"
	get_tree().change_scene_to_file("res://scenes/learning_methods/write.tscn")

func _on_write_sentences_pressed() -> void:
	_on_accept_task_pressed()
	secure_words()
	Vars.learn_all = true
	Vars.word_selection_type = "sentence"
	get_tree().change_scene_to_file("res://scenes/learning_methods/write.tscn")

func _on_review_pressed() -> void:
	_on_accept_task_pressed()
	secure_words()
	Vars.learn_all = true
	Vars.word_selection_type = "review"
	get_tree().change_scene_to_file("res://scenes/learning_methods/write.tscn")


func _on_match_cards_2_pressed() -> void:
	_on_accept_task_pressed()
	secure_words()
	Vars.learn_all = true
	Vars.word_selection_type = "verbs"
	get_tree().change_scene_to_file("res://scenes/learning_methods/write.tscn")


func _on_match_cards_pressed() -> void:
	_on_accept_task_pressed()
	secure_words()
	Vars.learn_all = true
	get_tree().change_scene_to_file("res://scenes/match_learn.tscn")


func _on_accept_task_pressed() -> void:
	%AcceptTask.disabled = true
	Vars.challenge_progress[seed_value]["accepted"] = true
	Vars.save_saves()
