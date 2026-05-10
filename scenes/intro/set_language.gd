extends Control

var id = 0

var selected_language = ""

func _ready() -> void:
	%Content.size = %ContentAnchor.size
	%Content.position.x = %ContentAnchor.size.x
	%Content.position.y = 0
	animate_transition_in()


func _process(delta: float) -> void:
	if %Content.size != %ContentAnchor.size:
		%Content.size = %ContentAnchor.size

func animate_transition_in():
	var anim_tween = get_tree().create_tween()
	anim_tween.set_trans(Tween.TRANS_CIRC)
	anim_tween.set_ease(Tween.EASE_OUT)
	anim_tween.tween_property(%Content,"position",Vector2(0.0,0.0),.5)


func _on_language_german_pressed() -> void:
	%LanguageGerman.disabled = true
	%LanguageFrench.disabled = false
	%ContinueButton.text = "NEXT_BUTTON"
	%ContinueButton.disabled = false
	selected_language = "de"
	Vars.settings_data.language = selected_language
	TranslationServer.set_locale(Vars.settings_data.language)
	Vars.save_saves("Language set to german")


func _on_language_french_pressed() -> void:
	%LanguageGerman.disabled = false
	%LanguageFrench.disabled = true
	%ContinueButton.text = "NEXT_BUTTON"
	%ContinueButton.disabled = false
	selected_language = "fr"
	Vars.settings_data.language = selected_language
	TranslationServer.set_locale(Vars.settings_data.language)
	Vars.save_saves("Language set to german")


func _on_continue_button_pressed() -> void:
	animate_transition()
	await get_tree().create_timer(0.4).timeout
	IntroHandler.change_to.emit("theme")

func animate_transition():
	var anim_tween = get_tree().create_tween()
	anim_tween.set_trans(Tween.TRANS_CIRC)
	anim_tween.set_ease(Tween.EASE_IN)
	anim_tween.tween_property(%Content,"position",Vector2(-%Content.size.x, 0.0),.3)
