class_name AttackWave
extends Node

const FORM_WITHD := 50
const MAX_WAVE := 10

var _form_simple := preload("res://objects/enemies/ai/formation_simple.tscn")
var _form_big := preload("res://objects/enemies/ai/formation_big.tscn")
var _form_mother := preload("res://objects/enemies/ai/formation_mother.tscn")
var _form_mother_big := preload("res://objects/enemies/ai/formation_mother_big.tscn")

class Wave:
	var min_wave: int
	var length: int
	var reps: int
	var form: PackedScene
	func _init(minw:int, len:int, rep:int, frm:PackedScene) -> void:
		min_wave = minw; length = len; reps = rep; form = frm
var WAVES: Array[Wave] = [
	Wave.new(  0,  75,  5, _form_simple),
	Wave.new(  3, 150,  5, _form_big),
	Wave.new(  5, 200,  5, _form_mother),
	Wave.new(  6, 150, 10, _form_big),
	Wave.new(  9, 150, 10, _form_big),
	Wave.new( 10, 300, 10, _form_mother_big),
]

var wave_number := 0


func generate(aliens: Node, path: Path3D) -> bool:
	wave_number += 1
	if wave_number > MAX_WAVE:
		return false # No more waves.
	var wave := _select_wave()
	var p1 := path.curve.get_point_position(0)
	var p2 := path.curve.get_point_position(1)
	var dir := (p1 - p2).normalized() * wave.length
	var pos := Vector3.ZERO
	for i in wave.reps:
		var form : Node = wave.form.instantiate()
		aliens.add_child(form) # Temporary add to tree to make reparend() work.
		for node in form.get_children():
			var alien := node as Alien
			alien.reparent(aliens)
			alien.global_position += pos
			alien.name = str(alien.name, " w", i)
		pos += dir
		form.free() # Remove empty formation.
	return true


func _select_wave() -> Wave:
	var selected := WAVES[0]
	for i in range(1, WAVES.size()):
		if wave_number < WAVES[i].min_wave:
			break
		selected = WAVES[i]
	return selected
