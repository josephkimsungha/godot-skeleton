extends Control

const CREDITS_LIST: CreditsList = preload("res://resources/credits_list.tres")
const MENU_BGM := preload("res://assets/audio/bgm/Flowing Rocks.ogg")

@onready var start_button: Button = %StartButton
@onready var settings_button: Button = %SettingsButton
@onready var credits_button: Button = %CreditsButton
@onready var quit_button: Button = %QuitButton

func _ready() -> void:
    GameManager.state = GameManager.State.MENU
    credits_button.visible = not CREDITS_LIST.entries.is_empty()
    start_button.pressed.connect(_on_start_pressed)
    settings_button.pressed.connect(_on_settings_pressed)
    credits_button.pressed.connect(_on_credits_pressed)
    quit_button.pressed.connect(_on_quit_pressed)
    start_button.grab_focus()
    # play_bgm() no-ops if this track is already playing, so re-entering the
    # menu (e.g. Back from Credits) doesn't restart it.
    AudioManager.play_bgm(MENU_BGM, 0.5)

func _on_start_pressed() -> void:
    AudioManager.play_sfx(AudioManager.SFX.click)
    AudioManager.stop_bgm(0.5)
    SceneManager.goto_scene(SceneManager.GAME_SCENE)

func _on_settings_pressed() -> void:
    AudioManager.play_sfx(AudioManager.SFX.click)
    EventBus.settings_requested.emit()

func _on_credits_pressed() -> void:
    AudioManager.play_sfx(AudioManager.SFX.click)
    SceneManager.goto_scene(SceneManager.CREDITS_SCENE)

func _on_quit_pressed() -> void:
    AudioManager.play_sfx(AudioManager.SFX.click)
    get_tree().quit()
