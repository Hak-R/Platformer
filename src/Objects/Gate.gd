class_name Gate
extends StaticBody2D
 
export var door_switch_id: int = 0
 
onready var col_shape: CollisionShape2D = $ChainCollision
onready var chain = $Chain
#onready var sprite_closed: Sprite = $ClosedSprite
#onready var sprite_open: Sprite = $OpenSprite
 
func trigger_switch_toggled(id: int) -> void:
	# Make sure it was the switch that is associated with this door
	if id == door_switch_id and chain.visible == true:
		chain.visible = false
		col_shape.set_deferred("disabled", true)
	elif id == door_switch_id and chain.visible == false:
		chain.visible = true
		col_shape.set_deferred("disabled", false)

func _ready() -> void:
	chain.visible = true
	find_switch(door_switch_id)
 
func find_switch(id: int) -> void:
	var _err: int = 0
	var switches = get_tree().get_nodes_in_group("Lever")
	 
	for this_switch in switches:
		if this_switch.switch_id == id:
			if this_switch.is_connected("switch_toggled", self, "trigger_switch_toggled") == false:
				_err = this_switch.connect("switch_toggled", self, "trigger_switch_toggled")
