extends KinematicBody2D

export (int) var speed = 110
export (float) var deadzone = 0.4
const BULLET_VELOCITY = 50

func player_movement():
	var velocity = Vector2(Input.get_joy_axis(0, JOY_ANALOG_LX), Input.get_joy_axis(0, JOY_ANALOG_LY))
	var direction = Vector2(Input.get_joy_axis(0, JOY_ANALOG_RX), Input.get_joy_axis(0, JOY_ANALOG_RY))
	
	if direction.length() > deadzone:
		look_at(direction + position)
	elif velocity.length() > deadzone && direction.length() < deadzone:
		look_at(velocity + position)
	
	# TODO: convert keyboard controls to global axis
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
		look_at(velocity + position)
	elif Input.is_action_pressed("move_left"):
		velocity.x -= 1
		look_at(velocity + position)
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
		look_at(velocity + position)
	elif Input.is_action_pressed("move_down"):
		velocity.y += 1
		look_at(velocity + position)
		
	if velocity.length() > deadzone:
		velocity = velocity.normalized() * speed
	else:
		velocity = Vector2()
	
	move_and_slide(velocity)

func player_weapon(delta):
	if Input.is_action_just_pressed("fire"):
		var bullet = preload("res://objects/bullet.tscn").instance()
		bullet.position = $AnimatedSprite/muzzle.global_position
		bullet.linear_velocity = Vector2($AnimatedSprite/muzzle.position.x * BULLET_VELOCITY, 0).rotated($AnimatedSprite/muzzle.global_rotation)
		bullet.add_collision_exception_with(self)
		get_parent().add_child(bullet)

func _physics_process(delta):
	player_movement()
	player_weapon(delta)
