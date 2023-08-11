extends Defence


func _ready() -> void:
	prepare(%Camera3D)


func _process(delta: float) -> void:
	super._process(delta) # Move camera
	pass
