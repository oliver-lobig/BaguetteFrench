extends Control

const SHOP_ITEM_FRAME = preload("res://scenes/baguette_shop/shop_item_frame.tscn")

var tab = 0
var categorys = ["hats","shirts","pants","faces"]

var current_category = ""

var selected_objects = {
	"hats":null,
	"shirts":null,
	"pants":null,
	"faces":null
}

func _ready() -> void:
	switch_to_tab(0)

func switch_to_tab(new_tab: int):
	if new_tab == 3:
		%BreadRender.always_talk = true
		%BreadRender.start_talk()
	else:
		%BreadRender.always_talk = false
	tab = new_tab
	for child in %Tabs.get_children():
		child.disabled = false
	%Tabs.get_child(tab).disabled = true
	current_category = categorys[tab]
	add_items()

func add_items():
	for item in %ShopItems.get_children():
		item.queue_free()
	var items = Vars.baguette_shop_assortment.assortment.values()
	for item: ClothingItem in items:
		if current_category == item.type:
			var instance = SHOP_ITEM_FRAME.instantiate()
			instance.item = item
			instance.select.connect(selected_item)
			instance.unselected.connect(unselected_item)
			%ShopItems.add_child(instance)
			if selected_objects[current_category]:
				if item.id == selected_objects[current_category].id:
					instance._on_button_pressed()
			elif item.id == Vars.baguette_style_data.face_id or item.id == Vars.baguette_style_data.hat_id or item.id == Vars.baguette_style_data.pants_id or item.id == Vars.baguette_style_data.shirt_id:
				instance._on_button_pressed()

func selected_item(frame: ShopItemFrame):
	match current_category:
		"hats":
			%BreadRender.override_hat = frame.item.id
			%BreadAnimationPlayer.play("hat")
		"shirts":
			%BreadRender.override_shirt = frame.item.id
			%BreadAnimationPlayer.play("shirt")
		"pants":
			%BreadRender.override_pants = frame.item.id
			%BreadAnimationPlayer.play("pants")
		"faces":
			%BreadRender.override_face = frame.item.id
			%BreadRender.always_talk = true
	for shop_frame in %ShopItems.get_children():
		if shop_frame != frame:
			shop_frame.unselect()
	%BreadRender.load_style()
	%DescriptionText.text = frame.item.description
	%DescriptionText.show()
	selected_objects[current_category] = frame.item
	calculate_whole_price()
	update_can_buy()

func update_can_buy():
	var can_buy: bool = false
	var free: bool = true
	for object in selected_objects.values():
		if object:
			can_buy = true
			if !object.id in Vars.baguette_style_data.possesed_items:
				free = false
	if free:
		%Buy.text = BaguetteTranslationServer.translate("SHOP_OUTFIT_CHOOSE")
	else:
		%Buy.text = BaguetteTranslationServer.translate("SHOP_OUTFIT_BUY")
	if can_buy:
		%Buy.disabled = false
	else:
		%Buy.disabled = true

func unselected_item(frame: ShopItemFrame):
	%BreadRender.load_style()
	calculate_whole_price()
	update_can_buy()

func calculate_whole_price():
	var whole_price: float = 0.0
	for object in selected_objects.values():
		if object:
			if !object.id in Vars.baguette_style_data.possesed_items:
				whole_price += object.price
	%WholePrice.text = str(int(whole_price))
	return whole_price

func _on_tab_button_1_pressed() -> void:
	switch_to_tab(0)


func _on_tab_button_2_pressed() -> void:
	switch_to_tab(1)


func _on_tab_button_3_pressed() -> void:
	switch_to_tab(2)


func _on_tab_button_4_pressed() -> void:
	switch_to_tab(3)


func _on_buy_pressed() -> void:
	if Vars.learn_points > calculate_whole_price():
		Vars.learn_points -= calculate_whole_price()
		for category in selected_objects.keys():
			var object = selected_objects[category]
			if object:
				if !object.id in Vars.baguette_style_data.possesed_items:
					Vars.baguette_style_data.possesed_items.append(object.id)
				match category:
					"hats":
						Vars.baguette_style_data.hat_id = object.id
					"shirts":
						Vars.baguette_style_data.shirt_id = object.id
					"pants":
						Vars.baguette_style_data.pants_id = object.id
					"faces":
						Vars.baguette_style_data.face_id = object.id
	Vars.save_saves()
	add_items()
	%PointCounter.change_display()
	%BreadRender.load_style()

func update_look_cursor():
	var mouse_pos = get_global_mouse_position()
	var center: Vector2 = (%Preview.global_position + %Preview.size / 2.0)
	var offset = mouse_pos - center
	var offset_adjusted = offset / 30.0
	%PreAnchor.position = %Preview.size / 2.0 + offset_adjusted
	%PreAnchor.rotation = -center.angle_to(mouse_pos) / 2.0


func _on_preview_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		update_look_cursor()
