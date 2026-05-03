extends Control
signal get_points()


func set_challenge_name(challenge_name: String):
	%ChallengeDescription.text = challenge_name

func set_point_name(points: int):
	%Reward.text = str(points)

func set_challenge_type(type: int):
	for child in %TextureRect.get_children():
		if child is TextureRect:
			child.hide()
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

func _on_button_pressed() -> void:
	get_points.emit()


func _on_visibility_changed() -> void:
	if visible:
		self.scale = Vector2(1,0.9)
		var anim_tween = get_tree().create_tween()
		anim_tween.set_trans(Tween.TRANS_ELASTIC)
		anim_tween.tween_property(self, "scale",Vector2(1,1),.2)
