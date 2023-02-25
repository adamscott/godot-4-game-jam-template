extends Node

const StateMachinePlayer: = preload("res://addons/imjp94.yafsm/src/StateMachinePlayer.gd")
const MainMenu: = preload("res://scenes/menus/main/main_menu.gd")

const MAIN_MENU_PATH: = "res://scenes/menus/main/main_menu.tscn"

@onready var main_state_machine: = %MainStateMachine as StateMachinePlayer

var main_menu: MainMenu

func _ready() -> void:
	assert(main_state_machine)

func _process(delta: float) -> void:
	match main_state_machine.get_current():
		"LoadingMainMenu":
			_update_loading_main_menu(delta)

func _on_main_state_machine_transited(from, to) -> void:
	match from:
		"Entry":
			pass
		"LoadingMainMenu":
			_from_loading_main_menu()

	match to:
		"LoadingMainMenu":
			_to_loading_main_menu()
		"MainMenu":
			_to_main_menu()

func _to_loading_main_menu() -> void:
	Loading.loading = true
	ResourceLoader.load_threaded_request(MAIN_MENU_PATH, "PackedScene")

func _update_loading_main_menu(delta: float) -> void:
	var status: = ResourceLoader.load_threaded_get_status(MAIN_MENU_PATH)
	main_state_machine.set_param("main_menu_loaded", status == ResourceLoader.THREAD_LOAD_LOADED)

func _from_loading_main_menu() -> void:
	Loading.loading = false

func _to_main_menu() -> void:
	var main_menu_scene: = ResourceLoader.load_threaded_get(MAIN_MENU_PATH) as PackedScene
	main_menu = main_menu_scene.instantiate()

	add_child(main_menu)

