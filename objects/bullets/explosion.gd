extends Node3D

var _explosive: Node3D
var _callback: Callable


func setup(parent: Node3D, explosive: Node3D, callback: Callable):
	_explosive = explosive
	_callback = callback
	name = explosive.name + "Exposion"
	global_transform = explosive.global_transform
	parent.add_child(self)


func _ready():
	get_tree().create_timer(1.5).timeout.connect(_timeout)


func _timeout():
	if _callback: _callback.call()
	_explosive.queue_free()
	queue_free()
