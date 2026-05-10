@tool
extends Node
class_name ThemeSwitcher

const SCREEN_PROGRESS_BAR_FILL = "res://assets/extra_themes/standard/screen_progress_bar_bg.tres"
const SCREEN_PROGRESS_BAR_BG = "res://assets/extra_themes/standard/screen_progress_bar_fill.tres"
const SCREEN_PROGRESS_BAR_BG_SPRING = "res://assets/extra_themes/spring/screen_progress_bar_bg_spring.tres"
const SCREEN_PROGRESS_BAR_FILL_SPRING = "res://assets/extra_themes/spring/screen_progress_bar_fill_spring.tres"
const VOCAB_MATCH_CARD_TO_SPRING = "res://assets/extra_themes/spring/vocab_match_card_to_spring.tres"
const VOCAB_MATCH_CARD_TO = "res://assets/extra_themes/standard/vocab_match_card_to.tres"
const VOCAB_MATCH_CARD_TO_SELECTED_SPRING = "res://assets/extra_themes/spring/vocab_match_card_to_selected_spring.tres"
const VOCAB_MATCH_CARD_TO_SELECTED = "res://assets/extra_themes/standard/vocab_match_card_to_selected.tres"

var current_theme: String = ""
var standard_theme: String = "res://assets/learn_scene_theme.tres"

var theme_list: Array = ["res://assets/learn_scene_theme.tres","res://assets/extra_themes/spring_theme.tres"]

@export var overwrite_theme: Theme

@export_tool_button("Set All Themes","Callable") var set_overwrite_themes = overwrite_themes_action

func overwrite_themes_action():
	AdminVars.test_themes = overwrite_theme.resource_path

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		if current_theme != AdminVars.test_themes:
			current_theme = AdminVars.test_themes
			var theme = load(current_theme)
			if get_parent() is Control:
				get_parent().theme = theme

func _ready() -> void:
	change_theme()
	IntroHandler.update_theme.connect(change_theme)
	if Engine.is_editor_hint():
		if get_child_count() == 1:
			if !$AnimationPlayer.has_animation_library("theme_animations"):
				var library: AnimationLibrary = AnimationLibrary.new()
				for theme in theme_list:
					library.add_animation(theme.split("/")[-1].replace(".tres",""),Animation.new())
				$AnimationPlayer.add_animation_library("theme_animations",library)

func change_theme():
	check_screen_progress_bar()
	check_match_to()
	check_text()
	if !Vars.settings_data.current_theme_path:
		var theme = load(standard_theme)
		if get_child_count() == 1:
			if get_child(0) is AnimationPlayer:
				if $AnimationPlayer.has_animation_library("theme_animations"):
					get_child(0).play("theme_animations/"+theme.resource_path.split("/")[-1].replace(".tres",""))
		if get_parent() is Control:
			get_parent().theme = theme
		return
	var theme = load(Vars.settings_data.current_theme_path)
	if get_child_count() == 1:
		if get_child(0) is AnimationPlayer:
			if $AnimationPlayer.has_animation_library("theme_animations"):
				get_child(0).play("theme_animations/"+theme.resource_path.split("/")[-1].replace(".tres",""))
	if !theme:
		printerr("Kann Theme nicht wechseln! Theme existiert nicht!")
		return
	if get_parent() is Control:
		get_parent().theme = theme
	else:
		printerr("Kann Theme nicht wechseln! Parent Node ist kein 'Control'-Node! Der Node hat den Typen '" + get_parent().name + "'.")

func check_screen_progress_bar():
	if get_parent().is_in_group("ScreenProgressBar"):
	
		var progress_bar: ProgressBar = get_parent()
		match Vars.settings_data.current_theme_path:
			"res://assets/learn_scene_theme.tres":
				progress_bar.get_node("HBoxContainer/Control/Done").add_theme_color_override("font_color",Color(1.0, 0.976, 0.984))
				progress_bar.get_node("HBoxContainer/Control/Done").add_theme_color_override("font_shadow_color",Color(0.89, 0.89, 0.89, 1.0))
				progress_bar.get_node("HBoxContainer/Control/Done").add_theme_color_override("font_outline_color",Color(0.89, 0.89, 0.89, 1.0))
				progress_bar.add_theme_stylebox_override("background",load(SCREEN_PROGRESS_BAR_BG))
				progress_bar.add_theme_stylebox_override("fill",load(SCREEN_PROGRESS_BAR_FILL))
			"res://assets/extra_themes/spring_theme.tres":
				progress_bar.get_node("HBoxContainer/Control/Done").add_theme_color_override("font_color",Color(0.149, 0.31, 0.224))
				progress_bar.get_node("HBoxContainer/Control/Done").add_theme_color_override("font_shadow_color",Color(0.149, 0.31, 0.224))
				progress_bar.get_node("HBoxContainer/Control/Done").add_theme_color_override("font_outline_color",Color(0.149, 0.31, 0.224))
				progress_bar.add_theme_stylebox_override("background",load(SCREEN_PROGRESS_BAR_BG_SPRING))
				progress_bar.add_theme_stylebox_override("fill",load(SCREEN_PROGRESS_BAR_FILL_SPRING))
			

func check_match_to():
	if get_parent().is_in_group("MatchTo"):
		var match_to: PanelContainer = get_parent()
		match Vars.settings_data.current_theme_path:
			"res://assets/learn_scene_theme.tres":
				match_to.add_theme_stylebox_override("panel",load(VOCAB_MATCH_CARD_TO))
			"res://assets/extra_themes/spring_theme.tres":
				match_to.add_theme_stylebox_override("panel",load(VOCAB_MATCH_CARD_TO_SPRING))
	if get_parent().is_in_group("MatchToSelected"):
		var match_to: Panel = get_parent()
		match Vars.settings_data.current_theme_path:
			"res://assets/learn_scene_theme.tres":
				match_to.add_theme_stylebox_override("panel",load(VOCAB_MATCH_CARD_TO))
			"res://assets/extra_themes/spring_theme.tres":
				match_to.add_theme_stylebox_override("panel",load(VOCAB_MATCH_CARD_TO_SPRING))

func check_text():
	if get_parent().is_in_group("FontColorSwitch"):
		var text: Control = get_parent()
		var change_things: Array = ["font_color","font_focus_color","font_pressed_color","font_hover_color","font_hover_pressed_color","font_disabled_color"]
		match Vars.settings_data.current_theme_path:
			"res://assets/learn_scene_theme.tres":
				for thing in change_things:
					if thing == "font_color" or text is Button:
						text.add_theme_color_override(thing,Color(0.886, 0.886, 0.886))
			"res://assets/extra_themes/spring_theme.tres":
				for thing in change_things:
					if thing == "font_color" or text is Button:
						text.add_theme_color_override(thing,Color(1.0, 0.976, 0.984, 1.0))


func _on_back_button_pressed() -> void:
	View.open_tab("own_words")
