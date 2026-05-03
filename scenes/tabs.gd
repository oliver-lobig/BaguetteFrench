extends Control

const LEARNING_PATH = preload("res://scenes/learning_path.tscn")
const LEARN_ALL = preload("res://scenes/learn_all.tscn")
const WORD_DICTIONARY = preload("res://scenes/learning_methods/word_dictionary/word_dictionary.tscn")
const SETTINGS = preload("res://scenes/settings.tscn")
const BAGUETTE_SHOP = preload("res://scenes/baguette_shop/baguette_shop.tscn")
const OWN_WORDS = preload("res://scenes/own_words.tscn")
const GEMS_VIEW = preload("res://scenes/gems_view.tscn")

var type: String = "path"

func _init() -> void:
	View.connect("change_to_tab",open_tab)
	View.connect("new_content",new_content)

func new_content(content: String):
	%ContentTitle.text = content
	%NewContent.show()

func _ready() -> void:
	open_tab("path",true)
	

func open_tab(tab: String, is_ready: bool = false):
	if type != "path":
		if is_ready == true:
			return
	type = tab
	enable()
	remove_scene()
	
	match tab:
		"path":
			Vars.whole_dictionary = false
			%Path.disabled = true
			var instance = LEARNING_PATH.instantiate()
			%Scene.add_child(instance)
		"settings":
			%Settings.disabled = true
			var instance = SETTINGS.instantiate()
			%Scene.add_child(instance)
		"learn_all":
			%LearnAll.disabled = true
			var instance = LEARN_ALL.instantiate()
			%Scene.add_child(instance)
		"shop":
			%Shop.disabled = true
			var instance = BAGUETTE_SHOP.instantiate()
			%Scene.add_child(instance)
		"own_words":
			%OwnWords.disabled = true
			var instance = OWN_WORDS.instantiate()
			%Scene.add_child(instance)
		"gems":
			%Gems.disabled = true
			var instance = GEMS_VIEW.instantiate()
			%Scene.add_child(instance)


func remove_scene():
	for child in %Scene.get_children():
		child.queue_free()

func enable():
	for child in %Content.get_children():
		if child is TextureButton:
			if child.disabled == true:
				child.disabled = false


func _on_dictionary_pressed() -> void:
	open_tab("dictionary")


func _on_path_pressed() -> void:
	open_tab("path")


func _on_settings_pressed() -> void:
	open_tab("settings")


func _on_learn_all_pressed() -> void:
	open_tab("learn_all")

func _on_new_content_close_pressed() -> void:
	%NewContent.hide()


func _on_shop_pressed() -> void:
	open_tab("shop")


func _on_own_words_pressed() -> void:
	open_tab("own_words")


func _on_gems_pressed() -> void:
	open_tab("gems")
