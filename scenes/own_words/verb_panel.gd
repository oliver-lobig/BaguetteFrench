@tool
extends PanelContainer
signal updated_content(field_type, french, german)

@export var placeholder_french = "TEST FR"
@export var placeholder_german = "TEST DE"
@export var type: String = "test"

func _ready() -> void:
	%French.placeholder_text = placeholder_french
	%German.placeholder_text = placeholder_german

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		%French.placeholder_text = placeholder_french
		%German.placeholder_text = placeholder_german


func _on_french_text_changed(new_text: String) -> void:
	updated_content.emit(type,%French.text,%German.text)

func _on_german_text_changed(new_text: String) -> void:
	updated_content.emit(type,%French.text,%German.text)
