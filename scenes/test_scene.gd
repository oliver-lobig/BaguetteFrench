extends Control


# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#await get_tree().create_timer(3.0).timeout
	#%BreadRender.speek_text("Super bien!","fr")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#calculate_scale()
#
#func calculate_scale():
	#var viewport_size = Vector2(ProjectSettings.get("display/window/size/viewport_width"),ProjectSettings.get("display/window/size/viewport_height"))
	#var window_size = DisplayServer.window_get_size()
	#var expand_scale = Vector2(max(window_size.x / viewport_size.x,1.0), max(window_size.y / viewport_size.y,1.0))
	#var x_adjust
	#var x_scale = max(window_size.x / viewport_size.x,1.0) / min(window_size.y / viewport_size.y,1.0)
	#var y_scale = max(window_size.y / viewport_size.y,1.0) / min(window_size.x / viewport_size.x,1.0)
	#$Label2.text = "Scale: " + str(x_scale)
