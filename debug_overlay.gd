extends CanvasLayer

var press_delay: float = 0.0
var press_id: int = 0
var running: bool = false

func _ready() -> void:
	%Overlay.hide()
	if OS.get_name() == "Web":
		%Save.disabled = true

func _process(delta: float) -> void:
	if running:
		press_delay += delta
		if press_id <= 4:
			if press_delay > 1.0:
				running = false
		else:
			%Line.show()
			if press_delay <  3.0:
				%Line.position.y = -64 * ((3 - press_delay)/3)
			else:
				%Line.position.y = -64 * ((press_delay - 3)/5)
			if press_delay > 3.0:
				%PanelBlue.show()
			else:
				%PanelBlue.hide()
			if press_delay > 8.0:
				running = false


func _input(event: InputEvent) -> void:
	if %Overlay.visible == false:
		if event.is_action_pressed("click"):
			press_delay = 0.0
			if running == false:
				press_id = 0
				running = true
			else:
				press_id += 1
		if event.is_action_released("click"):
			%Line.hide()
			if press_id == 5:
				if press_delay >= 3.0 and press_delay <= 8.0:
					running = false
					open_debug()
				elif press_delay <= 3.0:
					press_id = 4

func open_debug():
	open_save_file()
	%Overlay.show()
	%Line.hide()


func _on_close_button_pressed() -> void:
	%Overlay.hide()

func open_save_file():
	%SaveFile.show()
	%SaveFileTab.disabled = true
	%SaveFileContent.text = read_save_file()

func read_save_file():
	if !FileAccess.file_exists("user://data/save_file.tres"):
		return "No save file found! (at " + OS.get_user_data_dir() + "/data/save_file.tres)"
	var save_file = FileAccess.open("user://data/save_file.tres",FileAccess.READ)
	if save_file == null:
		return "Save file is 'null'! (at " + OS.get_user_data_dir() + "/data/save_file.tres)"
	return save_file.get_as_text()


func _on_open_pressed() -> void:
	OS.shell_open(OS.get_user_data_dir() + "/data/save_file.tres")


func _on_save_pressed() -> void:
	%Title.text = "Choose Path"
	%FileDialog.show()


func _on_file_dialog_file_selected(path: String) -> void:
	if !FileAccess.file_exists(path):
		var save_file_backup = FileAccess.open(path,FileAccess.WRITE)
		save_file_backup.store_string(read_save_file())
		save_file_backup.close()
		%Title.text = "Saved!"
		await get_tree().create_timer(3.0).timeout
		%Title.text = "Debugging"


func _on_folder_pressed() -> void:
	OS.shell_show_in_file_manager(OS.get_user_data_dir() + "/data/save_file.tres")


func _on_copy_pressed() -> void:
	DisplayServer.clipboard_set(read_save_file())
	%Title.text = "Copied!"
	await get_tree().create_timer(3.0).timeout
	%Title.text = "Debugging"
