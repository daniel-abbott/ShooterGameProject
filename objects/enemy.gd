extends KinematicBody2D

export (int) var speed = 100
var target = Vector2()
var velocity = Vector2()

func _ready():
	pass

func _process(delta):
	if get_node('../player'):
		target = get_node('../player').get_transform().origin
		velocity = (target - position).normalized() * speed
		rotation = velocity.angle()
		move_and_slide(velocity)
	else:
		print('Player not found!')

func hit_by_bullet():
	queue_free()

#func _physics_process(delta):

	