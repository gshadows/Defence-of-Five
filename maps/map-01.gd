extends Node3D

@onready var grid := %PlacementGrid
@onready var defence := %Defence
@onready var buildings := %Buildings
@onready var aliens := %Aliens
@onready var bullets := %Bullets
@onready var wavegen := %AttackWaveGen
@onready var waypoints := %WayPoints

var BUILDING_SCENES : Array[PackedScene] = [
	preload("res://objects/buildings/house_1.tscn"),
	preload("res://objects/buildings/house_2.tscn"),
	preload("res://objects/buildings/fuel_tank.tscn"),
]
var HEADQUARTER_SCENE := preload("res://objects/buildings/headquarters.tscn")
var TURRET1_SCENE := preload("res://objects/defence/turret_single.tscn")
var EMI_GEN_SCENE := preload("res://objects/defence/emi_tower.tscn")
var _have_hq := false
var _current: Defence


func _ready():
	if Settings.game.debug: _show_markers()


func _on_top_view_planner_quit():
	Game.quitgame()
	queue_free()

func _on_top_view_planner_start(setup):
	_create_objects(setup)
	_sort_defence_by_pos()
	_generate_wave()
	_current = defence.get_child(0) as Defence
	_current.activate(true)
	$MissionPlanner.queue_free()
	$Sun.visible = true
	#TODO: $HUD.visible = true
	#TODO: $GetReady.show() # Make visible and self-destruct after time.
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _sort_defence_by_pos():
	var sorted := defence.get_children()
	sorted.sort_custom(_compare)
	for node in defence.get_children(): defence.remove_child(node)
	for node in sorted: defence.add_child(node)

func _compare(a: Defence, b: Defence) -> bool:
	var pa := a.global_position
	var pb := b.global_position
	var dx := pb.x - pa.x
	var dz := pb.z - pa.z
	var res := (dz > dx) or ((absf(dz) < absf(dx)) and (dx > 0))
	return res

func _show_markers():
	var mesh := PlaneMesh.new()
	for marker in grid.get_children():
		var mesh_node := MeshInstance3D.new()
		mesh_node.mesh = mesh
		marker.add_child(mesh_node)


func _create_objects(setup: Array[MissionPlanner.W]):
	var markers := grid.get_children()
	for i in 9:
		_create_object(markers[9 + i], setup[9 + i], i)
		_create_object(markers[8 - i], setup[8 - i], i)

func _create_object(marker: Node3D, type: MissionPlanner.W, index: int):
	match type:
		MissionPlanner.W.NONE:
			_add_building(marker, index)
		MissionPlanner.W.TURR1:
			_add_defence(marker, TURRET1_SCENE, index)
		MissionPlanner.W.EMI:
			_add_defence(marker, EMI_GEN_SCENE, index)


func _add_defence(marker: Node3D, scene: PackedScene, index: int):
	var weapon: Defence = scene.instantiate()
	weapon.global_transform = marker.global_transform
	weapon.bullets = bullets
	weapon.name = weapon.name + str(" ", index)
	weapon.dead.connect(_defence_dead)
	if weapon is EmiTower:
		(weapon as EmiTower).aliens = aliens
	defence.add_child(weapon)

func _defence_dead(dead_node: Defence):
	var next = null
	for node in defence.get_children():
		if node != dead_node:
			next = node
			break
	if next:
		next.activate()
	else:
		if aliens.get_child_count() > 0:
			# Have aleins: will show post-mortem from last one.
			for alien in aliens.get_children():
				if alien is AlienMother:
					next = alien
					break
			if not next:
				# No alien mother ship: select random alien.
				next = aliens.get_child(randi() % aliens.get_child_count())
			next.post_mortem_show()


func _add_building(marker: Node3D, index: int) -> void:
	var scene := HEADQUARTER_SCENE if not _have_hq else BUILDING_SCENES[randi() % BUILDING_SCENES.size()]
	var building: Building = scene.instantiate()
	buildings.add_child(building)
	building.name = building.name + str(" ", index)
	building.setup(bullets, marker.global_transform)
	if not _have_hq: building.dead.connect(_loose) # Loose if HQ destroyed.
	_have_hq = true


func _unhandled_input(event: InputEvent):
	if _current and (event is InputEventKey):
		var key_event := event as InputEventKey
		if key_event.pressed and not key_event.echo:
			var key: int = key_event.keycode
			if key == KEY_ESCAPE:
				get_viewport().set_input_as_handled()
				_end_game()
				return
			if (key >= KEY_1) and (key <= KEY_5):
				get_viewport().set_input_as_handled()
				key -= KEY_1
				if key < defence.get_child_count():
					var node := defence.get_child(key) as Defence
					if node != _current:
						_current.deactivate()
						_current = node
						_current.activate()
				return


func _loose():
	Game.loose()
	_end_game()

func _end_game():
	queue_free()
	Game.quitgame()


func _generate_wave():
	var path: Path3D = waypoints.get_child(0)
	if not wavegen.generate(aliens, path):
		Game.win()
	for node in aliens.get_children():
		var alien := node as Alien
		alien.path = path
		alien.bullets = bullets
		alien.buildings = buildings
		alien.defence = defence
		alien.dead.connect(_on_alien_dead)


func _on_alien_dead(dead: Alien):
	var count := aliens.get_child_count()
	if (count < 1) or (count == 1) and (aliens.get_child(0) == dead):
		_generate_wave()
