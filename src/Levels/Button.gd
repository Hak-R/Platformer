extends Button

var float_text = preload("res://src/UI/FloatingText2.tscn")
var button_pos = rect_position

func _on_Button_pressed() -> void:
	var floaty_texty = float_text.instance()
	
	floaty_texty.position = Vector2(0, -100)
	floaty_texty.velocity = Vector2(rand_range(-50, 50), -100)
	floaty_texty.modulate = Color(rand_range(0.7, 1), rand_range(0.7, 1),  rand_range(0.7, 1), 1.0)
	
	
	var amount = randi() % 10 - 5
	floaty_texty.text = amount
	
	add_child(floaty_texty)
