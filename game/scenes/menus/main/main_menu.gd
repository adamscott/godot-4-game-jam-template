extends Control

@onready var animation_player: = %AnimationPlayer


func _on_options_button_pressed() -> void:
	animation_player.play("menu -> options")


func _on_options_menu_back() -> void:
	animation_player.play("options -> menu")
