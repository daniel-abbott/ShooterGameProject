extends RigidBody2D

func _ready():
	add_collision_exception_with(self)

func _on_bullet_body_entered(body):
		if body.has_method("hit_by_bullet"):
			body.call("hit_by_bullet")
		else:
			queue_free()
	
func _on_Timer_timeout():
	queue_free()