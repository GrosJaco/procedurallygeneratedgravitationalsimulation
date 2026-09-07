extends AnimatableBody2D
class_name CelestialBody

@onready var color_rect: ColorRect = $ColorRect
@onready var sphere_of_influence: Area2D = $SphereOfInfluence

@export var body_mass: float = 1000000.0 
@export var radius: float = 1000.0

var gravity_constant: float = 6000.0 
var current_velocity: Vector2 = Vector2.ZERO

func _ready() -> void:
	if color_rect:
		color_rect.size = Vector2(radius * 2, radius * 2)
		color_rect.position = -color_rect.size / 2.0
		var mat = color_rect.material as ShaderMaterial
		if mat:
			mat.set_shader_parameter("rect_size", color_rect.size.x) 
	
	var collision = get_node_or_null("CollisionShape2D")
	if collision and collision.shape is CircleShape2D:
		collision.shape = collision.shape.duplicate()
		collision.shape.radius = radius

func get_gravity_force(target_global_position: Vector2, target_mass: float) -> Vector2:
	var direction: Vector2 = global_position - target_global_position
	var distance_squared: float = direction.length_squared()
	
	if distance_squared < 1.0:
		return Vector2.ZERO
		
	var force_magnitude: float = gravity_constant * (body_mass * target_mass) / distance_squared
	return direction.normalized() * force_magnitude
