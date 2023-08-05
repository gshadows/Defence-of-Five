extends Node

signal paused
signal started

var active := false


func _ready():
	Settings.audio_setup_updated.connect(_on_audio_setup_upd)


func _on_audio_setup_upd():
	pass

func _on_video_setup_upd():
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if Settings.video.full_screen else DisplayServer.WINDOW_MODE_MAXIMIZED)


func pause():
	get_tree().paused = true
	paused.emit()


func start():
	get_tree().paused = false
	started.emit()
