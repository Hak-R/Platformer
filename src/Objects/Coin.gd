extends Area2D

var floating_text = preload("res://src/UI/FloatingText.tscn")

onready var anim_player: AnimationPlayer = get_node("AnimationPlayer")

export var score: = 100

func _ready() -> void:
	pass

func _on_body_entered(body: Node) -> void:
	picked()
	score_popup()

func picked() -> void:
	PlayerData.score += score
	anim_player.play("fade_out")

func score_popup():
	var text = floating_text.instance()
	text.amount = score
	add_child(text)
