extends Control

@onready var borderless_checkbox: = %BorderlessCheckBox
@onready var vsync_mode_option_button: = %VSyncModeOptionButton

@onready var volume_main_hslider: = %VolumeMainHSlider
@onready var volume_sfx_hslider: = %VolumeSFXHSlider
@onready var volume_bgm_hslider: = %VolumeBGMHSlider


func _ready() -> void:
	_init_options()


func _init_options() -> void:
	borderless_checkbox.button_pressed = Config.get_value("display", "borderless")
	vsync_mode_option_button.selected = Config.get_value("display", "vsync_mode")

	volume_main_hslider.value = Config.get_value("audio", "level_master")
	volume_sfx_hslider.value = Config.get_value("audio", "level_sfx")
	volume_bgm_hslider.value = Config.get_value("audio", "level_bgm")


func _on_borderless_check_box_toggled(button_pressed: bool) -> void:
	Config.set_value("display", "borderless", button_pressed)


func _on_v_sync_mode_option_button_item_selected(index: int) -> void:
	Config.set_value("display", "vsync_mode", index)
