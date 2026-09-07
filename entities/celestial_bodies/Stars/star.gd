extends CelestialBody
class_name Star

@export var star_soi_radius: float = 100000.0 
@onready var corona: Area2D = $Corona 

func _ready() -> void:
	super()
	add_to_group("stars")
	body_mass = 100000000.0 
	
	if sphere_of_influence and sphere_of_influence.has_node("CollisionShape2D"):
		var soi_shape = sphere_of_influence.get_node("CollisionShape2D")
		if soi_shape.shape is CircleShape2D:
			soi_shape.shape = soi_shape.shape.duplicate()
			soi_shape.shape.radius = star_soi_radius
			
	if corona and corona.has_node("CollisionShape2D"):
		var corona_shape = corona.get_node("CollisionShape2D")
		if corona_shape.shape is CircleShape2D:
			corona_shape.shape = corona_shape.shape.duplicate() 
			corona_shape.shape.radius = radius + 16000 

func _on_corona_body_entered(body: Node2D) -> void:
	if body is Spacecraft:
		if body.has_method("explode"):
			body.explode()
		else:
			body.queue_free()
