extends CelestialBody
class_name Planet

@export var semi_major_axis: float = 5000.0
@export var eccentricity: float = 0.2 
@export var orbit_angle: float = 0.0 

var my_star: Node2D = null
var current_t: float = 0.0 
var orbit_speed: float 

func _ready() -> void:
	super()
	add_to_group("planets")
	
	eccentricity = randf_range(0.01, 0.08)
	orbit_angle = randf_range(0, TAU)
	radius = randf_range(400.0, 2000.0)
	body_mass = body_mass * (radius/100)
	
	global_position = get_orbit_position(randf() * TAU)
	current_t = randf() * TAU
	orbit_speed = 500000.0 * 0/ pow(semi_major_axis, 1.5)
	
	call_deferred("_find_star")

func _find_star() -> void:
	var stars = get_tree().get_nodes_in_group("stars")
	if stars.size() > 0:
		my_star = stars[0] as Node2D
		_calculate_soi() 
		_draw_world_orbit()

func _calculate_soi() -> void:
	if not my_star or not my_star.get("body_mass"): 
		return
		
	var m: float = body_mass
	var M: float = my_star.body_mass
	var a: float = semi_major_axis
	
	var calculated_radius: float = a * pow(m / M, 0.4)
	
	if sphere_of_influence:
		var col_shape = sphere_of_influence.get_node_or_null("CollisionShape2D")
		if col_shape and col_shape.shape is CircleShape2D:
			col_shape.shape = col_shape.shape.duplicate()
			col_shape.shape.radius = calculated_radius

func get_orbit_position(t: float) -> Vector2:
	var b = semi_major_axis * sqrt(1.0 - pow(eccentricity, 2))
	var c = semi_major_axis * eccentricity
	var pos = Vector2(cos(t) * semi_major_axis, sin(t) * b)
	pos.x -= c
	return pos.rotated(orbit_angle)

func _physics_process(delta: float) -> void:
	if my_star:
		current_t += orbit_speed * delta
		var orbit_pos = get_orbit_position(current_t)
		var new_global_pos = my_star.global_position + orbit_pos
		
		current_velocity = (new_global_pos - global_position) / delta
		
		global_position = new_global_pos

func _process(_delta: float) -> void:
	if my_star:
		update_lighting(my_star.global_position)

func update_lighting(star_global_position: Vector2) -> void:
	if not color_rect or not color_rect.material: return
	var direction_to_star = (star_global_position - global_position).normalized()
	var mat = color_rect.material as ShaderMaterial
	mat.set_shader_parameter("light_direction", direction_to_star)

func _draw_world_orbit() -> void:
	var orbit_drawer = Node2D.new()
	orbit_drawer.set_as_top_level(true)
	orbit_drawer.global_position = my_star.global_position
	orbit_drawer.z_index = -10
	
	var points = PackedVector2Array()
	var steps = 128
	for i in range(steps + 1):
		var t = (float(i) / steps) * TAU
		points.append(get_orbit_position(t))
		
	orbit_drawer.draw.connect(func():
		orbit_drawer.draw_polyline(points, Color(1.0, 1.0, 1.0, 0.2), -1.0, true)
	)
	add_child(orbit_drawer)
