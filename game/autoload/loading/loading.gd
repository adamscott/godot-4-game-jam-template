extends Node

@export var loading: = false:
	set = _set_loading

@onready var screen: Control = %Screen

func _ready() -> void:
	_set_loading(loading)

func _set_loading(val: bool) -> void:
	loading = val
	if not screen:
		return
	screen.visible = loading
