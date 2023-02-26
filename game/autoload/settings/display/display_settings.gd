extends Node

var window_mode: DisplayServer.WindowMode:
	set = set_window_mode,
	get = get_window_mode


func set_window_mode(val: DisplayServer.WindowMode) -> void:
	ProjectSettings["display/window/size/mode"] = val
	DisplayServer.window_set_mode(val)


func get_window_mode() -> DisplayServer.WindowMode:
	return DisplayServer.window_get_mode()


func _ready() -> void:
	init_default_values()
	apply_config()


func init_default_values() -> void:
	pass


func apply_config() -> void:
	pass
