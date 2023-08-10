extends Node3D


var _objects = []


func _on_top_view_planner_quit():
	Game.quitgame()
	queue_free()

func _on_top_view_planner_start(setup):
	$MissionPlanner.queue_free()
	$Sun.visible = true
	_create_objects(setup)


func _create_objects(setup):
	pass

