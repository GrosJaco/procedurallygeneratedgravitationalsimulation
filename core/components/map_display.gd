extends Control

@export var map_scale: float = 0.0005
@export var planet_icon_size: float = 4.0
@export var star_icon_size: float = 8.0

func _process(_delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	var map_center = get_viewport_rect().size / 2.0
	
	var stars = get_tree().get_nodes_in_group("stars")
	if stars.is_empty(): return
	var star = stars[0]
	
	draw_circle(map_center, star_icon_size, Color.WHITE)
	
	var planets = get_tree().get_nodes_in_group("planets")
	
	for planet in planets:
		if planet is Node2D:

			if planet.has_method("get_orbit_position"):
				var points = PackedVector2Array()
				var steps = 64
				
				for i in range(steps + 1):
					var t = (float(i) / steps) * TAU
					var pos_in_space = planet.get_orbit_position(t)
					var pos_on_map = map_center + (pos_in_space * map_scale)
					points.append(pos_on_map)
				
				draw_polyline(points, Color(1, 1, 1, 0.2), 1.5, true)
			
			var relative_pos = planet.global_position - star.global_position
			var map_pos = map_center + (relative_pos * map_scale)
			
			draw_circle(map_pos, planet_icon_size, Color.WHITE)
	
	var spacecrafts = get_tree().get_nodes_in_group("spacecraft") 
	if not spacecrafts.is_empty():
		var ship = spacecrafts[0]
		var ship_rel_pos = ship.global_position - star.global_position
		var ship_map_pos = map_center + (ship_rel_pos * map_scale)
		draw_circle(ship_map_pos, 2.0, Color.RED)
