extends ShipPart
class_name ControlPart

@export var reaction_torque: float = 20000.0

func get_torque() -> float:
	return reaction_torque
