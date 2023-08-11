extends Node3D

var _objects = []
@onready var grid := %PlacementGrid
@onready var defence := %Defence
@onready var buildings := %Buildings
@onready var aliens := %Aliens

var BUILDING_SCENES : Array[PackedScene] = [
	preload("res://objects/buildings/house_1.glb"),
	preload("res://objects/buildings/house_2.glb"),
	preload("res://objects/buildings/fuel_tank.glb"),
]
var HEADQUARTER_SCENE := preload("res://objects/buildings/headquarters.glb")
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
	$MissionPlanner.queue_free()
	$Sun.visible = true


func _show_markers():
	var mesh := PlaneMesh.new()
	for marker in grid.get_children():
		var mesh_node := MeshInstance3D.new()
		mesh_node.mesh = mesh
		marker.add_child(mesh_node)


func _create_objects(setup: Array[MissionPlanner.W]):
	var markers := grid.get_children() as Array[Node3D]
	for i in 18:
		match setup[i]:
			MissionPlanner.W.NONE:
				_add_building(markers[i], i)
			MissionPlanner.W.TURR1:
				_add_defence(TURRET1_SCENE)
			MissionPlanner.W.EMI:
				_add_defence(EMI_GEN_SCENE)


func _add_defence(scene: PackedScene):
	var weapon := Turret
	defence.add_child(weapon)


func _add_building(marker: Node3D, index: int) -> void:
	var scene := HEADQUARTER_SCENE if not _have_hq else BUILDING_SCENES[randi() % BUILDING_SCENES.size()]
	_have_hq = true
	var building: Building = scene.instantiate()
	building.global_transform = marker.global_transform
	buildings.add_child(building)
