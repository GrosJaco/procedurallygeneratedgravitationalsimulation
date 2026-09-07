extends Node
class_name ShipBuilder

@export var part_registry: Dictionary = {}

@export var spacecraft_scene: PackedScene

func build_ship_from_blueprint(blueprint: Dictionary) -> Spacecraft:
	if spacecraft_scene == null:
		push_error("ShipBuilder: Spacecraft base scene is not assigned!")
		return null
		
	var ship: Spacecraft = spacecraft_scene.instantiate() as Spacecraft
	ship.name = blueprint.get("ship_name", "Unnamed_Ship")
	
	var parts_data: Array = blueprint.get("parts", [])
	
	for part_data in parts_data:
		var part_id: String = part_data.get("part_id", "")
		
		if not part_registry.has(part_id):
			push_warning("ShipBuilder: Unknown part ID in blueprint - " + part_id)
			continue
			
		var part_scene: PackedScene = part_registry[part_id]
		var part_instance: ShipPart = part_scene.instantiate() as ShipPart
		
		part_instance.position = part_data.get("position", Vector2.ZERO)
		part_instance.rotation = part_data.get("rotation", 0.0)
		ship.add_child(part_instance)
		
	return ship
