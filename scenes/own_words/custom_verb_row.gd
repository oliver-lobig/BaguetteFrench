extends Control
signal pressed()

var text: String = ""
var verb: Verb

func _ready() -> void:
	%Button.text = text


func _on_texture_button_pressed() -> void:
	%ReallyDelete.show()
	%Main.hide()


func _on_no_pressed() -> void:
	%ReallyDelete.hide()
	%Main.show()


func _on_yes_pressed() -> void:
	Vars.own_categorys.get(Vars.current_open_category)["verbs"].erase(verb)
	queue_free()
	await get_tree().physics_frame
	Vars.save_saves()


func _on_button_pressed() -> void:
	pressed.emit()
