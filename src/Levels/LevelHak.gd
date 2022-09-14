extends Node2D



func _on_Girl_shoot(bullet, direction, location):
	var b = bullet.instance()
	add_child(b)
	b.rotation = direction
	b.position = location
