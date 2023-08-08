extends Node3D

@onready var _grid := %GridContainer
@onready var _but_turr1 := %Turret1
@onready var _but_emi := %EmiGenerator
@onready var _clicks_count := %ClicksCount
@onready var _turr1_count := %Turr1sCount
@onready var _emi_count := %EmisCount

@onready var _sfx := $SfxPlayer
@onready var _snd_select = preload("res://audio/MenuClick - 448080__breviceps__wet-click.wav")
@onready var _snd_place = preload("res://audio/MenuClick - 448080__breviceps__wet-click.wav")
@onready var _snd_hover = preload("res://audio/MenuHover - 422971__dkiller2204__sfxkeypickup.wav")

var _icon_turr1 := preload("res://sprites/icon.svg")
var _icon_emi := preload("res://sprites/icon.svg")

var _placed_turr1 := 0
var _placed_emi := 0
var _left_turr1 := 5
var _left_emi := 1
var _count_set := 0
var _clicks_left := 10
var _selected := W.NONE

enum W { NONE, TURR1, EMI }
const SIZE_X := 6
const SIZE_Y := 3
var setup := [
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


func _update_counts():
	_but_turr1.text = _trans("TURRET_1", _left_turr1)
	_turr1_count.text = str(_placed_turr1, ' ')
	_but_emi.text = _trans("EMIGEN", _left_emi)
	_emi_count.text = str(_placed_emi, ' ')


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
	return true


func _on_turret_1_pressed():
	if not _do_click(): return
	_selected = W.TURR1
	_but_turr1.self_modulate = Color.hex(0xF39684)
	_play_selected()


func _on_emi_generator_pressed():
	if not _do_click(): return
	_selected = W.EMI
	_but_emi.self_modulate = Color.hex(0xF39684)
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
	if not _do_click(): return
	_play_place()
	var index = y * SIZE_X + x
	match _selected:
		W.EMI:
			if _left_turr1 < 1: return
			_left_turr1 -= 1
			if setup[index] != _selected:
				_placed_turr1 += 1
			but.icon = _icon_turr1
		W.TURR1:
			if _left_emi < 1: return
			_left_emi -= 1
			if setup[index] != _selected:
				_placed_emi += 1
			but.icon = _icon_emi
	setup[index] = _selected
	_count_set += 1
	_update_counts()

	
