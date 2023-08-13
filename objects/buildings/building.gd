class_name Building
extends StaticBody3D

signal dead(node: Building)

@export var health := 200
var bullets: Node3D


func on_damage(damage: float, by_player: bool) -> void:
	health -= damage
	if health < 0:
		_on_destroyed(by_player)
		_explode()

func _on_destroyed(by_player: bool) -> void:
	Game.building_down(by_player)

func _explode() -> void:
	preload("res://objects/bullets/explosion.tscn") \
		.instantiate() \
		.setup(bullets, self, func(): dead.emit(self))
