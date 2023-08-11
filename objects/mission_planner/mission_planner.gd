class_name MissionPlanner
extends Node3D

signal quit
signal start(setup)

@onready var _grid := %GridContainer
@onready var _but_turr1 := %Turret1
@onready var _but_emi := %EmiGenerator
@onready var _but_start := %ButStart

@onready var _clicks_count := %ClicksCount
@onready var _turr1_count := %Turr1sCount
@onready var _emi_count := %EmisCount
@onready var _footer_not_ready := %FooterNotReady
@onready var _footer_ready := %FooterReady
@onready var _footer_game_over := %FooterGameOver

@onready var _sfx := $SfxPlayer
@onready var _snd_select = preload("res://audio/MenuClick - 448080__breviceps__wet-click.wav")
@onready var _snd_place = preload("res://audio/MenuClick - 448080__breviceps__wet-click.wav")
@onready var _snd_hover = preload("res://audio/MenuHover - 422971__dkiller2204__sfxkeypickup.wav")

var _icon_turr1 := preload("res://sprites/turret_1.png")
var _icon_emi := preload("res://sprites/emi_gen.png")

const MAX_OBJECTS = 5

var _placed_turr1 := 0
var _placed_emi := 0
var _left_turr1 := 5
var _left_emi := 1
var _count_set := 0
var _clicks_left := MAX_OBJECTS * 2
var _selected := W.NONE

enum W { NONE, TURR1, EMI }
const SIZE_X := 6
const SIZE_Y := 3
var _setup := [
	W.NONE, W.NONE, W.NONE, W.NONE, W.NONE, W.NONE,
	W.NONE, W.NONE, W.NONE, W.NONE, W.NONE, W.NONE,
	W.NONE, W.NONE, W.NONE, W.NONE, W.NONE, W.NONE,
]


func _ready():
	_update_counts()
	var buttons := _grid.get_children()
	for y in SIZE_Y:
		for x in SIZE_X:
			var idx := y * SIZE_X + x
			var but: BaseButton = buttons[idx]
			if (but.disabled): continue
			but.mouse_entered.connect(_play_hover)
			but.pressed.connect(_on_grid_pressed.bind(x, y, but))
	$Camera3D.current = true


func _update_counts():
	_but_turr1.text = _trans("TURRET_1", _left_turr1)
	_turr1_count.text = str(_placed_turr1, ' ')
	_but_emi.text = _trans("EMIGEN", _left_emi)
	_emi_count.text = str(_placed_emi, ' ')
	if _count_set == MAX_OBJECTS:
		_footer_ready.visible = true


func _trans(key: String, num: int) -> String:
	return str(tr(key), " (", num, ")")


func _deselect():
	match _selected:
		W.TURR1:
			_but_turr1.self_modulate = Color.WHITE
		W.EMI:
			_but_emi.self_modulate = Color.WHITE
	_selected = W.NONE


func _do_click() -> bool:
	if _clicks_left <= 0:
		return false
	_clicks_left -= 1
	_clicks_count.text = str(_clicks_left, ' ')
	_deselect()
	if _clicks_left <= 0:
		_footer_not_ready.visible = false
		if _count_set < 1:
			_footer_game_over.visible = true
	return true


func _on_turret_1_pressed():
	if not _do_click(): return
	_selected = W.TURR1
	_but_turr1.self_modulate = Color.hex(0x5E7ECB)
	_play_selected()


func _on_emi_generator_pressed():
	if not _do_click(): return
	_selected = W.EMI
	_but_emi.self_modulate = Color.hex(0x5E7ECB)
	_play_selected()


func _play_hover():
	_sfx.stream = _snd_hover
	_sfx.play()

func _play_selected():
	_sfx.stream = _snd_select
	_sfx.play()

func _play_place():
	_sfx.stream = _snd_place
	_sfx.play()


func _on_grid_pressed(x: int, y: int, but: BaseButton):
	var sel = _selected
	if not _do_click(): return
	_play_place()
	if sel == W.NONE: return
	var index = y * SIZE_X + x
	match sel:
		W.TURR1:
			_left_turr1 -= 1
			if _left_turr1 < 1:
				_but_turr1.visible = false
			if _setup[index] != sel:
				_placed_turr1 += 1
			but.texture_normal = _icon_turr1
		W.EMI:
			_left_emi -= 1
			if _left_emi < 1:
				_but_emi.visible = false
			if _setup[index] != sel:
				_placed_emi += 1
			but.texture_normal = _icon_emi
	_setup[index] = sel
	_count_set += 1
	_footer_not_ready.visible = false
	_but_start.disabled = false
	_update_counts()


func _on_but_start_pressed():
	_play_place()
	start.emit(_setup)


func _on_but_quit_pressed():
	_play_place()
	quit.emit()
