extends Control
const WELCOME_SCREEN = preload("uid://ceu57byqlq3bt")
const SET_LANGUAGE = preload("uid://d0lm4c6fvwtmw")
const SET_THEME = preload("uid://g5akp6yk6tlw")
const LOAD_WORDS = preload("uid://bxxwtqmync0k7")
const TUTORIAL = preload("uid://cs5ywyj12sc14")

func _ready() -> void:
	change_to_slide("welcome")
	IntroHandler.change_to.connect(change_to_slide)

func change_to_slide(slide: String):
	for child in %Slide.get_children():
		child.queue_free()
	var instance = null
	
	if slide == "welcome":
		instance = WELCOME_SCREEN.instantiate()
	if slide == "language":
		instance = SET_LANGUAGE.instantiate()
	if slide == "theme":
		instance = SET_THEME.instantiate()
	if slide == "download":
		instance = LOAD_WORDS.instantiate()
	if slide == "info":
		instance = TUTORIAL.instantiate()
	
	if instance != null:
		%Slide.add_child(instance)
