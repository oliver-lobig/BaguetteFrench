@tool
extends Node

var voice_de
var voice_fr

func _ready() -> void:
	if DisplayServer.tts_get_voices_for_language("de"):
		voice_de = DisplayServer.tts_get_voices_for_language("de")[0]
	if DisplayServer.tts_get_voices_for_language("fr"):
		voice_fr = DisplayServer.tts_get_voices_for_language("fr")[0]

func tts_speak(text: String = "", volume: int = 50, pitch: float = 1.0, rate: float = 1.0,language: String = "de",id: int = 0):
	if voice_de if language == "de" else voice_fr:
		DisplayServer.tts_speak(text,voice_de if language == "de" else voice_fr,volume,pitch,rate,id)

func set_callback(event: int, callable: Callable):
	DisplayServer.tts_set_utterance_callback(event,callable)
