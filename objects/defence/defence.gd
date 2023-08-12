class_name Defence
extends Node3D

const FLY_TIME_FAST := 0.5
const FLY_TIME_SLOW := 3.0
const FLY_PRECISION := 0.999

var _camera: Camera3D				# Our camera node (Camera3D).
var _start_transform: Transform3D	# Initial transform from which we fly.
var _final_transform: Transform3D	# Our camera normal transform, where we should fly.
var _fly_pos: float		# Camera fly position: 0..1, where 0 = start, 1 - final
var _fly_time: float	# Current overall fly time (speed), seconds.
var _cam_fly := false	# True when flying view to current camera.
var _active := false	# Defence object is active. Used by derived scripts to enable input etc.


# Should be called from _on_ready() to initialize.
func prepare(cam: Camera3D):
	_camera = cam
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


func deactivate():
	_cam_fly = false
	_active = false
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

func _on_activated(): pass
func _on_deactivated(): pass
