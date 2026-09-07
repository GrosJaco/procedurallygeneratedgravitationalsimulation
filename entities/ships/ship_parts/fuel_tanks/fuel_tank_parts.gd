extends ShipPart
class_name FuelTankPart

@export var max_fuel: float = 100.0

var current_fuel: float = 0.0

func _ready() -> void:
	super()
	current_fuel = max_fuel

func get_total_mass() -> float:
	return dry_mass + current_fuel

func consume_fuel(amount: float) -> float:
	if current_fuel >= amount:
		current_fuel -= amount
		return amount
	else:
		var available = current_fuel
		current_fuel = 0.0
		return available
