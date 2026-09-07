extends RigidBody2D
class_name Spacecraft

var active_gravity_wells: Array[CelestialBody] = []

var command_thrust: float = 0.0
var command_rotation: float = 0.0

var total_dry_mass: float = 0.0
var attached_parts: Array[ShipPart] = []

func _ready() -> void:
	add_to_group("spacecraft")
	_initialize_modular_ship()

func _initialize_modular_ship() -> void:
	total_dry_mass = 0.0
	attached_parts.clear()
	
	for child in get_children():
		if child is ShipPart:
			attached_parts.append(child)
			total_dry_mass += child.dry_mass
			
	mass = max(total_dry_mass, 1.0) 

func receive_commands(thrust: float, rotation: float) -> void:
	command_thrust = clampf(thrust, 0.0, 1.0)
	command_rotation = clampf(rotation, -1.0, 1.0)

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	var step_delta: float = state.step
	var dominant_body: CelestialBody = get_dominant_gravity_body()
	var is_grounded: bool = state.get_contact_count() > 0
	
	var current_mass: float = 0.0
	var total_fuel: float = 0.0
	var available_tanks: Array[FuelTankPart] = []
	
	for part in attached_parts:
		current_mass += part.get_total_mass()
		if part is FuelTankPart and part.current_fuel > 0.0:
			available_tanks.append(part)
			total_fuel += part.current_fuel
			
	mass = max(current_mass, 1.0)
	
	if is_grounded and command_thrust == 0.0:
		if dominant_body != null:
			var target_velocity = dominant_body.get("current_velocity")
			if target_velocity != null:
				state.linear_velocity = target_velocity
	else:
		if dominant_body != null:
			var gravity_force: Vector2 = dominant_body.get_gravity_force(global_position, mass)
			state.apply_central_force(gravity_force)
			
	var is_engine_firing: bool = false
	
	if command_thrust > 0.0 and total_fuel > 0.0:
		var total_thrust: Vector2 = Vector2.ZERO
		var fuel_needed_this_frame: float = 0.0
		
		for part in attached_parts:
			if part is EnginePart:
				total_thrust += part.get_thrust_vector() * command_thrust
				fuel_needed_this_frame += part.fuel_consumption_rate * command_thrust * step_delta
				
		if _drain_fuel(available_tanks, fuel_needed_this_frame):
			state.apply_central_force(total_thrust.rotated(rotation))
			is_engine_firing = true 
			
	for part in attached_parts:
		if part is EnginePart:
			part.set_engine_state(command_thrust, is_engine_firing)
		
	if command_rotation != 0.0:
		var total_torque: float = 0.0
		for part in attached_parts:
			total_torque += part.get_torque() * command_rotation
			
		state.apply_torque(total_torque)

func enter_soi(body: CelestialBody) -> void:
	if not active_gravity_wells.has(body):
		active_gravity_wells.append(body)

func exit_soi(body: CelestialBody) -> void:
	active_gravity_wells.erase(body)

func get_dominant_gravity_body() -> CelestialBody:
	var i = active_gravity_wells.size() - 1
	while i >= 0:
		if not is_instance_valid(active_gravity_wells[i]):
			active_gravity_wells.remove_at(i)
		i -= 1
		
	if active_gravity_wells.is_empty():
		return null
		
	var best_body: CelestialBody = null
	var highest_priority: int = -1
	var closest_distance: float = INF
	
	for body in active_gravity_wells:
		var priority: int = 0
		
		if body.is_in_group("planets"):
			priority = 1
			
		var dist = global_position.distance_squared_to(body.global_position)
		
		if priority > highest_priority:
			highest_priority = priority
			best_body = body
			closest_distance = dist
		elif priority == highest_priority and dist < closest_distance:
			best_body = body
			closest_distance = dist
			
	return best_body

func _drain_fuel(tanks: Array[FuelTankPart], amount_needed: float) -> bool:
	if amount_needed <= 0.0: return true
	if tanks.is_empty(): return false
	
	var amount_per_tank = amount_needed / float(tanks.size())
	var remaining_to_drain = 0.0
	
	for tank in tanks:
		var consumed = tank.consume_fuel(amount_per_tank)
		remaining_to_drain += (amount_per_tank - consumed)
		
	return true
