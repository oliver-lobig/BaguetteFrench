@tool
extends Node2D

@export var light_direction: Vector2 = Vector2(1,1).normalized()
@export var shadow_lenght: float = 20.0

@export var override_hat: int = -1
@export var override_face: int = -1
@export var override_shirt: int = -1
@export var override_pants: int = -1

@export var always_talk: bool = false

func _ready() -> void:
	load_style()
	await visibility_changed
	await get_tree().create_timer(1.0).timeout

func start_talk():
	if always_talk:
		while visible == true and always_talk == true:
			speek_text("Hallo, das ist mein Gesicht. Es sagt grade ","de",0.1,1)
			await get_tree().create_timer(5.0).timeout
	else:
		speek_text("Hallo, das ist mein Gesicht.","de",0.06,1)

func load_style():
	var hat_item: ClothingItem = Vars.baguette_shop_assortment.assortment.get(Vars.baguette_style_data.hat_id) if override_hat == -1 else Vars.baguette_shop_assortment.assortment.get(override_hat)
	if hat_item:
		if hat_item.path:
			var hat_texture = load(hat_item.path)
			%Hat.texture = hat_texture
	else:
		%Hat.texture = ImageTexture.new()
	
	var face_item: ClothingItem = Vars.baguette_shop_assortment.assortment.get(Vars.baguette_style_data.face_id) if override_face == -1 else Vars.baguette_shop_assortment.assortment.get(override_face)
	if face_item:
		if face_item.path:
			var eye_base = load(face_item.path + "/eyes.png")
			%Eyes.texture = eye_base
			var eye_pupil = load(face_item.path + "/pupil.png")
			%Pupils.texture = eye_pupil
			
			var mouth_a = load(face_item.path + "/mouth/phonetics/A.svg")
			%A.texture = mouth_a
			var mouth_e = load(face_item.path + "/mouth/phonetics/E.svg")
			%E.texture = mouth_e
			var mouth_l = load(face_item.path + "/mouth/phonetics/L.svg")
			%L.texture = mouth_l
			var mouth_m = load(face_item.path + "/mouth/phonetics/M.svg")
			%M.texture = mouth_m
			var mouth_neutral = load(face_item.path + "/mouth/phonetics/NEUTRAL.svg")
			%Neutral.texture = mouth_neutral
			var mouth_o = load(face_item.path + "/mouth/phonetics/O.svg")
			%O.texture = mouth_o
			var mouth_oo = load(face_item.path + "/mouth/phonetics/OO.svg")
			%Oo.texture = mouth_oo
			var mouth_t = load(face_item.path + "/mouth/phonetics/T.svg")
			%T.texture = mouth_t
			var mouth_th = load(face_item.path + "/mouth/phonetics/TH.svg")
			%Th.texture = mouth_th
			var mouth_v = load(face_item.path + "/mouth/phonetics/V.svg")
			%V.texture = mouth_v
	
	var shirt_item: ClothingItem = Vars.baguette_shop_assortment.assortment.get(Vars.baguette_style_data.shirt_id) if override_shirt == -1 else Vars.baguette_shop_assortment.assortment.get(override_shirt)
	if shirt_item:
		if shirt_item.path:
			var shirt_texture = load(shirt_item.path)
			%Shirt.texture = shirt_texture
	else:
		%Shirt.texture = ImageTexture.new()
	
	var pants_item: ClothingItem = Vars.baguette_shop_assortment.assortment.get(Vars.baguette_style_data.pants_id) if override_pants == -1 else Vars.baguette_shop_assortment.assortment.get(override_pants)
	if pants_item:
		if pants_item.path:
			var pants_texture = load(pants_item.path)
			%Pants.texture = pants_texture
	else:
		%Pants.texture = ImageTexture.new()
		
	update_positions()

func update_positions():
	var hat_item: ClothingItem = Vars.baguette_shop_assortment.assortment.get(Vars.baguette_style_data.hat_id) if override_hat == -1 else Vars.baguette_shop_assortment.assortment.get(override_hat)
	if hat_item:
		if hat_item.path:
			%Hat.position = hat_item.offset
			%Hat.scale = hat_item.scale
	
	var shirt_item: ClothingItem = Vars.baguette_shop_assortment.assortment.get(Vars.baguette_style_data.shirt_id) if override_shirt == -1 else Vars.baguette_shop_assortment.assortment.get(override_shirt)
	if shirt_item:
		if shirt_item.path:
			%Shirt.position = shirt_item.offset
			%Shirt.scale = shirt_item.scale
	
	var pants_item: ClothingItem = Vars.baguette_shop_assortment.assortment.get(Vars.baguette_style_data.pants_id) if override_pants == -1 else Vars.baguette_shop_assortment.assortment.get(override_pants)
	if pants_item:
		if pants_item.path:
			%Pants.position = pants_item.offset
			%Pants.scale = pants_item.scale

func _process(_delta: float) -> void:
	#%Baguette.rotation_degrees += 30 * delta
	position_shadow()

func position_shadow():
	var rotated_direction = light_direction.rotated(-%Baguette.rotation)
	%Shadow.position = rotated_direction * shadow_lenght
	
	#var scaled_direction = (rotated_direction * 0.5) + Vector2(0.5,0.5)
	
	#var dir = rotated_direction * -1 + Vector2.ONE
	#print(dir.x)
	var direction_color = Color(rotated_direction.rotated(-%Baguette.rotation).x / PI,0.0,0.0)
	
	var shader_mat: ShaderMaterial = %Highlight.material
	shader_mat.set_shader_parameter("Direction",direction_color)

func speek_text(text: String,language: String,wait_time: float = 0.1,speed: float = 1.0,disable_tts: bool = false):
	if disable_tts == false:
		SpeakHandler.tts_speak(text,50,1.0,speed,language)
	var sounds = VisualSpeech.get_sounds(text.to_lower())
	for sound in sounds:
		for m in %Mouth.get_children():
			m.hide()
		match sound:
			VisualSpeech.sounds.A:
				%A.show()
			VisualSpeech.sounds.E:
				%E.show()
			VisualSpeech.sounds.L:
				%L.show()
			VisualSpeech.sounds.M:
				%M.show()
			VisualSpeech.sounds.NEUTRAL:
				%Neutral.show()
			VisualSpeech.sounds.O:
				%O.show()
			VisualSpeech.sounds.OO:
				%Oo.show()
			VisualSpeech.sounds.T:
				%T.show()
			VisualSpeech.sounds.TH:
				%Th.show()
			VisualSpeech.sounds.V:
				%V.show()
		await get_tree().create_timer(wait_time).timeout
	for m in %Mouth.get_children():
		m.hide()
