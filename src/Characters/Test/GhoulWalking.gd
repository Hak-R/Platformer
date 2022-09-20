extends Path2D

onready var follow = get_node("PathFollow2D")
onready var ghoul = $PathFollow2D/Ghoul/ghoul
onready var ghoul_health = $PathFollow2D/Ghoul.health

func _process(delta):
	if is_instance_valid($PathFollow2D/Ghoul) == true:
		follow.set_offset(follow.get_offset() + 150 * delta)
		if follow.get_unit_offset() > 0.5:
			ghoul.flip_h = true
		elif follow.get_unit_offset() < 0.5 or follow.get_unit_offset() > 1:
			ghoul.flip_h = false
	else:
		queue_free()
