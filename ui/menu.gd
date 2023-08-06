extends HSplitContainer

signal quit

@onready var _sndClick = preload("res://audio/MenuClick - 448080__breviceps__wet-click.wav")
@onready var _sndHover = preload("res://audio/MenuHover - 422971__dkiller2204__sfxkeypickup.wav")

@onready var _main := %MainMenu
@onready var _settings := %SettingsMenu
@onready var _about := %AboutMenu

@onready var _about_help := %AboutHelp
@onready var _about_game := %AboutGame
@onready var _about_copy := %AboutCopyright

@onready var _settings_video := %SettingsVideo
@onready var _settings_audio := %SettingsAudio
@onready var _settings_game := %SettingsGame
@onready var _settings_controls := %SettingsControls

@onready var _but_start := %ButtonStart
@onready var _but_cont := %ButtonContinue

@onready var _sfx := $MenuSFX
@onready var _music := $MenuMusic


func _ready():
	show_main()


func show_main():
	_hide_subs()
	_main.visible = true
	_but_start.visible = not Game.active
	_but_cont.visible = Game.active
	_music.play()


func _hide_subs():
	_settings.visible = false
	_about.visible = false

	_about_help.visible = false
	_about_game.visible = false
	_about_copy.visible = false

	_settings_video.visible = false
	_settings_audio.visible = false
	_settings_game.visible = false
	_settings_controls.visible = false


func _play_click():
	_sfx.stream = _sndClick
	_sfx.play()

func _play_hover():
	_sfx.stream = _sndHover
	_sfx.play()


func _on_button_start_pressed():
	_prepare_start()
	var node = load("res://maps/map-01.tscn").instantiate()
	add_sibling(node)

func _on_button_continue_pressed():
	_prepare_start()

func _prepare_start():
	_music.stop()
	_play_click()
	visible = false
	await get_tree().create_timer(0.2).timeout
	Game.start()

func _on_button_quit_pressed():
	_music.stop()
	_play_click()
	await get_tree().create_timer(0.2).timeout
	quit.emit()

func _on_button_settings_pressed():
	_play_click()
	_hide_subs()
	_settings.visible = true

func _on_button_info_pressed():
	_play_click()
	_hide_subs()
	_about.visible = true


func _on_button_video_pressed():
	_play_click()
	_on_button_settings_pressed()
	%FullScreen.set_pressed_no_signal(Settings.video.full_screen)
	_settings_video.visible = true

func _on_button_audio_pressed():
	_play_click()
	_on_button_settings_pressed()
	%MasterEnable.set_pressed_no_signal(Settings.audio.master_enabled)
	%SfxEnable.set_pressed_no_signal(Settings.audio.sfx_enabled)
	%MusicEnable.set_pressed_no_signal(Settings.audio.music_enabled)
	%VolMaster.set_value_no_signal(Settings.audio.master_vol)
	%VolSfx.set_value_no_signal(Settings.audio.sfx_vol)
	%VolMusic.set_value_no_signal(Settings.audio.music_vol)
	_settings_audio.visible = true

func _on_button_game_pressed():
	_play_click()
	_on_button_settings_pressed()
	%Debug.set_pressed_no_signal(Settings.game.debug)
	_settings_game.visible = true

func _on_button_controls_pressed():
	_play_click()
	_on_button_settings_pressed()
	%MouseInvY.set_pressed_no_signal(Settings.controls.mouse_invert_y)
	%MouseSens.set_value_no_signal(Settings.controls.mouse_sensitivity.x)
	_settings_controls.visible = true


func _on_button_help_pressed():
	_play_click()
	_on_button_info_pressed()
	_about_help.visible = true

func _on_button_about_pressed():
	_play_click()
	_on_button_info_pressed()
	_about_game.visible = true

func _on_button_copyright_pressed():
	_play_click()
	_on_button_info_pressed()
	_about_copy.visible = true



func _on_mouse_inv_y_toggled(checked):
	_play_click()
	Settings.controls.mouse_invert_y = checked
	Settings.controls_setup_updated.emit()
	Settings.save()

func _on_mouse_sens_drag_ended(value_changed):
	if value_changed:
		var value = %MouseSens.value
		Settings.controls.mouse_sensitivity = Vector2(value, value)
		Settings.controls_setup_updated.emit()
	Settings.save()



func _on_debug_toggled(checked):
	_play_click()
	Settings.game.debug = checked
	Settings.game_setup_updated.emit()
	Settings.save()


func _on_full_screen_toggled(checked):
	_play_click()
	Settings.video.full_screen = checked
	Settings.video_setup_updated.emit()
	Settings.save()



func _on_master_enable_toggled(checked):
	_play_click()
	Settings.audio.master_enabled = checked
	Settings.audio_setup_updated.emit()
	Settings.save()

func _on_sfx_enable_toggled(checked):
	_play_click()
	Settings.audio.sfx_enabled = checked
	Settings.audio_setup_updated.emit()
	Settings.save()

func _on_music_enable_toggled(checked):
	_play_click()
	Settings.audio.music_enabled = checked
	Settings.audio_setup_updated.emit()
	Settings.save()

func _on_vol_master_value_changed(value):
	Settings.audio.master_vol = value
	Settings.audio_setup_updated.emit()
	Settings.save()

func _on_vol_sfx_value_changed(value):
	Settings.audio.sfx_vol = value
	Settings.audio_setup_updated.emit()
	Settings.save()

func _on_vol_music_value_changed(value):
	Settings.audio.music_vol = value
	Settings.audio_setup_updated.emit()
	Settings.save()
