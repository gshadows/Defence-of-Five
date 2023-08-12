extends Defence

const ROTATION_UP_LIMIT := deg_to_rad(89.0)
const ROTATION_DN_LIMIT := deg_to_rad(0.0)


func _ready() -> void:
	prepare(%Camera3D, %Camera3D, $CameraCenter, ROTATION_UP_LIMIT, ROTATION_DN_LIMIT)


func _process(delta: float) -> void:
	super._process(delta) # Move camera


func _on_activated():
	super._on_activated()

func _on_deactivated():
	super._on_deactivated()
