extends Path2D

onready var follow = get_node("PathFollow2D")

func _ready():
	print(follow.get_unit_offset())

func _process(delta):
	if follow.get_unit_offset() < 1:
		follow.set_offset(follow.get_offset() + 150 * delta)
		print(follow.get_offset())
