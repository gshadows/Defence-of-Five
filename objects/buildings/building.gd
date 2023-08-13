class_name Building
extends StaticBody3D

signal dead

@export var health := 200
var bullets: Node


func setup(_bullets: Node, _glob_trans: Transform3D):
	bullets = _bullets
	global_transform = _glob_trans
	rotate_y((randi() % 4) * PI/2)


func on_damage(damage: int, by_player: bool) -> void:
	if health <= 0: return
	health -= damage
	print(name, " damaged: hp = ", health)
	if health <= 0:
		_on_destroyed(by_player)
		_explode()

func _on_destroyed(by_player: bool) -> void:
	print(name, " DESTROYED")
	Game.building_down(by_player)

func _explode() -> void:
	preload("res://objects/bullets/explosion.tscn") \
		.instantiate() \
		.setup(bullets, self, func(): dead.emit())
