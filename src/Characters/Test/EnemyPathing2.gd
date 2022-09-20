extends Path2D

onready var follow = get_node("PathFollow2D")

func _ready():
	print(follow.get_unit_offset())

func _process(delta):
	follow.set_offset(follow.get_offset() + 150 * delta)
	if follow.get_unit_offset() > 0.5:
		$PathFollow2D/ghoul.flip_h = true
	elif follow.get_unit_offset() < 0.5 or follow.get_unit_offset() > 1:
		$PathFollow2D/ghoul.flip_h = false
