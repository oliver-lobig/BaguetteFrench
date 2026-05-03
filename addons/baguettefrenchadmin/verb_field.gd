@tool
extends Control
signal new_version(german: String, french: String)

@export var prefix_french: String = "":
	set(value):
		prefix_french = value
		%French.placeholder_text = value

@export var prefix_german: String = "":
	set(value):
		prefix_german = value
		%German.placeholder_text = value


func _on_french_text_changed(new_text: String) -> void:
	new_version.emit(%German.text,%French.text)


func _on_german_text_changed(new_text: String) -> void:
	new_version.emit(%German.text,%French.text)
