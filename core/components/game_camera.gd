extends Camera2D
class_name GameCamera

@onready var system_map = $"../SystemMap"

@export_group("Following")
@export var target: Node2D
@export var follow_speed: float = 5.0
@export var look_ahead_factor: float = 0.2

@export_group("Zoom")
@export var zoom_speed: float = 15.0
@export var min_zoom: float = 0.0005
@export var max_zoom: float = 2.0
@export var zoom_step: float = 0.15

@export_group("Shake")
@export var shake_decay: float = 0.8
@export var max_offset: Vector2 = Vector2(50, 50)
@export var max_roll: float = 0.1

var _target_zoom: float = 1.0
var _trauma: float = 0.0
var _trauma_power: int = 2

func _ready() -> void:
	_target_zoom = zoom.x
	if target:
		global_position = target.global_position

func _process(delta: float) -> void:
	_handle_zoom(delta)
	_handle_follow(delta)
	
	if _trauma > 0:
		_handle_shake(delta)

func add_trauma(amount: float) -> void:
	_trauma = clamp(_trauma + amount, 0.0, 1.0)

func _handle_follow(delta: float) -> void:
	if not target:
		return
	
	var target_pos: Vector2 = target.global_position
	
	if target is RigidBody2D:
		target_pos += target.linear_velocity * look_ahead_factor
	
	global_position = global_position.lerp(target_pos, follow_speed * delta)

func _handle_zoom(delta: float) -> void:
	var zoom_v: float = lerp(zoom.x, _target_zoom, zoom_speed * delta)
	zoom = Vector2(zoom_v, zoom_v)

func _handle_shake(delta: float) -> void:
	var shake_amount: float = pow(_trauma, _trauma_power)
	
	rotation = max_roll * shake_amount * randf_range(-1, 1)
	offset.x = max_offset.x * shake_amount * randf_range(-1, 1)
	offset.y = max_offset.y * shake_amount * randf_range(-1, 1)
	
	_trauma = max(_trauma - shake_decay * delta, 0.0)
	
	if _trauma <= 0:
		offset = Vector2.ZERO
		rotation = 0

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			var zoom_factor: float = 1.0 + zoom_step 
			
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				_target_zoom = clamp(_target_zoom * zoom_factor, min_zoom, max_zoom)
			elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				_target_zoom = clamp(_target_zoom / zoom_factor, min_zoom, max_zoom)
				
	if event.is_action_pressed("open_map"): 
		system_map.visible = !system_map.visible
