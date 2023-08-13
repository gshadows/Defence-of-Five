class_name AlienFighter
extends Alien

@onready var model := $AlienFighter
@onready var shoot_point := $ShootPoint


func _ready():
	setup($PostMortemCamera)

func _process(delta: float):
	model.rotate_y(PI / 8 * delta)
	super._process(delta)

func get_shoot_point() -> Node3D:
	return shoot_point
