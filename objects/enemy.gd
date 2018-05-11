extends KinematicBody2D

const STATE_IDLE = 0
const STATE_MOVING = 1
const STATE_DEAD = 2

export (int) var speed = 150
export (int) var health = 10
var target = Vector2()
var velocity = Vector2()

var state = STATE_MOVING

func _ready():
	pass

func _physics_process(delta):
	if state == STATE_MOVING:
		if get_node('../player'):
			target = get_node('../player').get_transform().origin
			velocity = (target - position).normalized() * speed
			rotation = velocity.angle()
			move_and_slide(velocity)
		else:
			print('Player not found!')


func take_damage(damage):
	if damage == null:
		damage = 1
	health -= damage
	if health <= 0:
		queue_free()