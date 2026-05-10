@tool
extends Panel
class_name FlagCirlce

const FLAG_CIRCLE = preload("uid://bsdqcxyeqnvfe")

@export var country_code = "de"

var last_country_code = ""

func _ready() -> void:
	var original_material = FLAG_CIRCLE
	var mat: ShaderMaterial = original_material.duplicate_deep(Resource.DEEP_DUPLICATE_ALL)
	material = mat
	load_flag()

func load_flag():
	if FileAccess.file_exists("res://assets/general_ui/flag-icons/flags/1x1/"+ country_code+".svg"):
		var image = load("res://assets/general_ui/flag-icons/flags/1x1/"+ country_code+".svg")
		(material as ShaderMaterial).set_shader_parameter("Texture2DParameter",image)

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		if last_country_code != country_code:
			last_country_code = country_code
			load_flag()
