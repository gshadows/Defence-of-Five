class_name Main
extends Node

@onready var menu := $Menu3D


func _ready():
	if OS.is_debug_build() and (DisplayServer.get_screen_count() > 1):
		DisplayServer.window_set_current_screen(DisplayServer.window_get_current_screen() ^ 1)
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
	#DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	Game.paused.connect(_on_paused)
	Game.started.connect(_on_started)
	Game.quit.connect(_on_quit_game)
	Game.pause()
	menu.quit.connect(func(): get_tree().quit(0))


func _on_paused():
	menu.visible = true
	menu.show_main()

func _on_started():
	menu.visible = false

func _on_quit_game():
	menu.visible = true
	menu.show_main()
