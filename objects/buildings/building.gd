class_name Building
extends StaticBody3D

@export var health = 200


func on_damage(damage: float, by_player: bool) -> void:
	health -= damage
	if health < 0:
		_on_destroyed(by_player)
		_explode()

func _on_destroyed(by_player: bool) -> void:
	Game.building_down(false, by_player)

func _explode() -> void:
	queue_free()
