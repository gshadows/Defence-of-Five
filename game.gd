extends Node

signal paused
signal started
signal quit

var active := false

@onready var AUDIO_BUS_MASTER = AudioServer.get_bus_index("Master")
@onready var AUDIO_BUS_MUSIC = AudioServer.get_bus_index("Music")
@onready var AUDIO_BUS_SFX = AudioServer.get_bus_index("SFX")


func _ready():
	Settings.audio_setup_updated.connect(_on_audio_setup_upd)
	Settings.video_setup_updated.connect(_on_video_setup_upd)


func _on_audio_setup_upd():
	AudioServer.set_bus_volume_db(AUDIO_BUS_MASTER, linear_to_db(Settings.audio.master_vol))
	AudioServer.set_bus_mute(AUDIO_BUS_MASTER, !Settings.audio.master_enabled)

	AudioServer.set_bus_volume_db(AUDIO_BUS_SFX, linear_to_db(Settings.audio.sfx_vol))
	AudioServer.set_bus_mute(AUDIO_BUS_SFX, !Settings.audio.sfx_enabled)

	AudioServer.set_bus_volume_db(AUDIO_BUS_MUSIC, linear_to_db(Settings.audio.music_vol))
	AudioServer.set_bus_mute(AUDIO_BUS_MUSIC, !Settings.audio.music_enabled)

func _on_video_setup_upd():
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if Settings.video.full_screen else DisplayServer.WINDOW_MODE_MAXIMIZED)


func pause():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().paused = true
	paused.emit()

func start():
	get_tree().paused = false
	started.emit()

func quitgame():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().paused = true
	quit.emit()


func enemy_down(type: Alien.Type, by_player: bool):
	pass # TODO: Scores

func defence_down(type: Defence.Type, by_player: bool):
	pass # TODO: Scores

func building_down(is_hq: bool, by_player: bool):
	pass # TODO: Scores
	if is_hq:
		get_tree().create_timer(1).timeout.connect(quitgame)
