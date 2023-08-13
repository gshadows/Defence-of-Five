class_name Alien
extends CharacterBody3D

enum Type { FIGHTER, MOTHER }

@export var type: Type
@export var speed: float
@export var health: float

var _target: Node3D


func on_damage(damage: float, by_player: bool) -> void:
	health -= damage
	if health < 0:
		_on_destroyed(by_player)
		_explode()

func _on_destroyed(by_player: bool) -> void:
	Game.enemy_down(type, by_player)

func _explode() -> void:
	queue_free()


func _physics_process(delta):
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()
