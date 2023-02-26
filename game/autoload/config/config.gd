extends Node

signal dirty_changed

const USER_CONFIG_PATH: = "user://config.cfg"
const DEFAULT_OPTIONS_PATH: = "res://autoload/options/default_options.cfg"

var config_file: RevertableConfigFile


func _on_RevertableConfigFile_dirty_changed() -> void:
	emit_signal("dirty_changed")


func _ready() -> void:
	config_file = RevertableConfigFile.new()
	config_file.dirty_changed.connect(_on_RevertableConfigFile_dirty_changed)
	load_config()


func load_config() -> void:
	var err: = config_file.load(USER_CONFIG_PATH)

	match err:
		OK:
			pass
		ERR_FILE_NOT_FOUND:
			var file_not_found_err: = config_file.save(USER_CONFIG_PATH)
			match file_not_found_err:
				OK:
					pass
				_:
					push_warning("Could not create options file. Options will not be saved.")
		_:
			push_warning("Could not load options file. Options will be set to default")


func revert() -> void:
	config_file.revert()


func save() -> void:
	config_file.save(USER_CONFIG_PATH)


func get_sections() -> PackedStringArray:
	return config_file.get_sections()


func get_section_keys(section: String) -> PackedStringArray:
	return config_file.get_section_keys(section)


func set_value(section: String, key: String, value) -> void:
	config_file.set_val(section, key, value)


func get_value(section: String, key: String, default = null):
	return config_file.get_val(section, key, default)


func revert_val(section: String, key: String) -> void:
	config_file.revert_val(section, key)


func is_value_dirty(section: String, key: String) -> bool:
	return config_file.is_value_dirty(section, key)


func is_dirty() -> bool:
	return config_file.is_dirty


func set_default_value(section: String, key: String, value) -> void:
	config_file.set_default_value(section, key, value)


func get_default_value(section: String, key: String):
	return config_file.get_default_value(section, key)
