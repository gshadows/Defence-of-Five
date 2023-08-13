class_name LaserRay
extends RayCast3D

const MAX_LIFE_TIME := 10

@onready var _mesh := $BeamMesh
var _material = null
var _velocity: Vector3
var _damage: float
var _by_player: bool # true = player's shoot, false = alien's shoot


func setup(velocity: Vector3, damage: float, material: BaseMaterial3D, by_player: bool) -> void:
	_velocity = velocity
	_damage = damage
	_material = material
	if _mesh: _mesh.material_override = material
	_by_player = by_player

func _ready():
	if _material: _mesh.material_override = _material
	get_tree().create_timer(MAX_LIFE_TIME).timeout.connect(queue_free)


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
		if (collider is Alien) and not _by_player:
			return # Temporary cheat to prevent aliens kill themselves early before approach base :)
		print("HIT: ", collider.name)
		collider.on_damage(_damage, _by_player)
