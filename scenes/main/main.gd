extends Node

@onready var current_scene_container: Node = $CurrentScene
@onready var transition_layer: CanvasLayer = $TransitionLayer
@onready var settings_menu: Control = $UILayer/SettingsMenu

func _ready() -> void:
    SceneManager.setup(current_scene_container, transition_layer)
    SceneManager.goto_scene(SceneManager.MAIN_MENU_SCENE)

# Lives here (rather than in whichever scene is currently active) because
# this node is PROCESS_MODE_ALWAYS and keeps receiving input even while the
# tree is paused -- the active gameplay/menu scene is not guaranteed to be.
#
# "ui_cancel" (built-in, closes the current overlay) and "pause" (toggles
# gameplay pause) are both bound to Escape by default, but kept as separate
# actions so they can be rebound independently later -- e.g. a gamepad's
# Start button should pause without also being the "back" button.
func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("ui_cancel") and settings_menu.visible:
        settings_menu.close()
        get_viewport().set_input_as_handled()
        return
    if not event.is_action_pressed("pause"):
        return
    if GameManager.state == GameManager.State.PAUSED:
        GameManager.resume_game()
    elif GameManager.state == GameManager.State.PLAYING:
        GameManager.pause_game()
    get_viewport().set_input_as_handled()
