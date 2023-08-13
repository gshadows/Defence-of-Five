class_name Alien
extends CharacterBody3D

signal dead(node: Alien)

enum Type { FIGHTER, MOTHER }

@export var type: Type
@export var speed := 5.0
@export var health := 100

@export var fire_delay := 1.0
@export var bullet_damage := 10
@export var bullet_scene: PackedScene
@export var bullet_speed := 10.0
@export var bullet_material: BaseMaterial3D
var bullets: Node

var _fly_target: Node3D				# Waypoint we're flying to. It always must be defined.
var _attack_target: Node3D = self	# Who we attacking. Self = nobody.
var _post_mortem_cam: Camera3D		# If all player's weapons destroyed, random alien ship camera activated.


func setup(post_mortem_cam: Camera3D):
	_post_mortem_cam = post_mortem_cam


func on_damage(damage: float, by_player: bool) -> void:
	health -= damage
	if health < 0:
		_on_destroyed(by_player)
		_explode()

func _on_destroyed(by_player: bool) -> void:
	Game.enemy_down(type, by_player)

func _explode() -> void:
	preload("res://objects/bullets/explosion.tscn") \
		.instantiate() \
		.setup(bullets, self, func(): dead.emit(self))

func post_mortem_show():
	_post_mortem_cam.visible = true
	_post_mortem_cam.current = true
	var ui = _post_mortem_cam.get_node_or_null("AlienUI")
	if ui: ui.visible = true

