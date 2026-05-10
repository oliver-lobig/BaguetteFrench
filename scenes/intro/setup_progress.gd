extends ProgressBar

@export var new_value: float = 1.0

func _ready() -> void:
	load_value()
	
func load_value():
	if new_value != value:
		var anim_tween = get_tree().create_tween()
		anim_tween.set_trans(Tween.TRANS_EXPO)
		anim_tween.set_ease(Tween.EASE_IN_OUT)
		anim_tween.tween_property(self,"value",new_value,.5)
