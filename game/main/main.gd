extends Node

const StateMachinePlayer: = preload("res://addons/imjp94.yafsm/src/StateMachinePlayer.gd")
const Intro: = preload("res://scenes/intro/intro.gd")
const MainMenu: = preload("res://scenes/menus/main/main_menu.gd")

const INTRO_PATH: = "res://scenes/intro/intro.tscn"
const MAIN_MENU_PATH: = "res://scenes/menus/main/main_menu.tscn"

@onready var main_state_machine: = %MainStateMachine as StateMachinePlayer

var intro: Intro
var main_menu: MainMenu

var skip_intro: = false

func _ready() -> void:
	assert(main_state_machine)

func _process(delta: float) -> void:
	match main_state_machine.get_current():
		"LoadingIntro":
			_update_loading_intro(delta)
		"Intro":
			_update_intro(delta)
		"LoadingMainMenu":
			_update_loading_main_menu(delta)

	main_state_machine.update(delta)

func _on_main_state_machine_transited(from, to) -> void:
	prints("main state transited:", from, to)
	match from:
		"Entry":
			pass
		"LoadingIntro":
			_from_loading_intro()
		"Intro":
			_from_intro()
		"LoadingMainMenu":
			_from_loading_main_menu()

	match to:
		"LoadingIntro":
			_to_loading_intro()
		"Intro":
			_to_intro()
		"LoadingMainMenu":
			_to_loading_main_menu()
		"MainMenu":
			_to_main_menu()

func _to_loading_intro() -> void:
	Game.loading = true
	ResourceLoader.load_threaded_request(INTRO_PATH, "PackedScene")

func _update_loading_intro(delta: float) -> void:
	var status: = ResourceLoader.load_threaded_get_status(INTRO_PATH)
	main_state_machine.set_param("intro_loaded", status == ResourceLoader.THREAD_LOAD_LOADED)

func _from_loading_intro() -> void:
	Game.loading = false

func _to_intro() -> void:
	_load_main_menu_scene()
	var intro_scene: = ResourceLoader.load_threaded_get(INTRO_PATH) as PackedScene
	intro = intro_scene.instantiate() as Intro
	intro.skip.connect(_on_intro_skip)
	intro.end.connect(_on_intro_end)
	add_child(intro)

func _update_intro(delta: float) -> void:
	_update_main_menu_loaded_status()

func _from_intro() -> void:
	remove_child(intro)
	intro.queue_free()

func _on_intro_skip() -> void:
	main_state_machine.set_trigger("skip")

func _on_intro_end() -> void:
	main_state_machine.set_trigger("end")

func _to_loading_main_menu() -> void:
	Game.loading = true
	_load_main_menu_scene()

func _update_loading_main_menu(delta: float) -> void:
	_update_main_menu_loaded_status()

func _update_main_menu_loaded_status() -> void:
	var status: = ResourceLoader.load_threaded_get_status(MAIN_MENU_PATH)
	main_state_machine.set_param("main_menu_loaded", status == ResourceLoader.THREAD_LOAD_LOADED)

func _from_loading_main_menu() -> void:
	Game.loading = false

func _load_main_menu_scene() -> void:
	ResourceLoader.load_threaded_request(MAIN_MENU_PATH, "PackedScene")

func _to_main_menu() -> void:
	var main_menu_scene: = ResourceLoader.load_threaded_get(MAIN_MENU_PATH) as PackedScene
	main_menu = main_menu_scene.instantiate()
	add_child(main_menu)

func _from_main_menu() -> void:
	remove_child(main_menu)
	main_menu.queue_free()
