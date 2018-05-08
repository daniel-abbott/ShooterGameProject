extends KinematicBody2D

export (int) var speed = 250
export (float) var deadzone = 0.4

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

func player_weapon():
	if Input.is_action_pressed("fire"):
		print("Fire button pressed!")

func _physics_process(delta):
	player_movement()
	player_weapon()
