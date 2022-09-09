extends Actor 

onready var cam_limit: Camera2D = get_node("Camera2D")
onready var bullet_object = preload("res://src/Objects/Bullet.tscn")
onready var shoot_timer = $ShootTimer
onready var mouse_position = Vector2.ZERO

export var stomp_impulse: = 300.0
export var bullet_speed = 600
export var fire_rate = 0.4

var can_fire = true
var max_jumps = 2
var jump_count = 0
var player_pos = Vector2.ZERO
var in_air: bool = false

func _on_EnemyDetect_area_entered(area: Area2D) -> void:
	if "Bouncer" in area.name:
		_velocity = calculate_stomp_velocity(_velocity, stomp_impulse) * 1.5
	elif "Sign" in area.name:
		_velocity = Vector2(0, 0)	
	else:
		_velocity = calculate_stomp_velocity(_velocity, stomp_impulse)
	
func _on_EnemyDetect_body_entered(body: Node) -> void:
	die()
		
		
func _physics_process(delta: float) -> void:
	var is_jump_interrupted: = Input.is_action_just_released("jump") and _velocity.y < 0.0
	var direction: = get_direction()
	var SNAP = Vector2.DOWN if direction .y == 0.0 else Vector2.ZERO
	mouse_position = get_global_mouse_position()
	_velocity = calculate_move_velocity(_velocity, direction, speed, is_jump_interrupted)
	_velocity = move_and_slide_with_snap(_velocity, SNAP, FLOOR_NORMAL, true, 4, 0.9, false)
	if Input.is_action_just_pressed("jump") and jump_count < max_jumps:
		_velocity.y = -speed.y
		jump_count += 1

	if is_on_floor():
		jump_count = 0
		
func _process(delta: float) -> void:
	player_pos = $Player.get_global_position()
	$"/root/PlayerData".player_pos = player_pos
	if global_position.y > cam_limit.limit_bottom:
		die()

	if Input.is_action_pressed("move_right"):
		$Player.flip_h = false
		$Legs.flip_h = false
	if Input.is_action_pressed("move_left"):
		$Player.flip_h = true
		$Legs.flip_h = true
	
	if is_on_floor():
		in_air = false
	else:
		in_air = true
		
	if (Input.is_action_pressed("move_right") or Input.is_action_pressed("move_left")) and in_air == false:
		$AnimationPlayer.play("Run")
	elif Input.is_action_pressed("shoot"):
		$AnimationPlayer.play("Shoot")
	elif (!Input.is_action_pressed("move_left") or !Input.is_action_pressed("move_right")) and in_air == false:
		$AnimationPlayer.play("Idle")
	else:
		$AnimationPlayer.play("Jump")
			
#
	if Input.is_action_pressed("shoot") and can_fire:
		$AnimationPlayer.play("Shoot")
		var bullet_shoot = bullet_object.instance()
		bullet_shoot.position = $Gun.get_position()
		bullet_shoot.rotation_degrees = $Gun.rotation_degrees
		bullet_shoot.apply_impulse(Vector2(),Vector2(bullet_speed, 0).rotated($Gun.rotation))
		bullet_shoot.get_node("AnimationPlayer").play("ShootBullet")
		add_child(bullet_shoot)
		can_fire = false
		yield(get_tree().create_timer(fire_rate), "timeout")
		bullet_shoot.queue_free()
		can_fire = true
		

func get_direction() -> Vector2:
	return  Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"), 
		-1.0 if Input.is_action_just_pressed("jump") and is_on_floor() else 0.0
	)

func calculate_move_velocity(
		linear_velocity: Vector2,
		direction: Vector2,
		speed: Vector2,		
		is_jump_interrupted: bool
	) -> Vector2:
	var out: = linear_velocity
	out.x = speed.x * direction.x
	out.y += gravity * get_physics_process_delta_time()
	if direction.y == -1.0:
		out.y = speed.y * direction.y
	if is_jump_interrupted:
		out.y = 0.0
	return out

func  calculate_stomp_velocity(linear_velocity: Vector2, impulse: float) -> Vector2:
	var out: = linear_velocity
	out.y = -impulse 
	return out

func die() -> void:
	PlayerData.death += 1
	queue_free()
