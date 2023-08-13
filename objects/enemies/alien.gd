class_name Alien
extends CharacterBody3D

signal dead(node: Alien)

enum Type { FIGHTER, MOTHER }

@export var type: Type
@export var speed := 5.0
@export var health := 100
@export var attack_distance := 200.0

@export var fire_delay := 1.0
@export var bullet_damage := 10
@export var bullet_scene: PackedScene
@export var bullet_speed := 10.0
@export var bullet_material: BaseMaterial3D

var bullets: Node
var defence: Node
var buildings: Node

var _post_mortem_cam: Camera3D		# If all player's weapons destroyed, random alien ship camera activated.

var path: Path3D
var _path_len: float
var _path_offset := -1e6
var _formation_offeset: Vector3

var _attack_target = null
var _next_fire := 0.0


func setup(post_mortem_cam: Camera3D):
	_post_mortem_cam = post_mortem_cam


func on_damage(damage: int, by_player: bool) -> void:
	if health <= 0: return
	health -= damage
	print(name, " damaged: hp = ", health)
	if health <= 0:
		_on_destroyed(by_player)
		_explode()

func _on_destroyed(by_player: bool) -> void:
	print(name, " DESTROYED")
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


func _process(delta: float) -> void:
	_follow_path(delta)
	_shooting()


func _follow_path(delta: float):
	if _path_offset < 0:
		_path_offset = 0
		var p1 := path.curve.get_point_position(0)
		_path_len = path.curve.get_baked_length()
		_formation_offeset = position # To keep battle formation.
	
	_path_offset += delta * speed
	if _path_offset > _path_len:
		_path_offset -= _path_len
	global_position = path.curve.sample_baked(_path_offset, true) + _formation_offeset


func _shooting():
	if not _attack_target:
		if not _select_target():
			return
	var time = Time.get_ticks_msec()
	if time < _next_fire:
		return
	_next_fire = time + fire_delay
	fire()


func get_shoot_point() -> Node3D: return self # To be overridden.

func fire():
	var bullet: LaserRay = bullet_scene.instantiate()
	bullets.add_child(bullet)
	var shoot_point := get_shoot_point()
	bullet.global_transform = shoot_point.global_transform
	var velocity := Vector3(0, bullet_speed, 0)
	bullet.setup(velocity, bullet_damage, bullet_material, false)



func _select_target() -> bool:
	var bc = buildings.get_child_count()
	var dc = defence.get_child_count()
	if (bc < 1) and (dc < 1):
		return false
	var grp
	var count
	if (bc > 0) and (dc > 0):
		if randi() % 100 >= 50:
			grp = buildings
			count = bc
		else:
			grp = defence
			count = dc
	elif (bc > 0):
		grp = buildings
		count = bc
	else:
		grp = defence
		count = dc
	_attack_target = grp.get_child(randi() % count)
	return true
