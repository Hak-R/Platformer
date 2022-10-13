extends Area2D

onready var speach_bubble = preload("res://src/Test/SpeechBubble.tscn")

func _ready():
	print(position)
	print(global_position)

func _on_body_entered(body):
	var bubble = speach_bubble.instance()
	bubble.get_node("Anchor/ColorRect/RichTextLabel").set_text("Ha")
	add_child(bubble)
