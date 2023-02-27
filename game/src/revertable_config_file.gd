extends ConfigFile
class_name RevertableConfigFile

signal dirty_changed

var source_config: ConfigFile
var default_config: ConfigFile

var is_dirty: bool = false:
	set = _set_is_dirty


func _set_is_dirty(val: bool) -> void:
	var before: = is_dirty
	is_dirty = val
	if before != is_dirty:
		emit_signal(&"dirty_changed")


func _init() -> void:
	source_config = ConfigFile.new()
	default_config = ConfigFile.new()
	is_dirty = false


@warning_ignore("native_method_override")
func clear() -> void:
	super.clear()
	source_config.clear()


@warning_ignore("native_method_override")
func get_sections() -> PackedStringArray:
	var config_file_sections: = super.get_sections()
	var default_file_sections: = default_config.get_sections()

	for default_section in default_file_sections:
		if not default_section in config_file_sections:
			config_file_sections.append(default_section)

	return config_file_sections


@warning_ignore("native_method_override")
func get_section_keys(section: String) -> PackedStringArray:
	var config_file_section_keys: = PackedStringArray()
	if super.has_section(section):
		config_file_section_keys = super.get_section_keys(section)

	var default_config_section_keys: = PackedStringArray()
	if default_config.has_section(section):
		default_config_section_keys = default_config.get_section_keys(section)

	for default_section_key in default_config_section_keys:
		if not default_section_key in config_file_section_keys:
			config_file_section_keys.append(default_section_key)

	return config_file_section_keys


func get_val(section: String, key: String, default = null) -> Variant:
	if default == null:
		default = get_default_value(section, key)

	return super.get_value(section, key, default)


func set_val(section: String, key: String, value) -> void:
	var default_value = get_default_value(section, key)
	if default_value != null and value == get_default_value(section, key):
		value = null

	super.set_value(section, key, value)
	prints("set_value", section, key, value)
	check_dirty()

	#if super.has_section(section) != source_config.has_section(section):
	#	is_dirty = true
	#elif super.has_section(section) and super.has_section_key(section, key) != source_config.has_section_key(section, key):
	#	is_dirty = true
	#elif super.has_section(section) and super.has_section_key(section, key) and super.get_value(section, key) != source_config.get_value(section, key):
	#	is_dirty = true
	#else:
	#	check_dirty()




func is_value_dirty(section: String, key: String) -> bool:
	if super.has_section(section) != source_config.has_section(section):
		return true

	if super.has_section_key(section, key) != source_config.has_section_key(section, key):
		return true

	return super.get_value(section, key) != source_config.get_value(section, key)


@warning_ignore("native_method_override")
func load(path: String) -> Error:
	var err: = super.load(path)
	assert(err == OK)
	match err:
		OK:
			update_source_config()
	return err


func load_default(path: String) -> Error:
	return default_config.load(path)


@warning_ignore("native_method_override")
func load_encrypted(path: String, key: PackedByteArray) -> Error:
	var err: = super.load_encrypted(path, key)
	match err:
		OK:
			update_source_config()
	return err


@warning_ignore("native_method_override")
func load_encrypted_pass(path: String, password: String) -> Error:
	var err: = super.load_encrypted_pass(path, password)
	match err:
		OK:
			update_source_config()
	return err


@warning_ignore("native_method_override")
func parse(data: String) -> Error:
	var err: = super.parse(data)
	match err:
		OK:
			update_source_config()
	return err


func revert() -> void:
	super.clear()

	for section in source_config.get_sections():
		for key in source_config.get_section_keys(section):
			super.set_value(section, key, source_config.get_value(section, key))

	check_dirty()


@warning_ignore("native_method_override")
func save(path: String) -> Error:
	var err: = super.save(path)
	match err:
		OK:
			update_source_config()
	return err


@warning_ignore("native_method_override")
func save_encrypted(path: String, key: PackedByteArray) -> Error:
	var err: = super.save_encrypted(path, key)
	match err:
		OK:
			update_source_config()
	return err


@warning_ignore("native_method_override")
func save_encrypted_pass(path: String, password: String) -> Error:
	var err: = super.save_encrypted_pass(path, password)
	match err:
		OK:
			update_source_config()
	return err


func set_default_value(section: String, key: String, value: Variant) -> void:
	default_config.set_value(section, key, value)


func get_default_value(section: String, key: String):
	return default_config.get_value(section, key, null)


func revert_val(section: String, key: String) -> void:
	super.set_value(section, key, source_config.get_value(section, key))
	check_dirty()


func update_source_config() -> void:
	source_config.clear()

	for section in super.get_sections():
		for key in super.get_section_keys(section):
			source_config.set_value(section, key, super.get_value(section, key))

	check_dirty()


func check_dirty() -> void:
	for section in source_config.get_sections():
		if not super.has_section(section):
			is_dirty = true
			return

		for key in source_config.get_section_keys(section):
			if not super.has_section_key(section, key):
				is_dirty = true
				return

			if super.get_value(section, key) != source_config.get_value(section, key):
				is_dirty = true
				return

	for section in super.get_sections():
		if not source_config.has_section(section):
			is_dirty = true
			return

		for key in super.get_section_keys(section):
			if not source_config.has_section_key(section, key):
				is_dirty = true
				return

			if super.get_value(section, key) != source_config.get_value(section, key):
				is_dirty = true
				return

	is_dirty = false
