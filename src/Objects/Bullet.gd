extends RigidBody2D

func _on_body_entered(body):
	$Circle.visible = false
