extends Alien

@onready var model := $AlienMotherShip


func _process(delta):
	model.rotate_y(PI / 16 * delta)
