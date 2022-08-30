extends TextureButton

onready var touch: = get_node("/root/MobileControl")

var touch_on: Texture = preload("res://start-assets/touchscreen_buttons.png")
var touch_off: Texture = preload("res://start-assets/touchscreen_buttons_no.png")

func _ready() -> void:
	texture_normal = touch_on
	
func _on_pressed() -> void:
	if texture_normal == touch_on:
		texture_normal = touch_off
		touch.visible = false
	else:
		texture_normal = touch_on
		touch.visible = true
