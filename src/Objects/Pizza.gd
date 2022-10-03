extends Area2D

signal in_pizza

onready var player_health = 0
onready var player_health_max = $"/root/PlayerData".max_player_health

func _ready():
	$Tween.interpolate_property($Pizza, "modulate", null, Color(1,1,1,0), 0.1, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	

func _process(delta):
	player_health = $"/root/PlayerData".player_health
	
func _on_body_entered(body):
	if player_health < player_health_max:
		emit_signal("in_pizza")
		$Tween.start()
		yield(get_tree().create_timer(0.1), "timeout")
		queue_free()
	
func remove_pizza():
	queue_free()
