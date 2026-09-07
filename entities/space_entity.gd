extends RigidBody2D
class_name SpaceEntity

@export var max_structure_integrity: float = 100.0

var current_integrity: float

func _ready() -> void:
	current_integrity = max_structure_integrity
	
	gravity_scale = 0.0
	linear_damp_mode = RigidBody2D.DAMP_MODE_REPLACE
	linear_damp = 0.0
	angular_damp_mode = RigidBody2D.DAMP_MODE_REPLACE
	angular_damp = 0.0

func take_damage(amount: float) -> void:
	current_integrity -= amount
	
	if current_integrity <= 0:
		_destroy_entity()

func _destroy_entity() -> void:
	queue_free()
