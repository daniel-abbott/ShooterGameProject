# "Abstract" script for inventory pickups.

extends Area2D

# Player object will recognize "weapon" right now
var item_stats

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	connect("body_entered", self, "actor_entered", [], 0)
	connect("body_exited", self, "actor_exited", [], 0)

func actor_entered(actor):
	if actor.has_method("add_potential_pickup"):
		actor.add_potential_pickup(self)

func actor_exited(actor):
	if actor.has_method("clear_potential_pickup"):
		actor.clear_potential_pickup()

func remove():
	self.queue_free()