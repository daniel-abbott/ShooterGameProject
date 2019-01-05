extends "res://scripts/ItemPickup.gd"

func _ready():
	item_stats = {
		type = "weapon", # weapon, ammo, health, treasure, key, etc.
		weapon_name = "Shotgun",
		weapon_type = "rifle", # rifle or pistol, for player sprite
		ammo_type = "shells", # bullets, shells, etc.
		ammo_cost = 1, # how much ammo is expended per shot?
		ammo_add = 8, # how much ammo is added when this weapon is picked up?
		fire_rate = 0.5,
		projectile = preload("res://objects/bullet.tscn"), # should be a PackedScene
		projectile_velocity = 30,
		beam_color = "88ff0000" # color for the player aiming beam
		}
