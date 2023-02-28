extends Node

signal dirty_changed(dirty: bool)

const USER_CONFIG_PATH: = "user://config.cfg"
const DEFAULT_OPTIONS_PATH: = "res://autoload/options/default_options.cfg"

var source_config: ConfigFile
var config_file: ConfigFile
var default_config_file: ConfigFile
var default_values: ConfigFile

var is_dirty: bool:
	set = set_is_dirty


func set_is_dirty(val: bool) -> void:
	if val == is_dirty:
		return
	is_dirty = val
	emit_signal(&"dirty_changed", val)


func _ready() -> void:
	config_file = ConfigFile.new()
	source_config = ConfigFile.new()
	default_config_file = ConfigFile.new()
	default_values = ConfigFile.new()
	load_config()


func load_config() -> void:
	revert()

	var err: Error
	err = default_config_file.load(DEFAULT_OPTIONS_PATH)
	match err:
		OK:
			pass
		ERR_FILE_NOT_FOUND:
			push_warning("Could not locate default options file.")
		_:
			push_warning("Could not load default options file. There will not be default options")


func revert() -> void:
	config_file.clear()
	source_config.clear()
	var err: = config_file.load(USER_CONFIG_PATH)
	match err:
		OK:
			for section in config_file.get_sections():
				for keys in config_file.get_section_keys(section):
					for key in keys:
						source_config.set_value(section, key, config_file.get_value(section, key))
		ERR_FILE_NOT_FOUND:
			var file_not_found_err: = config_file.save(USER_CONFIG_PATH)
			match file_not_found_err:
				OK:
					pass
				_:
					push_warning("Could not create options file. Options will not be saved.")
		_:
			push_warning("Could not load options file. Options will be set to default")

	is_dirty = false


func update_is_dirty() -> void:
	for section in source_config.get_sections():
		if not section in config_file.get_sections():
			is_dirty = true
			return
		for keys in source_config.get_section_keys(section):
			for key in keys:
				if not key in config_file.get_section_keys(section):
					is_dirty = true
					return
				is_dirty = not is_same(get_value(section, key), get_source_value(section, key))
				if is_dirty:
					return

	for section in config_file.get_sections():
		if not section in source_config.get_sections():
			is_dirty = true
			return
		for keys in config_file.get_section_keys(section):
			for key in keys:
				if not key in source_config.get_section_keys(section):
					is_dirty = true
					return
				is_dirty = not is_same(get_value(section, key), get_source_value(section, key))
				if is_dirty:
					return

	is_dirty = false


func save() -> void:
	var err: = config_file.save(USER_CONFIG_PATH)
	match err:
		OK:
			revert()
		_:
			push_warning("Error while saving config.")


func get_sections() -> PackedStringArray:
	return config_file.get_sections()


func get_section_keys(section: String) -> PackedStringArray:
	return config_file.get_section_keys(section)


func set_value(section: String, key: String, value: Variant) -> void:
	var default_value: = Resource.new()
	var config_value: Variant

	config_value = config_file.get_value(section, key, default_value)
	if value == null and not is_same(config_value, default_value):
		config_file.set_value(section, key, null)
		update_is_dirty()
		return

	config_value = default_config_file.get_value(section, key, default_value)
	if is_same(value, config_value):
		config_file.set_value(section, key, null)
		update_is_dirty()
		return

	config_file.set_value(section, key, value)
	update_is_dirty()


func get_value(section: String, key: String, default: Variant = null):
	var default_value: = Resource.new()

	var value: Variant
	value = config_file.get_value(section, key, default_value)
	if not is_same(value, default_value):
		return value

	value = default_config_file.get_value(section, key, default_value)
	if not is_same(value, default_value):
		return value

	return default


func get_source_value(section: String, key: String, default: Variant = null):
	var default_value: = Resource.new()

	var value: Variant
	value = source_config.get_value(section, key, default_value)
	if not is_same(value, default_value):
		return value

	value = default_config_file.get_value(section, key, default_value)
	if not is_same(value, default_value):
		return value

	return default


func set_default_value(section: String, key: String, value: Variant) -> void:
	default_values.set_value(section, key, value)


func get_default_value(section: String, key: String, default: Variant = null):
	return default_values.get_value(section, key, default)
