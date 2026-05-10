extends Resource
class_name SettingsData

# Language

@export var language: String = "none"

# Learn Settings

@export var to_french: bool = true
@export var flip_after_half: bool = false

# Jewel Particles

@export var activate_jewel_particles: bool = true
@export var jewel_size: float = 1.0
@export var jewel_volume: float = 0.0

# Visuals

@export var current_theme_path: String = "res://assets/learn_scene_theme.tres"
@export var use_camera_shake: bool = true

# Dictionary

@export var dictionary_from_selection: bool = false
