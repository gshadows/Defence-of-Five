extends RayCast3D

@onready var _mesh := $BeamMesh
var _velocity: Vector3
var _damage: float
var _by_player: bool # true = player's shoot, false = alien's shoot


func setup(velocity: Vector3, damage: float, material: BaseMaterial3D, by_player: bool) -> void:
	_velocity = velocity
	_damage = damage
	_mesh.material_override = material
	_by_player = by_player


func _process(delta: float) -> void:
	force_raycast_update()
	if is_colliding():
		_do_damage()
		queue_free()
		return
	translate(_velocity * delta)


func _do_damage():
	var collider := get_collider()
	if (collider is Building) or (collider is Defence) or (collider is Alien):
		collider.on_damage(_damage, _by_player)
