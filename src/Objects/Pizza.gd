extends Area2D

signal in_pizza

func _on_body_entered(body):
	emit_signal("in_pizza")
	
