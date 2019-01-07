extends KinematicBody2D

export (int) var speed = 110
export (float) var deadzone = 0.3
var fire_rate = 0
var aiming = false
var beam_color_inactive = "00000000"
var beam_color = beam_color_inactive
# var firing = false
var velocity = Vector2()
var direction = Vector2()
var in_menus = false

var potential_pickup
var current_weapon

var current_anims = {
	idle = "Default_Idle",
	walk = "Default_Walk"
	}

var weapon_index = 0
var weapons_carried = []

var ammo_carried = {
	bullets = 0,
	shells = 0
	}

func set_processes(value):
	set_process(value)
	set_physics_process(value)

func _ready():
	set_processes(true)
	set_process_unhandled_input(true)

func _unhandled_input(event):
	get_tree().set_input_as_handled()
	if event.is_action_pressed("ui_cancel") && !event.is_echo():
		in_menus = !in_menus
		if in_menus:
			set_processes(false)
		else:
			set_processes(true)

	if event.is_action_pressed("use") && !event.is_echo():
		get_potential_pickup()

	if event.is_action_pressed("ui_up"):
		weapon_scroll("up")

	if event.is_action_pressed("ui_down"):
		weapon_scroll("down")

	if event is InputEventKey:
		if event.pressed:
			match event.scancode:
				KEY_I:
					for weapon in weapons_carried:
						print(weapon.weapon_name)

func weapon_scroll(dir):
	if weapons_carried.size() > 0:
		match dir:
			"down":
				if weapon_index < (weapons_carried.size() - 1):
					weapon_index += 1
				else:
					weapon_index = 0
			"up":
				if weapon_index <= 0:
					weapon_index = (weapons_carried.size() - 1)
				else:
					weapon_index -= 1
			_:
				pass
		equip_weapon(weapons_carried[weapon_index])
		$GUI/Container/WeaponList.select(weapon_index)

func equip_weapon(weapon):
	current_weapon = weapon
	fire_rate = current_weapon.fire_rate
	match current_weapon.weapon_type:
		"rifle":
			current_anims = {
				idle = "Rifle_Idle",
				walk = "Rifle_Walk"
				}
		"pistol":
			current_anims = {
				idle = "Pistol_Idle",
				walk = "Pistol_Walk"
				}
		_:
			current_anims = {
				idle = "Default_Idle",
				walk = "Default_Walk"
				}

func _draw():
	if aiming and current_weapon:
		beam_color = current_weapon.beam_color
		draw_line($muzzle.position, Vector2(1000, 0), beam_color, 1, true)
	else:
		beam_color = beam_color_inactive

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
		$AnimatedSprite.play(current_anims.walk)
	else:
		velocity = Vector2()
		$AnimatedSprite.play(current_anims.idle)

	move_and_slide(velocity)

func player_weapon(delta):
	if current_weapon:
		if Input.is_action_pressed("fire"):
			fire_rate -= delta
			if fire_rate == current_weapon.fire_rate - delta:
				var bullet = current_weapon.projectile.instance()
				bullet.position = $muzzle.global_position
				bullet.linear_velocity = Vector2(0, -$muzzle.position.x * current_weapon.projectile_velocity).rotated($muzzle.global_rotation)
				bullet.rotation = self.rotation
				bullet.add_collision_exception_with(self)
				get_tree().get_root().add_child(bullet)
			elif fire_rate <= 0:
				fire_rate = current_weapon.fire_rate
		else:
			fire_rate = current_weapon.fire_rate

func add_potential_pickup(pickup):
	potential_pickup = pickup

func get_potential_pickup():
	if potential_pickup:
		match potential_pickup.item_stats.type:
			"weapon":
				collect_weapon(potential_pickup.item_stats)
			"ammo":
				pass
			"health":
				pass
			"key":
				pass
			"treasure":
				pass
			_:
				pass
		potential_pickup.remove()

func clear_potential_pickup():
	potential_pickup = null

func collect_weapon(weapon):
	$GUI/Container/WeaponList.add_item(weapon.weapon_name, null, true)
	if weapons_carried.size() < 1:
		weapons_carried.append(weapon)
		equip_weapon(weapons_carried[0])
		$GUI/Container/WeaponList.select(0)
	else:
		weapons_carried.append(weapon)

func _physics_process(delta):
	update() #updates canvas drawing, in this case the laser sight
	player_movement()
	player_weapon(delta)