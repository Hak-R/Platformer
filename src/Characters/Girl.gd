extends Actor 

onready var animation_tree = $AnimationTree
onready var animation_mode = animation_tree.get("parameters/playback")

onready var cam_limit: Camera2D = get_node("Camera2D")
onready var bullet_object = preload("res://src/Objects/Bullet.tscn")
onready var shoot_timer = $ShootTimer
onready var mouse_position = Vector2.ZERO

export var stomp_impulse: = 300.0
export var bullet_speed = 600
export var fire_rate = 0.4

var health = 10
var max_health = 10
var can_fire = true
var max_jumps = 2
var jump_count = 0
var player_pos = Vector2.ZERO
var in_air: bool = false
var bullet_position = Vector2.ZERO
var can_crouch = true
var can_jump = true
var dead = false
var bullet_collision = false

func _on_EnemyDetect_area_entered(area: Area2D) -> void:
	if "Bouncer" in area.name:
		_velocity = calculate_stomp_velocity(_velocity, stomp_impulse) * 1.5
	elif "Sign" in area.name:
		_velocity = Vector2(0, 0)	
	else:
		_velocity = calculate_stomp_velocity(_velocity, stomp_impulse)

func _on_EnemyDetect_body_entered(body: Node) -> void:
	animation_tree.set("parameters/Hurt/active", 1)
	damage()

func _ready() -> void:
	dead = false
	animation_tree.set("parameters/Alive/current", 0)
	$"/root/PlayerData".player_health = health
	health = 10
	animation_tree.active = true

func _physics_process(delta: float) -> void:
	var is_jump_interrupted: = Input.is_action_just_released("jump") and _velocity.y < 0.0
	var direction: = get_direction()
	var SNAP = Vector2.DOWN if direction .y == 0.0 else Vector2.ZERO
	if can_jump == false:
		is_jump_interrupted = true
	mouse_position = get_global_mouse_position()
	_velocity = calculate_move_velocity(_velocity, direction, speed, is_jump_interrupted)
	_velocity = move_and_slide_with_snap(_velocity, SNAP, FLOOR_NORMAL, true, 4, 0.9, false)
	if Input.is_action_just_pressed("jump") and jump_count < max_jumps:
		_velocity.y = -speed.y
		jump_count += 1


	if is_on_floor():
		jump_count = 0

func _unhandled_input(event: InputEvent) -> void:
	
	if event.is_action_pressed("move_right") or event.is_action_pressed("move_left") and !dead:
		can_crouch = false
		animation_tree.set("parameters/RunStartPhase/active", 1)
		animation_tree.set("parameters/Movement/current", 1)
	if event.is_action_released("move_right") or event.is_action_released("move_left") and !dead:
		can_crouch = true
		animation_tree.set("parameters/RunStopPhase/active", 1)
		animation_tree.set("parameters/Movement/current", 0)
		
func _process(delta: float) -> void:
	player_pos = $Player.get_global_position()
	$"/root/PlayerData".player_pos = player_pos
	var direction = get_direction()
	if global_position.y > cam_limit.limit_bottom:
		die()

	if  animation_tree.get("parameters/Movement/current") == 2:
		can_jump = false
	elif animation_tree.get("parameters/Movement/current") == 0 or animation_tree.get("parameters/Movement/current") == 1:
		can_jump = true

	if direction.x == 0:
		animation_tree.set("parameters/Movement/current", 0)
		
	if can_crouch:
		if Input.is_action_pressed("crouch") and !dead:
			animation_tree.set("parameters/CrouchTransition/current", 0)
			animation_tree.set("parameters/CrouchStartPhase/active", 1)
			animation_tree.set("parameters/Movement/current", 2)
			animation_tree.set("parameters/ShootPos/current", 1)
		if Input.is_action_just_released("crouch") and !dead:
			animation_tree.set("parameters/CrouchTransition/current", 1)
			animation_tree.set("parameters/CrouchEndPhase/active", 1)
			animation_tree.set("parameters/Movement/current", 2)
			animation_tree.set("parameters/ShootPos/current", 0)
	if is_on_floor():
		animation_tree.set("parameters/in_air/current", 0)
	elif !is_on_floor():
		animation_tree.set("parameters/RunStopPhase/active", 1)
		animation_tree.set("parameters/in_air/current", 1)
		
	if Input.is_action_pressed("move_right"):
		$Player.flip_h = false
		$Legs.flip_h = false
	if Input.is_action_pressed("move_left"):
		$Player.flip_h = true
		$Legs.flip_h = true

	if Input.is_action_pressed("shoot"):
		animation_tree.set("parameters/Shoot/active", 1)

		
	if Input.is_action_pressed("shoot") and can_fire:	#SHOOTING SYSTEM
		bullet_position = $Player.position
		if !can_jump:
			bullet_position.y += 10 
		if $Player.flip_h == false:
			var bullet_shoot = bullet_object.instance()
			bullet_shoot.position = bullet_position
			bullet_shoot.apply_impulse(Vector2(),Vector2(bullet_speed, -20))
			bullet_shoot.get_node("AnimationPlayer").play("ShootBullet")
			add_child(bullet_shoot)
			can_fire = false
			yield(get_tree().create_timer(fire_rate), "timeout")
			bullet_shoot.queue_free()
			can_fire = true
		else:
			var bullet_shoot = bullet_object.instance()
			bullet_shoot.position = bullet_position
			bullet_shoot.apply_impulse(Vector2(),Vector2(-bullet_speed, -20))
			bullet_shoot.get_node("AnimationPlayer").play("ShootBullet")
			add_child(bullet_shoot)
			can_fire = false
			yield(get_tree().create_timer(fire_rate), "timeout")
			bullet_shoot.queue_free()
			can_fire = true
		

func get_direction() -> Vector2:
	return  Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
		if !dead else 0.0, 
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
	collision_layer = 0b100
	collision_mask = 0b00000000
	$EnemyDetect.collision_layer = 0b100
	$EnemyDetect.collision_mask = 0b00000000
	dead = true 
	PlayerData.death += 1
	animation_tree.set("parameters/Alive/current", 1)
	yield(get_tree().create_timer(3), "timeout")
	queue_free()

func damage() -> void:
	if health > 0:
		health -= 1
	$"/root/PlayerData".player_health = health
	if health == 0:
		die()
