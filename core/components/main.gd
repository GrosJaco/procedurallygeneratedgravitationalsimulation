extends Node2D

@onready var spacecraft = $Spacecraft
@onready var player_controller = $PlayerController
@export var builder: ShipBuilder

func _ready() -> void:
	player_controller.possess_entity(spacecraft)
	var test_blueprint: Dictionary = {
		"ship_name": "Apollo_Prototype",
		"parts": [
			{
				"part_id": "capsule",
				"position": Vector2(0, -32),
				"rotation": 0.0
			},
			{
				"part_id": "fuel_tank",
				"position": Vector2(0, 32),
				"rotation": 0.0
			},
			{
				"part_id": "fuel_tank",
				"position": Vector2(0, 64),
				"rotation": 0.0
			},
			{
				"part_id": "eagle_engine",
				"position": Vector2(0, 96),
				"rotation": 0.0
			}
		]
	}
	
	var my_new_ship: Spacecraft = builder.build_ship_from_blueprint(test_blueprint)
	my_new_ship.position = Vector2(100000,100000)
	$PlayerController.possess_entity(my_new_ship)
	
	if my_new_ship != null:
		my_new_ship.global_position = Vector2(0, -150000) 
		
		add_child(my_new_ship)
		print("Launch sequence initiated for: ", my_new_ship.name)
