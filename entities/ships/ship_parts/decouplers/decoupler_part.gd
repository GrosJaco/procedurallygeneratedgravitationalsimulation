extends ShipPart
class_name DecouplerPart

@export var separation_force: float = 200.0

var has_been_activated: bool = false

func _ready() -> void:
	super()
	
func activate_decoupler() -> void:
	if has_been_activated:
		return
		
	has_been_activated = true
	call_deferred("_perform_separation")

func _perform_separation() -> void:
	pass
