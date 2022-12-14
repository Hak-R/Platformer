extends "res://src/Characters/Actor.gd"
class_name BlobEnemy

export var score: = 100
export var health: = 2
export var damage: = 1

var floating_text = preload("res://src/UI/FloatingText.tscn")

func _ready() -> void:
	set_physics_process(false)
	_velocity.x = -speed.x

func _on_Stomp_body_entered(body: Node) -> void:
	score_popup()
	PlayerData.score += score
	health -= damage
	if health == 0:
		destroy()
	else:
		return
	
func _physics_process(delta: float) -> void:
	_velocity.y += gravity * delta
	if is_on_wall():
		_velocity.x *= -1.0
	_velocity.y = move_and_slide(_velocity, FLOOR_NORMAL).y

func score_popup():
	var text = floating_text.instance()
	text.amount = damage
	add_child(text)
	
func destroy():
	$enemy.queue_free()
	$CollisionPolygon2D.queue_free()
	$VisibilityEnabler2D.queue_free()
	$Stomp.queue_free()

