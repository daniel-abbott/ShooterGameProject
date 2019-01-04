extends "res://scripts/ItemPickup.gd"

func _ready():
	item_stats = {
		type = "weapon", # weapon, ammo, health, treasure, key, etc.
		weapon_name = "Autorifle",
		weapon_type = "rifle", # rifle or pistol, for player sprite
		ammo_type = "bullets", # bullets, shells, etc.
		ammo_cost = 1, # how much ammo is expended per shot?
		ammo_add = 30, # how much ammo is added when this weapon is picked up?
		fire_rate = 0.1,
		projectile = preload("res://objects/bullet.tscn"), # should be a PackedScene
		projectile_velocity = 30,
		beam_color = "88ff0000" # color for the player aiming beam
		}

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
