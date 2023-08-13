class_name Defence
extends StaticBody3D

@export var health: float
@export var damage: float
@export var fire_delay: float
@export var bullet_scene: PackedScene
@export var bullet_speed: float
@export var bullet_material: BaseMaterial3D

var bullets: Node

enum Type { TURRET_1, EMI_TOWER }

const FLY_TIME_FAST := 0.5
const FLY_TIME_SLOW := 3.0
const FLY_PRECISION := 0.999

var _rot_lr: Node3D		# Object to rotate left-right.
var _rot_ud: Node3D		# Object to rotate up-down.
var _rot_up_lim: float
var _rot_down_lim: float

var _camera: Camera3D				# Our camera node (Camera3D).
var _start_transform: Transform3D	# Initial transform from which we fly.
var _final_transform: Transform3D	# Our camera normal transform, where we should fly.

var _fly_pos: float		# Camera fly position: 0..1, where 0 = start, 1 - final
var _fly_time: float	# Current overall fly time (speed), seconds.
var _cam_fly := false	# True when flying view to current camera.
var _active := false	# Defence object is active. Used by derived scripts to enable input etc.

var _next_fire: float

@onready var mouse_sensitivity := Settings.controls.mouse_sensitivity
@onready var mouse_invert_y := Settings.controls.mouse_invert_y


func _on_controls_setup_update():
	mouse_sensitivity = Settings.controls.mouse_sensitivity
	mouse_invert_y = Settings.controls.mouse_invert_y


# Should be called from _on_ready() to initialize.
func prepare(cam: Camera3D, rot_lr: Node3D, rot_ud: Node3D, rot_up_lim: float, rot_down_lim: float):
	Settings.controls_setup_updated.connect(_on_controls_setup_update)
	switch_processing(false) # Disable processing until activated.
	_camera = cam
	_rot_lr = rot_lr
	_rot_ud = rot_ud
	_rot_up_lim = rot_up_lim
	_rot_down_lim = rot_down_lim
	_final_transform = cam.global_transform
	_start_transform = _final_transform


# Called to switch & fly from active camera to current one.
func activate(slow: float = false):
	if not _camera:
		push_error("Defence node: camera is null: ", name, " - ", get_class())
		return
	var cur_cam := get_viewport().get_camera_3d()
	if not cur_cam:
		push_error("Defence node: no current camera: ", name, " - ", get_class())
		_camera.global_transform = _final_transform
	else:
		_start_transform = cur_cam.global_transform
		_fly_pos = 0.0
		_fly_time = FLY_TIME_SLOW if slow else FLY_TIME_FAST
		_cam_fly = true
	_camera.current = true
	switch_processing(true)


func deactivate():
	_active = false
	if not _cam_fly:
		_final_transform = _camera.global_transform
	_cam_fly = false
	_on_deactivated()


func _process(delta: float) -> void:
	if not _cam_fly: return
	_fly_pos += delta / _fly_time
	if _fly_pos >= FLY_PRECISION:
		_cam_fly = false
		_active = true
		_on_activated()
		_camera.global_transform = _final_transform
	else:
		_camera.global_transform = _start_transform.interpolate_with(_final_transform, _fly_pos)

func _on_activated():
	pass

func _on_deactivated():
	switch_processing(false)

func switch_processing(enable: bool):
	set_process(enable)
	set_physics_process(enable)
	set_process_input(enable)
	set_process_unhandled_input(enable)


func _unhandled_input(event: InputEvent):
	if not _active: return
	if event is InputEventMouseMotion:
		# Mouse look: left-right
		_rot_lr.rotate_y(-event.relative.x * mouse_sensitivity.x)
		# Mouse look: up-down
		var cy := mouse_sensitivity.y
		if mouse_invert_y: cy *= -1
		_rot_ud.rotate_x(-event.relative.y * cy)
		_rot_ud.rotation.x = clamp(_rot_ud.rotation.x, _rot_down_lim, _rot_up_lim)
		get_viewport().set_input_as_handled()
	#if (event is InputEventAction) and (event.action == &"fire"):
	if (event is InputEventMouseButton) and (event.button_index == MOUSE_BUTTON_LEFT) and event.pressed:
		var time = Time.get_ticks_msec()
		if time > _next_fire:
			get_viewport().set_input_as_handled()
			_next_fire = time + fire_delay
			fire()


func on_damage(damage: float, by_player: bool) -> void:
	health -= damage
	if health < 0:
		_on_destroyed(by_player)
		_explode()

func _on_destroyed(by_player: bool) -> void:
	pass

func _explode() -> void:
	queue_free()

func get_shoot_tranform() -> Transform3D: return _camera.global_transform # To be overridden.

func fire() -> void:
	var bullet: LaserRay = bullet_scene.instantiate()
	var shoot_point := get_shoot_tranform()
	bullet.global_position = shoot_point.origin
	var velocity := shoot_point.basis.y * bullet_speed
	bullet.setup(velocity, damage, bullet_material, true)
	bullets.add_child(bullet)
