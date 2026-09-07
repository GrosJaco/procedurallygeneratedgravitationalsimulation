extends CanvasLayer
class_name HUD

@export var tracked_ship: Spacecraft = null

@onready var body_label: Label = $MarginContainer/VBoxContainer/BodyLabel
@onready var altitude_label: Label = $MarginContainer/VBoxContainer/AltitudeLabel
@onready var relative_speed_label: Label = $MarginContainer/VBoxContainer/RelativeSpeedLabel
@onready var XY_speed_label: Label = $MarginContainer/VBoxContainer/XYSpeedLabel

func _process(_delta: float) -> void:
	if not is_instance_valid(tracked_ship):
		_clear_displays()
		return
		
	var dominant_body: CelestialBody = tracked_ship.get_dominant_gravity_body()
	
	if dominant_body:
		body_label.text = "Influence: " + dominant_body.name
		
		var distance: float = tracked_ship.global_position.distance_to(dominant_body.global_position)
		var altitude: float = distance - dominant_body.radius
		altitude_label.text = "Altitude: " + str(round(altitude)) + " m"
		
		var relative_velocity: Vector2 = tracked_ship.linear_velocity - dominant_body.current_velocity
		var speed: float = relative_velocity.length()
		relative_speed_label.text = "Rel. Speed: " + str(round(speed)) + " m/s"
		
	else:
		body_label.text = "Influence: Deep Space"
		altitude_label.text = "Altitude: N/A"
		
		var absolute_speed: float = tracked_ship.linear_velocity.length()
		relative_speed_label.text = "Abs. Speed: " + str(round(absolute_speed)) + " m/s"
	
	XY_speed_label.text = "XY Speed: " + str(tracked_ship.linear_velocity)

func _clear_displays() -> void:
	body_label.text = "No Ship Signal"
	altitude_label.text = ""
	relative_speed_label.text = ""
	XY_speed_label.text = ""
