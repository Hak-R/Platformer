extends StaticBody2D

onready var gate_active = true

func _process(delta):
	if gate_active:
		$Chain.visible = true
		$ChainCollision.disabled = false
	elif not gate_active:
		$Chain.visible = false
		$ChainCollision.disabled = true
		
func gate_activation():
	if gate_active:
		gate_active = false
	elif !gate_active:
		gate_active = true
		
