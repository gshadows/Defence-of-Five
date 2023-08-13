class_name EmiTower
extends Defence

const ROTATION_UP_LIMIT := deg_to_rad(89.0)
const ROTATION_DN_LIMIT := deg_to_rad(0.0)

@export_range(1, 1000) var strike_radius := 300

var aliens: Node


func _ready() -> void:
	prepare(%Camera3D, $RotationPoint, %Camera3D, ROTATION_UP_LIMIT, ROTATION_DN_LIMIT)

#func _process(delta: float) -> void:
#	super._process(delta) # Move camera

#func _on_activated():
#	super._on_activated()

#func _on_deactivated():
#	super._on_deactivated()

func do_shooting() -> void:
	if not Input.is_action_just_pressed("fire"): return
	super.do_shooting()


func fire() -> void:
	var square_radius := strike_radius * strike_radius
	var center := global_position
	for node in aliens.get_children():
		var alien := node as Alien
		var square_distance := alien.global_position.distance_squared_to(center)
		if square_distance < square_radius:
			var effect := 1.0 - square_distance / square_radius # 1 at center, 0 at edge
			var damage := int(bullet_damage * effect)
			alien.on_damage(damage, true)
