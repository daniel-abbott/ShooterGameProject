extends KinematicBody2D

export (int) var speed = 110
export (float) var deadzone = 0.3
const BULLET_VELOCITY = 30
const BASE_FIRE_RATE = 0.1
var fire_rate = BASE_FIRE_RATE
var aiming = false
var beam_color = "00000000"
var firing = false
var velocity = Vector2()
var direction = Vector2()
var in_menus = false

func set_processes(value):
	set_process(value)
	set_physics_process(value)

func _ready():
	set_processes(true)
	set_process_unhandled_input(true)
	
func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel") && !event.is_echo():
		in_menus = !in_menus
		if in_menus:
			set_processes(false)
		else:
			set_processes(true)
		
func _draw():
	if aiming:
		beam_color = "88ff0000"
		draw_line($AnimatedSprite/muzzle.position, Vector2(1000, 0), beam_color, 1.5, false)
	else:
		beam_color = "00000000"

func player_movement():
	velocity = Vector2(Input.get_joy_axis(0, JOY_ANALOG_LX), Input.get_joy_axis(0, JOY_ANALOG_LY))
	direction = Vector2(Input.get_joy_axis(0, JOY_ANALOG_RX), Input.get_joy_axis(0, JOY_ANALOG_RY))
	
	if direction.length() > deadzone:
		aiming = true
		look_at(direction + position)
		$Camera2D.offset = direction * 50
	elif velocity.length() > deadzone && direction.length() < deadzone:
		aiming = false
		look_at(velocity + position)
		$Camera2D.offset = Vector2(0, 0)
	else:
		aiming = false
		$Camera2D.offset = Vector2(0, 0)
	
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
	if Input.is_action_pressed("fire"):
		fire_rate -= delta
		if fire_rate == BASE_FIRE_RATE - delta:
			var bullet = preload("res://objects/bullet.tscn").instance()
			bullet.position = $AnimatedSprite/muzzle.global_position
			bullet.linear_velocity = Vector2($AnimatedSprite/muzzle.position.x * BULLET_VELOCITY, 0).rotated($AnimatedSprite/muzzle.global_rotation)
			bullet.rotation = self.rotation
			bullet.add_collision_exception_with(self)
			get_parent().add_child(bullet)
		elif fire_rate <= 0:
			fire_rate = BASE_FIRE_RATE
	else:
		fire_rate = BASE_FIRE_RATE

func _physics_process(delta):
	update() #updates canvas drawing, in this case the laser sight
	player_movement()
	player_weapon(delta)