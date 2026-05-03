extends Control

var state: int = 0

func _ready() -> void:
	if !Vars.field_progress.has(Vars.current_open_field_id):
		Vars.field_progress[Vars.current_open_field_id] = 1
	elif Vars.field_progress.get(Vars.current_open_field_id) == 1:
		await get_tree().process_frame
		View.open_tab("path")
	Vars.done_field_ids.append(Vars.current_open_field_id)
	Vars.save_saves()
	
	for g in %Gems.get_children():
		if g is TextureRect:
			g.hide()
	
	%Gem0.show()
	


func _on_button_pressed() -> void:
	state += 1
	if state < 4:
		%Mine.play()
		for g in %Gems.get_children():
			if g is TextureRect:
				g.hide()
		
		%Gems.get_child(state).show()
		%PointCounter.get_points([3,5,4,2],[3,5,7,11],%Gems.global_position + %Gems.size / 2,%Gems.size.x / 4)
	else:
		%Particles.global_position = %Gems.global_position + %Gems.size / 2
		%Particles.emitting = true
		%Break.play()
		
		for g in %Gems.get_children():
			if g is TextureRect:
				g.hide()
		
		%PointCounter.get_points([3,5,4,2,1],[67,82,109,142,192],%Gems.global_position + %Gems.size / 2,%Gems.size.x / 2)
		
		await get_tree().create_timer(0.2).timeout
		%Particles.emitting = false
		
		await get_tree().create_timer(1.0).timeout
		
		%Done.show()

func _on_done_pressed() -> void:
	View.open_tab("path")
