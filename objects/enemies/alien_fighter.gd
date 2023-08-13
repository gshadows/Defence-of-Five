class_name AlienFighter
extends Alien

@onready var model := $AlienFighter


func _ready():
	setup($PostMortemCamera)

func _process(delta):
	model.rotate_y(PI / 8 * delta)
