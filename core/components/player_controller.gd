extends Node
class_name PlayerController

@export var controlled_entity: Spacecraft = null
@export var player_camera: Camera2D = null
@export var player_hud: HUD = null

func _ready() -> void:
	set_process(false)
	set_physics_process(true)

func _physics_process(_delta: float) -> void:
	if controlled_entity != null:
		var thrust: float = Input.get_action_strength("ui_up")
		var rotation: float = Input.get_axis("ui_left", "ui_right")
		
		controlled_entity.receive_commands(thrust, rotation)
		
		if player_camera != null:
			player_camera.global_position = controlled_entity.global_position

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_S:
			if controlled_entity != null:
				controlled_entity.linear_velocity = Vector2.ZERO

func possess_entity(new_entity: Spacecraft) -> void:
	if controlled_entity != null:
		controlled_entity.receive_commands(0.0, 0.0)
		
	controlled_entity = new_entity
	
	if player_camera != null and new_entity != null:
		player_camera.global_position = new_entity.global_position
		
	if player_hud != null:
		player_hud.tracked_ship = new_entity
