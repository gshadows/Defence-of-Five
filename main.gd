class_name Main
extends Node

@onready var menu := $Menu


func _ready():
	if OS.is_debug_build() and (DisplayServer.get_screen_count() > 1):
		DisplayServer.window_set_current_screen(DisplayServer.get_screen_count() - 1)
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
	#DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	Game.paused.connect(_on_paused)
	Game.started.connect(_on_started)
	Game.pause()


func _on_paused():
	menu.visible = true
	menu.show_main()

func _on_started():
	menu.visible = false
