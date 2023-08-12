extends Node3D

@onready var grid := %PlacementGrid
@onready var defence := %Defence
@onready var buildings := %Buildings
@onready var aliens := %Aliens

var BUILDING_SCENES : Array[PackedScene] = [
	preload("res://objects/buildings/house_1.tscn"),
	preload("res://objects/buildings/house_2.tscn"),
	preload("res://objects/buildings/fuel_tank.tscn"),
]
var HEADQUARTER_SCENE := preload("res://objects/buildings/headquarters.tscn")
var TURRET1_SCENE := preload("res://objects/defence/turret_single.tscn")
var EMI_GEN_SCENE := preload("res://objects/defence/emi_tower.tscn")
var _have_hq := false


func _ready():
	if Settings.game.debug: _show_markers()


func _on_top_view_planner_quit():
	Game.quitgame()
	queue_free()

func _on_top_view_planner_start(setup):
	_create_objects(setup)
	(defence.get_child(0) as Defence).activate(true)
	$MissionPlanner.queue_free()
	$Sun.visible = true
	#TODO: $HUD.visible = true
	#TODO: $GetReady.show() # Make visible and self-destruct after time.


func _show_markers():
	var mesh := PlaneMesh.new()
	for marker in grid.get_children():
		var mesh_node := MeshInstance3D.new()
		mesh_node.mesh = mesh
		marker.add_child(mesh_node)


func _create_objects(setup: Array[MissionPlanner.W]):
	var markers := grid.get_children()
	for i in 9:
		_create_object(markers[9 + i], setup[9 + i])
		_create_object(markers[8 - i], setup[8 - i])

func _create_object(marker: Node3D, type: MissionPlanner.W):
	match type:
		MissionPlanner.W.NONE:
			_add_building(marker)
		MissionPlanner.W.TURR1:
			_add_defence(marker, TURRET1_SCENE)
		MissionPlanner.W.EMI:
			_add_defence(marker, EMI_GEN_SCENE)


func _add_defence(marker: Node3D, scene: PackedScene):
	var weapon := scene.instantiate()
	weapon.global_transform = marker.global_transform
	defence.add_child(weapon)


func _add_building(marker: Node3D) -> void:
	var scene := HEADQUARTER_SCENE if not _have_hq else BUILDING_SCENES[randi() % BUILDING_SCENES.size()]
	_have_hq = true
	var building: Building = scene.instantiate()
	building.global_transform = marker.global_transform
	building.rotate_y((randi() % 4) * PI/2)
	buildings.add_child(building)
