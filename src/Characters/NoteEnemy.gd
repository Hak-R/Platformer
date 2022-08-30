extends "res://src/Characters/Actor.gd"
class_name NoteEnemy

onready var playerr_pos = Vector2.ZERO

export var score: = 100
export var bullet_speed = 2000
export var fire_rate = 0.4

var bullet_object = preload("res://src/Objects/BulletEnemy.tscn")
var floating_text = preload("res://src/UI/FloatingText.tscn")
var can_fire = true

func _ready() -> void:
	set_physics_process(false)
	_velocity.x = -speed.x
	
func _on_Stomp_body_entered(body: Node) -> void:
	score_popup()
	PlayerData.score += score
	destroy()
	
func _physics_process(delta: float) -> void:
	_velocity.y += gravity * delta
	if is_on_wall():
		_velocity.x *= -1.0

func _process(delta: float) -> void:
	playerr_pos = $"/root/PlayerData".player_pos
	if playerr_pos.x - global_position.x > 0:
		$enemy.scale.x = -1.0
	else:
		$enemy.scale.x = 1.0
	if $ShootTimer.time_left == 0:
		$ShootTimer.start(1.5)
		var bullet_shoot = bullet_object.instance()
		bullet_shoot.position = $enemy.get_position()
		if playerr_pos.x - global_position.x > 0:
			bullet_shoot.apply_impulse(Vector2(),Vector2(bullet_speed, 0))
		else:
			bullet_shoot.apply_impulse(Vector2(),Vector2(-bullet_speed, 0))
		bullet_shoot.get_node("AnimationPlayer").play("ShootBullet")
		add_child(bullet_shoot)
		can_fire = false
		yield(get_tree().create_timer(fire_rate), "timeout")
		bullet_shoot.queue_free()
		can_fire = true
		
func score_popup():
	var text = floating_text.instance()
	text.amount = score
	add_child(text)
	
func destroy():
	$enemy.queue_free()
	$CollisionPolygon2D.queue_free()
	$VisibilityEnabler2D.queue_free()
	$Stomp.queue_free()

