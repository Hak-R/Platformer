extends Node

signal score_updated
signal player_died

var score: = 0 setget set_score
var death: = 0 setget set_death
var text_box = ""
var player_pos: = Vector2.ZERO
var player_health = 10
var max_player_health = 10


func reset() -> void:
	score = 0
	death = 0

func set_score(value_score: int) -> void:
	score = value_score
	emit_signal("score_updated")
	
	
func set_death(value_death: int) -> void:
	death = value_death
	emit_signal("player_died")
