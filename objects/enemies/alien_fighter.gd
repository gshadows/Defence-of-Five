extends Alien

@onready var model := $AlienFighter


func _process(delta):
	model.rotate_y(PI / 8 * delta)
