extends Path2D

onready var follow = get_node("PathFollow2D")
onready var ghoul = $PathFollow2D/Ghoul/ghoul

var ghoul_health = 0

func _process(delta):
	ghoul_health = $PathFollow2D/Ghoul.health
	if is_instance_valid($PathFollow2D/Ghoul) == true:
		if ghoul_health > 0:
			follow.set_offset(follow.get_offset() + 150 * delta)
			if follow.get_unit_offset() > 0.5:
				ghoul.flip_h = true
			elif follow.get_unit_offset() < 0.5 or follow.get_unit_offset() > 1:
				ghoul.flip_h = false
		if ghoul_health <= 0:
			follow.set_offset(follow.get_offset() + 0 * delta)
	else:
		queue_free()
