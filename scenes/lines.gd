extends Node2D

func _process(delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	if %VBoxContainer:
		for field_id in range(%VBoxContainer.get_child_count() - 1):
			var nodes = [%VBoxContainer.get_child(field_id),%VBoxContainer.get_child(field_id + 1)]
			if not nodes[0] is HSeparator and not nodes[1] is HSeparator:
				if %VBoxContainer.get_child(field_id).get_node("Button/VisibleOnScreenNotifier2D").is_on_screen() or %VBoxContainer.get_child(field_id + 1).get_node("Button/VisibleOnScreenNotifier2D").is_on_screen():
					#var line = Line2D.new()
					#line.default_color = Color(1.0, 1.0, 1.0, 0.435)
					#line.width = 8
					#line.add_point()
					#line.add_point()
					#$Lines.add_child(line)
					draw_line(nodes[0].get_node("Button").global_position+nodes[0].get_node("Button").size / 2,nodes[1].get_node("Button").global_position+nodes[1].get_node("Button").size / 2,Color(1.0, 1.0, 1.0, 0.435),8,true)
					#$Lines.queue_redraw()
