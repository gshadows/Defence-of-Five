class_name AlienMother
extends Alien

@onready var model := $AlienMotherShip
@onready var shoot_point := $ShootPoint


func _ready():
	setup($PostMortemCamera)

func _process(delta: float):
	model.rotate_y(PI / 16 * delta)
	super._process(delta)

func get_shoot_point() -> Node3D:
	return shoot_point
