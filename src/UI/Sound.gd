extends TextureButton

onready var main_theme: = get_node("/root/MainTheme")

var sound_on: = preload("res://start-assets/sound.png")
var sound_off: = preload("res://start-assets/sound_no.png")


func _ready() -> void:
	texture_normal = sound_on


func _on_pressed() -> void:
	if texture_normal == sound_on:
		texture_normal = sound_off
		main_theme.set_volume_db(-80)
	else:
		texture_normal = sound_on
		main_theme.set_volume_db(0)
