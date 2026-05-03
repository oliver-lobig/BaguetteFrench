extends PanelContainer
class_name ShopItemFrame

signal select(frame)
signal unselected(frame)

var selected: bool = false

var item: ClothingItem

func _ready() -> void:
	%Highlight.hide()
	if not item:
		return
	
	
	var item_texture = load(item.path) if item.type != "faces" else load(item.path+"/mouth/phonetics/A.svg")
	if item_texture is DPITexture:
		var higres_texture: DPITexture = item_texture.duplicate_deep()
		
		higres_texture.base_scale *= 3
		
		%ItemImage.texture = higres_texture
	else:
		%ItemImage.texture = item_texture
	
	%Name.text = item.display_name
	if item.price > 999:
		var k_display = str(floor(item.price / 100.0)/10.0) if fmod(item.price,1000) != 0 else str(int(floor(item.price / 1000.0)) )
		%Price.text = str(k_display) + "k"
	else:
		%Price.text = str(int(item.price))
	if item.id in Vars.baguette_style_data.possesed_items:
		%Price.hide()
		%Gem.hide()
		%Check.show()
func _on_button_pressed() -> void:
	if selected == false:
		select.emit(self)
		selected = true
		%Highlight.show()

func unselect():
	unselected.emit(self)
	selected = false
	%Highlight.hide()
