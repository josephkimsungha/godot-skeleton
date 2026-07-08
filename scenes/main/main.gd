extends Node

@onready var current_scene_container: Node = $CurrentScene
@onready var transition_layer: CanvasLayer = $TransitionLayer
@onready var settings_menu: Control = $UILayer/SettingsMenu

func _ready() -> void:
    SceneManager.setup(current_scene_container, transition_layer)
    SceneManager.goto_scene(SceneManager.MAIN_MENU_SCENE)

# Unconditionally handle input events which manage game pause state and navigate
# settings menu.
func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("ui_cancel"):
        if settings_menu.visible:
            settings_menu.close()
            get_viewport().set_input_as_handled()
            return
    if event.is_action_pressed("pause"):
        if GameManager.state == GameManager.State.PAUSED:
            GameManager.resume_game()
        elif GameManager.state == GameManager.State.PLAYING:
            GameManager.pause_game()
        get_viewport().set_input_as_handled()
