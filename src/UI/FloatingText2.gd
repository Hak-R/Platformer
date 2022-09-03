extends Position2D

onready var tween = $Tween

var velocity = Vector2(50, -100)
var gravity = Vector2(0, 1)
var mass = 200

var text setget set_text, get_text

func _ready():
	$FloatTimer.start()
	tween.interpolate_property(self, "modulate", Color(modulate.r, modulate.g, modulate.b, modulate.a), Color(modulate.r, modulate.g, modulate.b, 0.0), 0.3, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.7)
	
	tween.interpolate_property(self, "scale", Vector2(0, 0), Vector2(1.0, 1.0), 0.3, Tween.TRANS_QUART, Tween.EASE_OUT)
		
	tween.interpolate_property(self, "scale", Vector2(1.0, 1.0), Vector2(0.4, 0.4), 1.0, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.6)

func _process(delta: float) -> void:
	velocity += gravity * mass * delta
	position += velocity * delta
	if $FloatTimer.time_left == 0:
		queue_free()
		
func set_text(new_text):
	$Label.text = str(new_text)
	
func get_text():
	return $Label.text
