extends ShipPart
class_name EnginePart

@export var engine_thrust: float = 500.0
@export var fuel_consumption_rate: float = 10.0
@export var engine_flame: GPUParticles2D = null

func get_thrust_vector() -> Vector2:
	return (Vector2.UP * engine_thrust).rotated(rotation)

func set_engine_state(throttle: float, is_firing: bool) -> void:
	if engine_flame != null:
		engine_flame.emitting = is_firing and (throttle > 0.0)
		
		if engine_flame.emitting:
			engine_flame.amount_ratio = throttle
