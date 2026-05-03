extends Control


func _on_button_pressed() -> void:
	var data = {
		"id": %Search.text,
		"name": %Search.text,
		"words": []
	}
	Vars.own_categorys[%Search.text] = data
	Vars.save_saves()
	View.open_tab("own_words")
