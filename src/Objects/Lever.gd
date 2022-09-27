class_name Lever
extends Area2D
 
signal switch_toggled(switch_id)
 
export var switch_id: int = 0 setget , get_switch_id
 
var _state: bool = false
 
onready var sprite_off: Sprite = $SwitchSprite_OFF
onready var sprite_on: Sprite = $SwitchSprite_ON
 
func get_switch_id() -> int:
	return switch_id

func _ready() -> void:
	sprite_off.visible = true
	sprite_on.visible = false
	_state = false

func _on_body_entered(body):
	if body.name == "Girl":
		$PressLabel.visible = true
		$AnimationPlayer.play("Bounce")
		
func _on_body_exited(body):
	if body.name == "Girl":
		$PressLabel.visible = false
		$AnimationPlayer.stop(true)
	
func gate_activation():
	if _state == false:
		sprite_off.visible = false
		sprite_on.visible = true
		_state = true
		emit_signal("switch_toggled", switch_id)
	elif _state == true:
		sprite_off.visible = true
		sprite_on.visible = false
		_state = false
		emit_signal("switch_toggled", switch_id)

