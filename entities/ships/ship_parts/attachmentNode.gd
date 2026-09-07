extends Marker2D
class_name AttachmentNode

enum NodeType { TOP, BOTTOM, SIDE, ANY }

@export var node_type: NodeType = NodeType.ANY

var is_occupied: bool = false
var connected_part: ShipPart = null

func _ready() -> void:
	add_to_group("attachment_nodes")

func connect_to(other_node: AttachmentNode, part: ShipPart) -> void:
	is_occupied = true
	connected_part = part
	
func disconnect_node() -> void:
	is_occupied = false
	connected_part = null
