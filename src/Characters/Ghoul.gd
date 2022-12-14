extends "res://src/Characters/Actor.gd"
class_name Ghoul

onready var playerr_pos = Vector2.ZERO
onready var health_bar = $ghoul/HealthBar

export var score: = 100
export var bullet_speed = 1000
export var fire_rate = 0.4
export var health: = 10
export var damage = [1,2]


var bullet_object = preload("res://src/Objects/BulletEnemy.tscn")
var floating_text2 = preload("res://src/UI/FloatingText2.tscn")
var can_fire = true
var damage_done = 0
var new_max_health = 0

func _ready() -> void:
	set_physics_process(false)
	_velocity.x = -speed.x
	health_bar.max_value = health
	new_max_health = health
	health_bar.visible = false

	
func _on_Stomp_body_entered(body: Node) -> void:
	score_popup()
	PlayerData.score += score
	health -= damage_done
	if health <= 0:
		destroy()
	else:
		return
	
func _physics_process(delta: float) -> void:
	_velocity.y += gravity * delta
	if is_on_wall():
		_velocity.x *= -1.0

func _process(delta: float) -> void:
	health_bar.value = health
	if health < health / 2:
		health_bar.tint_progress = Color(0.984314, 0, 0)
	damage_done = damage[randi() % 2]
	
	if health != new_max_health:
		$ghoul/HealthBar/Tween.interpolate_property($ghoul/HealthBar, "visible", true, false, 3, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
		$ghoul/HealthBar/Tween.start()
		new_max_health = health
	
	
	playerr_pos = $"/root/PlayerData".player_pos
		
	if playerr_pos.x < global_position.x:
		$ghoul.flip_h = true
		$CollisionPolygon2D.scale.x = 1.0
		$Stomp.scale.x = 1.0
	elif playerr_pos.x > global_position.x:
		$ghoul.flip_h = false
		$CollisionPolygon2D.scale.x = -1.0
		$Stomp.scale.x = -1.0
		
	if $ShootTimer.time_left == 0:
		$ShootTimer.start(1.5)
		var bullet_shoot = bullet_object.instance()
		bullet_shoot.position = $ghoul.get_position()
		if playerr_pos.x < global_position.x:
			bullet_shoot.apply_impulse(Vector2(),Vector2(-bullet_speed, 0))
		elif playerr_pos.x > global_position.x:
			bullet_shoot.apply_impulse(Vector2(),Vector2(bullet_speed, 0))
		bullet_shoot.get_node("AnimationPlayer").play("ShootBullet")
		add_child(bullet_shoot)
		can_fire = false
		yield(get_tree().create_timer(fire_rate), "timeout")
		can_fire = true
		
	
func score_popup():
	if health != 0:
		var floaty_texty = floating_text2.instance()
		floaty_texty.position = Vector2(0, -100)
		floaty_texty.velocity = Vector2(rand_range(-50, 50), -100)
		floaty_texty.modulate = Color(rand_range(0.7, 1), rand_range(0.7, 1),  rand_range(0.7, 1), 1.0)
		floaty_texty.text = damage_done
		add_child(floaty_texty)
	
func destroy():
	queue_free()
	
