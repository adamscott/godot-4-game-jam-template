extends Control

signal back

@onready var revert_to_default_button: = %RevertToDefaultButton
@onready var cancel_changes_button: = %CancelChangesButton
@onready var apply_button: = %ApplyButton
@onready var animation_player: = %AnimationPlayer

@onready var borderless_checkbox: = %BorderlessCheckBox
@onready var vsync_mode_option_button: = %VSyncModeOptionButton

@onready var volume_main_hslider: = %VolumeMainHSlider
@onready var volume_sfx_hslider: = %VolumeSfxHSlider
@onready var volume_bgm_hslider: = %VolumeBgmHSlider


func _ready() -> void:
	_init_options()
	_update_dirty()

	Config.dirty_changed.connect(_on_Config_dirty_changed)


func init() -> void:
	animation_player.play("init")


func _init_options() -> void:
	borderless_checkbox.button_pressed = Config.get_value("display", "borderless")
	vsync_mode_option_button.selected = Config.get_value("display", "vsync_mode")

	volume_main_hslider.value = Config.get_value("audio", "level_master")
	volume_sfx_hslider.value = Config.get_value("audio", "level_sfx")
	volume_bgm_hslider.value = Config.get_value("audio", "level_bgm")


func _update_dirty() -> void:
	cancel_changes_button.disabled = not Config.is_dirty


func _on_back_button_pressed() -> void:
	emit_signal(&"back")


func _on_borderless_check_box_toggled(button_pressed: bool) -> void:
	Config.set_value("display", "borderless", button_pressed)


func _on_v_sync_mode_option_button_item_selected(index: int) -> void:
	Config.set_value("display", "vsync_mode", index)


func _on_volume_main_h_slider_value_changed(value: float) -> void:
	Config.set_value("audio", "level_master", value)


func _on_volume_sfx_h_slider_value_changed(value: float) -> void:
	Config.set_value("audio", "level_sfx", value)


func _on_volume_bgm_h_slider_value_changed(value: float) -> void:
	Config.set_value("audio", "level_bgm", value)


func _on_revert_to_default_button_pressed() -> void:
	Config.revert()

	AudioSettings.revert_to_default_config()
	DisplaySettings.revert_to_default_config()

	_init_options()


func _on_cancel_changes_button_pressed() -> void:
	Config.revert()

	_init_options()


func _on_apply_button_pressed() -> void:
	Config.save()
	_init_options()

	AudioSettings.apply_config()
	DisplaySettings.apply_config()


func _on_Config_dirty_changed(dirty: bool) -> void:
	prints("config dirty changed: %s" % dirty)
	_update_dirty()
