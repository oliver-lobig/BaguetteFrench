extends VBoxContainer

const BG_CROPPED_0 = preload("res://assets/scenes/learning_path/bg_slices/bg_cropped_0.png")
const BG_CROPPED_1 = preload("res://assets/scenes/learning_path/bg_slices/bg_cropped_1.png")
const BG_CROPPED_2 = preload("res://assets/scenes/learning_path/bg_slices/bg_cropped_2.png")
const BG_CROPPED_3 = preload("res://assets/scenes/learning_path/bg_slices/bg_cropped_3.png")
const BG_CROPPED_4 = preload("res://assets/scenes/learning_path/bg_slices/bg_cropped_4.png")
const BG_CROPPED_5 = preload("res://assets/scenes/learning_path/bg_slices/bg_cropped_5.png")
const BG_CROPPED_6 = preload("res://assets/scenes/learning_path/bg_slices/bg_cropped_6.png")
const BG_CROPPED_7 = preload("res://assets/scenes/learning_path/bg_slices/bg_cropped_7.png")
const BG_CROPPED_8 = preload("res://assets/scenes/learning_path/bg_slices/bg_cropped_8.png")
const BG_CROPPED_9 = preload("res://assets/scenes/learning_path/bg_slices/bg_cropped_9.png")
const BG_CROPPED_10 = preload("res://assets/scenes/learning_path/bg_slices/bg_cropped_10.png")
const BG_CROPPED_11 = preload("res://assets/scenes/learning_path/bg_slices/bg_cropped_11.png")
const BG_CROPPED_12 = preload("res://assets/scenes/learning_path/bg_slices/bg_cropped_12.png")
const BG_CROPPED_13 = preload("res://assets/scenes/learning_path/bg_slices/bg_cropped_13.png")
const BG_CROPPED_14 = preload("res://assets/scenes/learning_path/bg_slices/bg_cropped_14.png")
const BG_CROPPED_15 = preload("res://assets/scenes/learning_path/bg_slices/bg_cropped_15.png")
const BG_CROPPED_17 = preload("res://assets/scenes/learning_path/bg_slices/bg_cropped_17.png")
const BG_CROPPED_18 = preload("res://assets/scenes/learning_path/bg_slices/bg_cropped_18.png")
const BG_CROPPED_19 = preload("res://assets/scenes/learning_path/bg_slices/bg_cropped_19.png")
const BG_CROPPED_16 = preload("res://assets/scenes/learning_path/bg_slices/bg_cropped_16.png")

var images = [
	BG_CROPPED_0,
	BG_CROPPED_1,
	BG_CROPPED_2,
	BG_CROPPED_3,
	BG_CROPPED_4,
	BG_CROPPED_5,
	BG_CROPPED_6,
	BG_CROPPED_7,
	BG_CROPPED_8,
	BG_CROPPED_9,
	BG_CROPPED_10,
	BG_CROPPED_11,
	BG_CROPPED_12,
	BG_CROPPED_13,
	BG_CROPPED_14,
	BG_CROPPED_15,
	BG_CROPPED_16,
	BG_CROPPED_17,
	BG_CROPPED_18,
	BG_CROPPED_19,
]
var image_count = 20

func _ready() -> void:
	for i in image_count:
		var tr = TextureRect.new()
		var image = images[i]
		#if !get_tree():
			#return
		#await get_tree().process_frame
		tr.texture = image
		add_child(tr)
