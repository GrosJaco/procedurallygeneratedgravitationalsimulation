extends Area2D
class_name SphereOfInfluence

@export var planet: CelestialBody

func _ready() -> void:
	if not planet:
		planet = get_parent() as CelestialBody
		if not planet:
			push_error("SphereOfInfluence: No CelestialBody parent found for ", name, "!")
			
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	if planet and body.has_method("enter_soi"):
		body.enter_soi(planet)

func _on_body_exited(body: Node2D) -> void:
	if planet and body.has_method("exit_soi"):
		body.exit_soi(planet)
