extends Node

var borderless: bool:
	set = set_borderless,
	get = get_borderless

var resizable: bool:
	set = set_resizable,
	get = get_resizable

var window_mode: DisplayServer.WindowMode:
	set = set_window_mode,
	get = get_window_mode

var vsync_mode: DisplayServer.VSyncMode:
	set = set_vsync_mode,
	get = get_vsync_mode

var default_values: Dictionary = {}


func set_borderless(val: bool) -> void:
	ProjectSettings["display/window/size/borderless"] = val
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, val)


func get_borderless() -> bool:
	return DisplayServer.window_get_flag(DisplayServer.WINDOW_FLAG_BORDERLESS)


func set_resizable(val: bool) -> void:
	ProjectSettings["display/window/size/resizable"] = val
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_RESIZE_DISABLED, not val)


func get_resizable() -> bool:
	return not DisplayServer.window_get_flag(DisplayServer.WINDOW_FLAG_RESIZE_DISABLED)


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


func _init() -> void:
	init_default_values()


func _ready() -> void:
	init_config_default_values()
	apply_config()


func init_default_values() -> void:
	default_values["borderless"] = ProjectSettings["display/window/size/borderless"]
	default_values["resizable"] = ProjectSettings["display/window/size/resizable"]
	default_values["window_mode"] = ProjectSettings["display/window/size/mode"]
	default_values["vsync_mode"] = ProjectSettings["display/window/vsync/vsync_mode"]


func init_config_default_values() -> void:
	Config.set_default_value("display", "borderless", get_default_value("borderless"))
	Config.set_default_value("display", "resizable", get_default_value("resizable"))
	Config.set_default_value("display", "window_mode", get_default_value("window_mode"))
	Config.set_default_value("display", "vsync_mode", get_default_value("vsync_mode"))


func revert_to_default_config() -> void:
	Config.set_value("display", "borderless", Config.get_default_value("display", "borderless"))
	Config.set_value("display", "resizable", Config.get_default_value("display", "resizable"))
	Config.set_value("display", "window_mode", Config.get_default_value("display", "window_mode"))
	Config.set_value("display", "vsync_mode", Config.get_default_value("display", "vsync_mode"))


func apply_config() -> void:
	borderless = Config.get_value("display", "borderless")
	resizable = Config.get_value("display", "resizable")
	window_mode = Config.get_value("display", "window_mode")
	vsync_mode = Config.get_value("display", "vsync_mode")


func get_default_value(key: String) -> Variant:
	match key:
		"borderless":
			return default_values["borderless"]
		"resizable":
			return default_values["resizable"]
		"window_mode":
			return default_values["window_mode"]
		"vsync_mode":
			return default_values["vsync_mode"]
	return null
