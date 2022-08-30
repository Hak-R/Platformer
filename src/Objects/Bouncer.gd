extends Area2D

onready var animation: AnimationPlayer = get_node("BounceAnimation")

var floating_text = preload("res://src/UI/FloatingText.tscn")

func _on_Bouncer_body_entered(body: Node) -> void:
	animation.play("Bounce")
	bounce_popup()

func bounce_popup():
	var text = floating_text.instance()
	text.amount = "bounce"
	text.get_node("Kapow").visible = true
	add_child(text)
