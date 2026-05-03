extends Control

const CRYSTAL_PARTICLE = preload("res://scenes/points/crystal_particle.tscn")

@export var count_up: bool = false
@export var count_time: float = 1.0
@export_enum("NONE","SENTENCE_CHALLENGE","WRITE_CHALLENGE","HEAR_CHALLENGE","MATCH_CHALLENGE","REVIEW_CHALLENGE","VERB_CHALLENGE") var challenge_type: int = 0

var displaying_points: int = 0

var before: int = 0

var last_amount: int = 0

var count_up_time: float = 0.0
var tween = null

var current_completed_challenge_id: int = 0

func _ready() -> void:
	tween = get_tree().create_tween()
	tween.stop()
	
	if count_up == false:
		change_display()
	await get_tree().process_frame
	reload_quest_type()

func reload_quest_type(smooth: bool = false):
	%TaskProgressBar.hide()
	if Vars.has_quest_with_type(challenge_type - 1):
		%TaskProgressBar.show()
		var datetime = Time.get_datetime_dict_from_system()
		var using_challenge_id: int = 0
		var max_done_amount: float = -1.0
		for challenge in Vars.challenge_progress:
			if str(challenge).begins_with(str(datetime.year) + str(datetime.month) + str(datetime.day)):
				var challenge_data = Vars.challenge_progress[challenge]
				if challenge_data.type == challenge_type - 1:
					if challenge_data.done == false:
						var challenge_progress = float(challenge_data.progress) / float(challenge_data.amount) if challenge_data.amount != 0 else 0.0
						if challenge_progress > max_done_amount:
							max_done_amount = challenge_progress
							using_challenge_id = challenge
		var using_challenge = Vars.challenge_progress[using_challenge_id]
		var max_amount = using_challenge["amount"]
		var amount = using_challenge["progress"]
		set_challenge_bar_progress(amount, max_amount) if smooth == false else smooth_set_challenge_bar_progress(amount, max_amount)

func get_bar_progress_real_data(amount: int, of: int) -> Dictionary: 
	var max_val = %TaskProgressBar.size.x
	var real_min = %TaskProgressBar.size.y
	var span = max_val - real_min
	var val = real_min + (span * (float(amount) / float(of)))
	return {
		"max_val": max_val,
		"val": val
	}

func set_challenge_bar_progress(amount: int, of: int):
	var bar_data = get_bar_progress_real_data(amount, of)
	if %TaskProgressBar.max_value != bar_data.max_val:
		%TaskProgressBar.max_value = bar_data.max_val
	%TaskProgressBar.value = bar_data.val

func smooth_set_challenge_bar_progress(amount: int, of: int):
	var bar_data = get_bar_progress_real_data(amount, of)
	var anim_tween = get_tree().create_tween()
	anim_tween.set_trans(Tween.TRANS_CIRC)
	anim_tween.tween_property(%TaskProgressBar,"value",bar_data.val,.5)

func _process(delta: float) -> void:
	if count_up:
		count_up_time += delta
		displaying_points = tween.interpolate_value(0,Vars.learn_points,count_up_time,count_time,Tween.TRANS_CIRC,Tween.EASE_OUT)
		%Count.text = str(displaying_points)
		if count_up_time > count_time:
			count_up = false
			change_display()

func change_display():
	%Count.text = str(Vars.learn_points)

var type_names = {
	0: "SENTENCE_CHALLENGE",
	1: "WRITE_CHALLENGE",
	2: "HEAR_CHALLENGE",
	3: "MATCH_CHALLENGE",
	4: "REVIEW_CHALLENGE",
	5: "VERB_CHALLENGE"
}

func done_challenge(id: int):
	await get_tree().create_timer(.9).timeout
	if View.current_camera:
		View.current_camera.shake(30,45,.2)
	await get_tree().create_timer(.1).timeout
	current_completed_challenge_id = id
	var challenge_data = Vars.challenge_progress[id] 
	var challenge_name = tr(type_names[challenge_data.type]) % str(challenge_data.amount)
	%DoneChallengeOverlay.show()
	%DoneChallengeOverlay.set_point_name(challenge_data.reward)
	%DoneChallengeOverlay.set_challenge_type(challenge_data.type)
	%DoneChallengeOverlay.set_challenge_name(challenge_name)
	%DoneChallengeOverlay.get_points.connect(get_points_from_challenge)
	reload_quest_type()

func get_points_from_challenge():
	var challenge_data = Vars.challenge_progress[current_completed_challenge_id] 
	var reward = challenge_data.reward
	get_points([1],[reward],get_window().size / 2)
	%DoneChallengeOverlay.hide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("add_point"):
		get_points([1],[1])

func get_points(prob: Array = [1],mappings: Array = [1], pos: Vector2 = Vector2(-1,-1), radius: float = 150, speed: float = 700, end_time: float = 3.0):
	var datetime = Time.get_datetime_dict_from_system()
	for challenge in Vars.challenge_progress:
		if str(challenge).begins_with(str(datetime.year) + str(datetime.month) + str(datetime.day)):
			var challenge_data = Vars.challenge_progress[challenge]
			if challenge_data.type == challenge_type - 1:
				if challenge_data.done == false:
					challenge_data.progress += 1 if challenge_data.type != 3 else 5
					reload_quest_type(true)
					if challenge_data.progress == challenge_data.amount:
						challenge_data.done = true
						done_challenge(challenge)
						continue
	var amount = Utils.roll_random(prob,mappings)
	
	last_amount = amount
	
	before = Vars.learn_points
	
	if pos != Vector2(-1,-1) and Vars.settings_data.activate_jewel_particles:
		for i in range(amount):
			var instance = CRYSTAL_PARTICLE.instantiate()
			instance.end_point = $TextureRect.global_position + $TextureRect.size / 2
			instance.start_point = pos
			instance.radius = radius
			instance.speed = speed
			instance.end_time = end_time
			instance.done.connect(add_point)
			add_child(instance)
	else:
		Vars.learn_points += amount
		change_display()
		$Collect.play()
	#await get_tree().create_timer(end_time + 0.5).timeout
	#Vars.save_saves("get Points Save")

func revert():
	Vars.learn_points -= last_amount
	last_amount = 0
	#Vars.save_saves("Revert add points")
	change_display()


func add_point():
	if View.current_camera:
		View.current_camera.shake(20,20,.1)
	%WhiteGem.modulate = Color.WHITE
	var anim_tween = get_tree().create_tween()
	anim_tween.tween_property(%WhiteGem,"modulate",Color.TRANSPARENT,.5)
	$Collect.play()
	Vars.learn_points += 1
	change_display()
