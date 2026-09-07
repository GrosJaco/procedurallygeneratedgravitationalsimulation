extends Node2D
class_name VABManager

@export var snap_threshold: float = 15.0
@export var part_registry: Dictionary = {}

@onready var build_area: Node2D = $BuildArea
@onready var menu_container: VBoxContainer = $CanvasLayer/Panel/ScrollContainer/MenuContainer

var placed_parts: Array[ShipPart] = []
var dragged_part: ShipPart = null
var current_snap_match: Dictionary = {}

func _ready() -> void:
	_build_dynamic_menu()

func _process(_delta: float) -> void:
	if dragged_part != null:
		dragged_part.global_position = get_global_mouse_position()
		current_snap_match = find_best_snap(dragged_part, placed_parts)
		
		if current_snap_match["target_node"] != null:
			apply_snap_position(dragged_part, current_snap_match)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			if dragged_part != null:
				_place_dragged_part()
				
		elif event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			if dragged_part != null:
				print("VAB: Part trashed!")
				dragged_part.queue_free()
				dragged_part = null
				current_snap_match.clear()

func _build_dynamic_menu() -> void:
	var categories: Dictionary = {}
	
	for part_id in part_registry:
		var scene: PackedScene = part_registry[part_id]
		var temp_part: ShipPart = scene.instantiate() as ShipPart
		
		var cat: String = temp_part.part_category
		if not categories.has(cat):
			categories[cat] = [] 
			
		categories[cat].append({
			"id": part_id,
			"name": temp_part.part_name
		})
		
		temp_part.queue_free() 
		
	for cat in categories:
		var title_label = Label.new()
		title_label.text = "--- " + cat.to_upper() + " ---"
		title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		menu_container.add_child(title_label)
		
		for item in categories[cat]:
			var btn = Button.new()
			btn.text = item["name"]
			
			btn.pressed.connect(spawn_part_for_dragging.bind(item["id"]))
			menu_container.add_child(btn)

func spawn_part_for_dragging(part_id: String) -> void:
	if dragged_part != null:
		return
		
	if not part_registry.has(part_id):
		push_error("VAB: Part ID not found in registry: " + part_id)
		return
		
	var part_scene: PackedScene = part_registry[part_id]
	dragged_part = part_scene.instantiate() as ShipPart
	
	build_area.add_child(dragged_part)

func _place_dragged_part() -> void:
	if current_snap_match["target_node"] != null:
		var d_node: AttachmentNode = current_snap_match["dragged_node"]
		var t_node: AttachmentNode = current_snap_match["target_node"]
		
		d_node.connect_to(t_node, placed_parts.back())
		t_node.connect_to(d_node, dragged_part)
		print("VAB: Part snapped and locked!")
	else:
		print("VAB: Part placed freely in space.")
		
	placed_parts.append(dragged_part)
	dragged_part = null
	current_snap_match.clear()

func find_best_snap(d_part: ShipPart, p_parts: Array[ShipPart]) -> Dictionary:
	var best_match: Dictionary = {"dragged_node": null, "target_node": null, "distance": INF}
	var dragged_nodes: Array[AttachmentNode] = _get_attachment_nodes(d_part)
	
	for d_node in dragged_nodes:
		for p_part in p_parts:
			var target_nodes: Array[AttachmentNode] = _get_attachment_nodes(p_part)
			for t_node in target_nodes:
				if t_node.is_occupied: continue
					
				var dist: float = d_node.global_position.distance_to(t_node.global_position)
				if dist < snap_threshold and dist < best_match["distance"]:
					best_match["distance"] = dist
					best_match["dragged_node"] = d_node
					best_match["target_node"] = t_node
					
	return best_match

func apply_snap_position(d_part: ShipPart, match_data: Dictionary) -> void:
	var d_node: AttachmentNode = match_data["dragged_node"]
	var t_node: AttachmentNode = match_data["target_node"]
	var node_offset: Vector2 = d_node.global_position - d_part.global_position
	d_part.global_position = t_node.global_position - node_offset

func _get_attachment_nodes(part: ShipPart) -> Array[AttachmentNode]:
	var nodes: Array[AttachmentNode] = []
	for child in part.get_children():
		if child is AttachmentNode: nodes.append(child)
	return nodes

func _on_spawn_fuel_tank_pressed() -> void:
	spawn_part_for_dragging("fuel_tank")
