extends Node

const MASTER_BUS: = "Master"
const SFX_BUS: = "Sfx"
const BGM_BUS: = "Bgm"

var master_bus_level: float:
	set = set_master_bus_level,
	get = get_master_bus_level
var sfx_bus_level: float:
	set = set_sfx_bus_level,
	get = get_sfx_bus_level
var bgm_bus_level: float:
	set = set_bgm_bus_level,
	get = get_bgm_bus_level


func set_master_bus_level(val: float) -> void:
	var idx: = AudioServer.get_bus_index(MASTER_BUS)
	AudioServer.set_bus_volume_db(idx, val)


func get_master_bus_level() -> float:
	var idx: = AudioServer.get_bus_index(MASTER_BUS)
	return AudioServer.get_bus_volume_db(idx)


func set_sfx_bus_level(val: float) -> void:
	var idx: = AudioServer.get_bus_index(SFX_BUS)
	AudioServer.set_bus_volume_db(idx, val)


func get_sfx_bus_level() -> float:
	var idx: = AudioServer.get_bus_index(SFX_BUS)
	return AudioServer.get_bus_volume_db(idx)


func set_bgm_bus_level(val: float) -> void:
	var idx: = AudioServer.get_bus_index(BGM_BUS)
	AudioServer.set_bus_volume_db(idx, val)


func get_bgm_bus_level() -> float:
	var idx: = AudioServer.get_bus_index(BGM_BUS)
	return AudioServer.get_bus_volume_db(idx)


func _ready() -> void:
	init_default_values()
	apply_config()


func init_default_values() -> void:
	Config.set_default_value("audio", "level_master", get_master_bus_default_level())
	Config.set_default_value("audio", "level_sfx", get_sfx_bus_default_level())
	Config.set_default_value("audio", "level_bgm", get_bgm_bus_default_level())


func revert_to_default_config() -> void:
	Config.set_value("audio", "level_master", Config.get_default_value("audio", "level_master"))
	Config.set_value("audio", "level_sfx", Config.get_default_value("audio", "level_sfx"))
	Config.set_value("audio", "level_bgm", Config.get_default_value("audio", "level_bgm"))


func apply_config() -> void:
	var master_idx: = AudioServer.get_bus_index(MASTER_BUS)
	var sfx_idx: = AudioServer.get_bus_index(SFX_BUS)
	var bgm_idx: = AudioServer.get_bus_index(BGM_BUS)

	AudioServer.set_bus_volume_db(master_idx, Config.get_value("audio", "level_master"))
	AudioServer.set_bus_volume_db(sfx_idx, Config.get_value("audio", "level_sfx"))
	AudioServer.set_bus_volume_db(bgm_idx, Config.get_value("audio", "level_bgm"))


func get_master_bus_default_level() -> float:
	return 0.0


func get_sfx_bus_default_level() -> float:
	return 0.0


func get_bgm_bus_default_level() -> float:
	return 0.0
