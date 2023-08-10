class_name Defence
extends Node3D

const FLY_SPEED := 10.0

var _camera: Camera3D				# Our camera node (Camera3D).
var _final_transform: Transform3D	# Our camera normal transform.
var _cam_fly := false				# True when flying view to current camera.


# Should be called from _on_ready() to initialize.
func prepare(cam: Camera3D):
	_camera = cam
	_final_transform = cam.global_transform


# Called to switch & fly from active camera to current one.
func activate():
	if not _camera:
		push_error("Defence node: camera is null: ", name, " - ", get_class())
		return
	var cur_cam := get_viewport().get_camera_3d()
	if not cur_cam:
		push_error("Defence node: no current camera: ", name, " - ", get_class())
		_camera.global_transform = _final_transform
	else:
		_cam_fly = true
		_camera.global_transform = cur_cam.global_transform
	_camera.current = true


func _process(delta: float) -> void:
	if not _cam_fly: return
	_camera.global_transform.interpolate_with(_final_transform, delta * FLY_SPEED)
	if _camera.global_position.distance_squared_to(_final_transform.origin) < 0.0001:
		_cam_fly = false
		_camera.global_transform = _final_transform
