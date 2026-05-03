extends Control

func _ready() -> void:
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	$SubViewport.size.x = size.x
	$SubViewport.size.y = $SubViewport/LearningPath/ScrollContainer/VBoxContainer.size.y / 4
	$SubViewport/LearningPath.size = $SubViewport.size
	
	for i in range(4):
		$SubViewport/LearningPath/ScrollContainer.scroll_vertical = i * $SubViewport.size.y
		await get_tree().process_frame
		await get_tree().process_frame
		var texture: ViewportTexture = $SubViewport.get_texture()
		await get_tree().process_frame
		await get_tree().process_frame
		var image = texture.get_image()
		if image:
			image.save_png("user://learning_path_image"+str(i)+".png")
		else:
			print("Uhoh, that didn't work!")
