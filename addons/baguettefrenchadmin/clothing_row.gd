@tool
extends HBoxContainer

signal adjust_transform(item: ClothingItem)

var item: ClothingItem = ClothingItem.new()
var start_id: int = -1

func _ready() -> void:
	start_id = item.id
	reload_data()

func reload_data():
	$ID.text = str(item.id) + ""
	
	$DisplayName.text = item.display_name
	
	$Description.text = item.description
	
	$FilePath.text = item.path
	
	$Price.text = str(item.price)
	
	match item.type:
		"hats":
			$TypeEnum.select(1)
		"faces":
			$TypeEnum.select(2)
		"shirts":
			$TypeEnum.select(3)
		"pants":
			$TypeEnum.select(4)
	
	reload_image()

func reload_image():
	if item.type != "faces":
		if FileAccess.file_exists(item.path):
			var texture = load(item.path)
			$TextureRect.texture = texture
	else:
		if FileAccess.file_exists(item.path+"/mouth/phonetics/A.svg"):
			var texture = load(item.path+"/mouth/phonetics/A.svg")
			$TextureRect.texture = texture

func change_item():
	Vars.save_saves()

func _on_display_name_text_changed(new_text: String) -> void:
	item.display_name = new_text
	change_item()


func _on_description_text_changed(new_text: String) -> void:
	item.description = new_text
	change_item()


func _on_file_path_text_changed(new_text: String) -> void:
	item.path = new_text
	reload_image()
	change_item()


func _on_type_enum_item_selected(index: int) -> void:
	match index:
		0:
			item.type = ""
		1:
			item.type = "hats"
		2:
			item.type = "faces"
		3:
			item.type = "shirts"
		4:
			item.type = "pants"
	change_item()

func _on_delete_button_pressed() -> void:
	Vars.baguette_shop_assortment.assortment.erase(item.id)
	queue_free()


func _on_button_pressed() -> void:
	adjust_transform.emit(item)


func _on_price_text_changed(new_text: String) -> void:
	item.price = float($Price.text)


func _on_id_text_changed(new_text: String) -> void:
	if new_text.length() == 5:
		var new_id = int(new_text)
		Vars.baguette_shop_assortment.assortment.erase(start_id)
		start_id = new_id
		item.id = new_id
		Vars.baguette_shop_assortment.assortment[new_id] = item
