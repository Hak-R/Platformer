tool
extends Area2D

export(NodePath) var gate_path

onready var node = get_node(gate_path)
onready var active = false

func _get_configuration_warning():
	var warning = "Gate Path must be assigned a gate!"
	if gate_path == "":
		return warning

func _on_body_entered(body):
	if "Girl" in body.name:
		$PressLabel.visible = true
		$AnimationPlayer.play("Bounce")
	else:
		$PressLabel.visible = false
		

func _on_body_exited(body):
	if "Girl" in body.name:
		$PressLabel.visible = false
		$AnimationPlayer.stop(true)

func _process(delta):
	if active:
		$Sprite.flip_h = true
	if !active:
		$Sprite.flip_h = false
		
func activate():
	get_tree().call_group("Gate", "gate_activation")
	if !active:
		active = true
	elif active:
		active = false
