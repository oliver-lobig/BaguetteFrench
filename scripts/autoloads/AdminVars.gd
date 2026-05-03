@tool
extends Node

@warning_ignore("unused_signal")
signal reload_id

@warning_ignore("unused_signal")
signal send_query

var search_query: String = ""

var test_themes: String = ""

#func _ready() -> void:
	#Vars.save_saves()
	#Vars.baguette_shop_assortment = BaguetteShopAssortment.new()
	#Vars.save_saves()

func remove_word(word: Word):
	Vars.words.remove_at(word.id)
	var i: int = 0
	for w in Vars.words:
		w.id = i
		i += 1
	reload_id.emit()
	Vars.save_saves("Removed word: " + str(word.german) + " | " + str(word.id))

func reload_ids():
	var i: int = 0
	for w in Vars.words:
		w.id = i
		i += 1
	reload_id.emit()
	Vars.save_saves("Reload IDS word")
