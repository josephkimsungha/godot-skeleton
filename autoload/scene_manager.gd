extends Node

const MAIN_MENU_SCENE := "res://scenes/ui/main_menu/main_menu.tscn"
const GAME_SCENE := "res://scenes/game/game.tscn"
const CREDITS_SCENE := "res://scenes/ui/credits_menu/credits_menu.tscn"

var _container: Node
var _transition: Node
var _current_scene: Node

func setup(container: Node, transition: Node) -> void:
	_container = container
	_transition = transition

func goto_scene(path: String) -> void:
	if _transition:
		await _transition.fade_out()
	if _current_scene:
		_current_scene.queue_free()
		_current_scene = null
	var packed: PackedScene = load(path)
	_current_scene = packed.instantiate()
	_container.add_child(_current_scene)
	if _transition:
		await _transition.fade_in()
