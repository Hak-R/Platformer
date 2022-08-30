extends Position2D

#onready var timer = $Timer
#
#
#const Bullet = preload("res://src/Objects/Bullet.tscn")
#const BULLET_VELOCITY = 1000
#var mouse_pos = Vector2.ZERO
#
#func shoot(direction = 1):
#	if not timer.is_stopped():
#		return false
#	var bullet = Bullet.instance()
#	mouse_pos = get_global_mouse_position()
#	bullet.global_position = global_position
#	bullet.linear_velocity = Vector2(direction * BULLET_VELOCITY, 1)
#	bullet.set_as_toplevel(true)
#	add_child(bullet)
#	print(bullet.global_position," ",global_position)
#	$Timer.start()
#	return true
