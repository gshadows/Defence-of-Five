extends Defence

const ROTATION_UP_LIMIT := deg_to_rad(68.0)
const ROTATION_DN_LIMIT := deg_to_rad(-28.0)
@onready var shoot_point := $RotationPoint/Turret/ShootPoint


func _ready() -> void:
	prepare(%Camera3D, $RotationPoint, $RotationPoint/Turret, ROTATION_UP_LIMIT, ROTATION_DN_LIMIT)


func _process(delta: float) -> void:
	super._process(delta) # Move camera


func _on_activated():
	super._on_activated()

func _on_deactivated():
	super._on_deactivated()

func get_shoot_point() -> Node3D:
	return shoot_point
