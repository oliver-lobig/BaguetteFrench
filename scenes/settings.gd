extends Control

var play_sound: bool = false

func _ready() -> void:
	match Vars.settings_data.current_theme_path:
		"res://assets/learn_scene_theme.tres":
			%ThemeOptionButton.selected = 0
		"res://assets/extra_themes/spring_theme.tres":
			%ThemeOptionButton.selected = 1
	%JewelSettings.get_node("Active").button_pressed = Vars.settings_data.activate_jewel_particles
	%JewelSettings.get_node("SizeSlider").value = Vars.settings_data.jewel_size
	%ToFrench.button_pressed = Vars.settings_data.to_french
	%UseShake.button_pressed = Vars.settings_data.use_camera_shake
	var gem_size = Vars.settings_data.jewel_size
	%Gem.scale = Vector2(0.3 * gem_size,0.3 * gem_size)
	%JewelSettings.get_node("VolumeSlider").value = Vars.settings_data.jewel_volume
	if Vars.settings_data.language == "de":
		%LanguageGerman.disabled = true
		%LanguageFrench.disabled = false
	else:
		%LanguageGerman.disabled = false
		%LanguageFrench.disabled = true

func _on_check_box_toggled(toggled_on: bool) -> void:
	Vars.settings_data.activate_jewel_particles = toggled_on
	Vars.save_saves("Active Particles toggeled")


func _on_h_slider_value_changed(value: float) -> void:
	Vars.settings_data.jewel_size = value
	%Gem.scale = Vector2(0.3 * value,0.3 * value)


func _on_h_slider_drag_ended(value_changed: bool) -> void:
	Vars.save_saves("HSlide1 Drag")


func _on_volume_slider_2_drag_ended(value_changed: bool) -> void:
	Vars.save_saves("Volume Slider Drag")

func _on_volume_slider_2_value_changed(value: float) -> void:
	Vars.settings_data.jewel_volume = value
	var gem_bus_id = AudioServer.get_bus_index("PointParticle")
	AudioServer.set_bus_mute(gem_bus_id, value == -40)
	AudioServer.set_bus_volume_db(gem_bus_id, value)
	if play_sound == true:
		%GemSound.play()
	else:
		play_sound = true


func _on_to_french_toggled(toggled_on: bool) -> void:
	Vars.settings_data.to_french = toggled_on
	Vars.to_french = toggled_on
	Vars.save_saves("Changed to frecnh")


func _on_option_button_item_selected(index: int) -> void:
	var theme_path: String = ""
	match index:
		0:
			theme_path = "res://assets/learn_scene_theme.tres"
		1:
			theme_path = "res://assets/extra_themes/spring_theme.tres"
	
	Vars.settings_data.current_theme_path = theme_path
	Vars.save_saves("Theme selected")
	%ThemeSwitcher.change_theme()


func _on_language_german_pressed() -> void:
	Vars.settings_data.language = "de"
	TranslationServer.set_locale(Vars.settings_data.language)
	Vars.save_saves("Language set to german")
	%LanguageGerman.disabled = true
	%LanguageFrench.disabled = false

func _on_language_french_pressed() -> void:
	Vars.settings_data.language = "fr"
	TranslationServer.set_locale(Vars.settings_data.language)
	Vars.save_saves("Language set to french")
	%LanguageGerman.disabled = false
	%LanguageFrench.disabled = true


func _on_flip_after_half_toggled(toggled_on: bool) -> void:
	Vars.settings_data.flip_after_half = toggled_on
	Vars.save_saves("Language flip after Half")


func _on_use_shake_toggled(toggled_on: bool) -> void:
	Vars.settings_data.use_camera_shake = toggled_on
	Vars.save_saves("CAM SHAKE SETTING (why capslock?)")


func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/credits.tscn")
