extends Position2D

onready var tween = $Tween

var velocity = Vector2(50, -100)
var gravity = Vector2(0, 1)
var mass = 200

var text setget set_text, get_text

func _ready():
	
	$AnimationPlayer.play("In")
	yield(get_tree().create_timer(1), "timeout")
	$AnimationPlayer.play("Out")
	yield(get_tree().create_timer(1), "timeout")
	queue_free()
	

func _process(delta: float) -> void:
	velocity += gravity * mass * delta
	position += velocity * delta
		
func set_text(new_text):
	$Label.text = str(new_text)
	
func get_text():
	return $Label.textd
