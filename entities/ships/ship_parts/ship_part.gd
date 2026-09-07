extends Node2D
class_name ShipPart

@export var part_name: String = "Unknown Part"
@export var part_category: String = "Uncategorized"
@export var dry_mass: float = 50.0

func _ready() -> void:
	add_to_group("ship_parts")

func get_total_mass() -> float:
	return dry_mass

func get_thrust_vector() -> Vector2:
	return Vector2.ZERO

func get_torque() -> float:
	return 0.0
