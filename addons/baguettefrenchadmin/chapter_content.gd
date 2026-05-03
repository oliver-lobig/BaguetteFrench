@tool
extends HBoxContainer
signal up(id: int)
signal down(id: int)
signal delete(id: int)

var field_id: int = 0
var field_type: int = 0
var id: int = 0

func _ready() -> void:
	$LineEdit.text = str(field_id)
	$OptionButton.clear()
	for option in Definitions.FieldTypes.keys():
		$OptionButton.add_item(option)
	$OptionButton.select(field_type)

func get_type() -> int:
	return $OptionButton.selected

func get_id() -> int:
	return int($LineEdit.text)

func _on_button_pressed() -> void:
	up.emit(id)

func _on_button_2_pressed() -> void:
	down.emit(id)


func _on_delete_pressed() -> void:
	delete.emit(id)
