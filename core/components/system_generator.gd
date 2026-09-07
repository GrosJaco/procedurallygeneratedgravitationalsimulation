extends Node2D

@export var planet_scene: PackedScene
@export var star_scene: PackedScene
@export var min_distance: float = 120000.0
@export var distance_step: float = 75000.0 
@export var nb_planets: int = 6

func _ready():
	generate_system()

func generate_system():
	if star_scene:
		var sun = star_scene.instantiate()
		sun.global_position = Vector2.ZERO
		add_child(sun)
		
	var current_distance = min_distance
	
	if planet_scene:
		for i in range(nb_planets):
			var planet = planet_scene.instantiate()
			
			planet.semi_major_axis = current_distance
			
			add_child(planet)
			planet.add_to_group("planets")
			
			current_distance += distance_step + randf_range(-1000, 1000)
