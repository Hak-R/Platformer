extends Position2D

onready var label = get_node("Label")
onready var animation = get_node("AnimationPlayer")
var amount = 0

func _ready() -> void:
	label.set_text(str(amount))
