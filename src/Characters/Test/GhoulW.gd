extends "res://src/Characters/Actor.gd"
class_name GhoulW

onready var playerr_pos = Vector2.ZERO
onready var health_bar = $ghoul/HealthBar
onready var animation_ghoul = get_parent().get_parent().get_node("AnimationPlayer")


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
	if health > 0:
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
	
	if health != new_max_health:
		$ghoul/HealthBar/Tween.interpolate_property($ghoul/HealthBar, "visible", true, false, 3, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
		$ghoul/HealthBar/Tween.start()
		new_max_health = health
	
	if health <= $ghoul/HealthBar.max_value / 2:
		$ghoul/HealthBar/Tween.interpolate_property(
			$ghoul/HealthBar,
			"tint_progress",
			Color(0.984314, 0, 0, 1),
			Color(0.129412, 0.784314, 0.035294, 1),
			3,
			Tween.TRANS_LINEAR,
			Tween.EASE_IN
			)
		$ghoul/HealthBar/Tween.start()
	damage_done = damage[randi() % 2]
	
	
	playerr_pos = $"/root/PlayerData".player_pos
		
	if playerr_pos.x < global_position.x:
		$CollisionPolygon2D.scale.x = 1.0
		$Stomp.scale.x = 1.0
	elif playerr_pos.x > global_position.x:
		$CollisionPolygon2D.scale.x = -1.0
		$Stomp.scale.x = -1.0
	
func score_popup():
	var floaty_texty = floating_text2.instance()
	floaty_texty.position = Vector2(-200, -100)
	floaty_texty.velocity = Vector2(rand_range(-50, 50), -100)
	floaty_texty.modulate = Color(rand_range(0.7, 1), rand_range(0.7, 1),  rand_range(0.7, 1), 1.0)
	
	floaty_texty.text = damage_done
	add_child(floaty_texty)
	
func destroy():
	collision_layer = 0b00
	collision_mask = 0b0000000
	$Stomp.collision_layer = 0b00
	$Stomp.collision_mask = 0b0000000
	animation_ghoul.play("Death")
	yield(get_tree().create_timer(1.0), "timeout")
	$ghoul.visible = false
