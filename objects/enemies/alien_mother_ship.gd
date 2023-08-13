class_name AlienMother
extends Alien

@onready var model := $AlienMotherShip


func _ready():
	setup($PostMortemCamera)

func _process(delta):
	model.rotate_y(PI / 16 * delta)
