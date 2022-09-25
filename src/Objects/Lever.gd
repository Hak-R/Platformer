extends Area2D

onready var active = false

func _on_body_entered(body):
	if "Girl" in body.name:
		active = true
		$PressLabel.visible = true
		$AnimationPlayer.play("Bounce")
	else:
		$PressLabel.visible = false
		

func _on_body_exited(body):
	if "Girl" in body.name:
		active = false
		$PressLabel.visible = false
		$AnimationPlayer.stop(true)

func _process(delta):
	if active:
		$Sprite.flip_h = true
	if !active:
		$Sprite.flip_h = false
		
func activate():
	print("yes")
