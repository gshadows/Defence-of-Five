extends Node

const PATH = 'user://settings.json'

signal audio_setup_updated
signal video_setup_updated
signal game_setup_updated
signal controls_setup_updated

class Video:
	var full_screen	:= false
var video := Video.new()

class Audio:
	var enabled		:= true
	var sfx_vol		:= 1.0
	var music_vol	:= 1.0
var audio := Audio.new()

class Conrols:
	var mouse_sensitivity	:= Vector2(0.005, 0.005)
	var mouse_invert_y		:= false
var controls := Conrols.new()


func _ready():
	reload()


func emit_configuration_reload():
	await get_tree().process_frame
	audio_setup_updated.emit()
	video_setup_updated.emit()
	game_setup_updated.emit()
	controls_setup_updated.emit()


func save():
	SimpleJSON.save_to_file(self, PATH)


func reload():
	SimpleJSON.load_from_file(self, PATH)
	emit_configuration_reload()
