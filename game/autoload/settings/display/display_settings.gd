extends Node

var window_mode: DisplayServer.WindowMode:
	set = set_window_mode,
	get = get_window_mode

var vsync_mode: DisplayServer.VSyncMode:
	set = set_vsync_mode,
	get = get_vsync_mode


func set_window_mode(val: DisplayServer.WindowMode) -> void:
	ProjectSettings["display/window/size/mode"] = val
	DisplayServer.window_set_mode(val)


func get_window_mode() -> DisplayServer.WindowMode:
	return DisplayServer.window_get_mode()


func set_vsync_mode(val: DisplayServer.VSyncMode) -> void:
	ProjectSettings["display/window/vsync/vsync_mode"] = val
	DisplayServer.window_set_vsync_mode(val)


func get_vsync_mode() -> DisplayServer.VSyncMode:
	return DisplayServer.window_get_vsync_mode()


func _ready() -> void:
	init_default_values()
	apply_config()


func init_default_values() -> void:
	pass


func apply_config() -> void:
	pass
