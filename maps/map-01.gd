extends Node3D

var _objects = []
@onready var grid := %PlacementGrid
@onready var defence := %Defence
@onready var buildings := %Buildings
@onready var aliens := %Aliens

func _ready():
	if Settings.game.debug: _show_markers()


func _on_top_view_planner_quit():
	Game.quitgame()
	queue_free()

func _on_top_view_planner_start(setup):
	_create_defence(setup)
	_create_buildings(setup)
	$MissionPlanner.queue_free()
	$Sun.visible = true


func _show_markers():
	var mesh := PlaneMesh.new()
	for marker in grid.get_children():
		var mesh_node := MeshInstance3D.new()
		mesh_node.mesh = mesh
		marker.add_child(mesh_node)

func _create_defence(setup: Array[MissionPlanner.W]):
	var merkers := grid.get_children() as Array[Node3D]
	for i in 18:
		if setup[i] == MissionPlanner.W.NONE: continue
	#var weapon := Turret
	#defence.add_child(weapon)

func _create_buildings(setup):
	pass

