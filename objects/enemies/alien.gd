class_name Alien
extends Node

var health := 100.0


func on_damage(damage: float, by_player: bool) -> void:
	health -= damage
	if health < 0:
		on_des
		_explode()


func _explode():
	queue_free()
