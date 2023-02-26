extends Node

@export var loading: = false:
	set = _set_loading

@onready var loading_screen: = %LoadingScreen


func _ready() -> void:
	_set_loading(loading)


func _set_loading(val: bool) -> void:
	loading = val
	if not loading_screen:
		return
	loading_screen.visible = loading
