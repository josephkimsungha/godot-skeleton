extends Node

const MAIN_MENU_SCENE := "res://scenes/ui/main_menu/main_menu.tscn"
const GAME_SCENE := "res://scenes/game/game.tscn"
const CREDITS_SCENE := "res://scenes/ui/credits_menu/credits_menu.tscn"

var _container: Node
var _transition: Node
var _loading_screen: Node
var _current_scene: Node

func setup(container: Node, transition: Node, loading_screen: Node = null) -> void:
	_container = container
	_transition = transition
	_loading_screen = loading_screen

## min_display_time keeps the loading screen up for at least that many seconds,
## pacing the progress bar by elapsed time as well as real load progress. Handy
## for avoiding a one-frame flash on fast loads, and for previewing the UI.
func goto_scene(path: String, show_loading: bool = false, min_display_time: float = 0.0) -> void:
	if _transition:
		await _transition.fade_out()
	if _current_scene:
		_current_scene.queue_free()
		_current_scene = null
	var packed: PackedScene = await _load_scene(path, show_loading, min_display_time)
	_current_scene = packed.instantiate()
	_container.add_child(_current_scene)
	if show_loading and _loading_screen:
		_loading_screen.hide_screen()
	if _transition:
		await _transition.fade_in()

func _load_scene(path: String, show_loading: bool, min_display_time: float) -> PackedScene:
	var use_loading_screen := show_loading and _loading_screen != null
	if use_loading_screen:
		_loading_screen.show_screen()

	if ResourceLoader.load_threaded_request(path) != OK:
		push_error("Failed to request scene load: %s" % path)
		return load(path)

	var progress := []
	var status := ResourceLoader.load_threaded_get_status(path, progress)
	var elapsed := 0.0
	while status == ResourceLoader.THREAD_LOAD_IN_PROGRESS or elapsed < min_display_time:
		if use_loading_screen:
			var load_ratio: float = (
				progress[0] if status == ResourceLoader.THREAD_LOAD_IN_PROGRESS else 1.0
			)
			var time_ratio: float = (
				1.0 if min_display_time <= 0.0
				else clamp(elapsed / min_display_time, 0.0, 1.0)
			)
			_loading_screen.set_progress(min(load_ratio, time_ratio))
		await get_tree().process_frame
		elapsed += get_process_delta_time()
		if status == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			status = ResourceLoader.load_threaded_get_status(path, progress)

	if status != ResourceLoader.THREAD_LOAD_LOADED:
		push_error("Failed to load scene: %s (status %d)" % [path, status])

	return ResourceLoader.load_threaded_get(path)
