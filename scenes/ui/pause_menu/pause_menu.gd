extends Control

@onready var resume_button: Button = %ResumeButton
@onready var settings_button: Button = %SettingsButton
@onready var quit_button: Button = %QuitButton

func _ready() -> void:
    visible = false
    resume_button.pressed.connect(_on_resume_pressed)
    settings_button.pressed.connect(_on_settings_pressed)
    quit_button.pressed.connect(_on_quit_pressed)
    EventBus.game_paused.connect(func(): visible = true; resume_button.grab_focus())
    EventBus.game_resumed.connect(func(): visible = false)

func _on_resume_pressed() -> void:
    AudioManager.play_sfx(AudioManager.SFX.click)
    GameManager.resume_game()

func _on_settings_pressed() -> void:
    AudioManager.play_sfx(AudioManager.SFX.click)
    EventBus.settings_requested.emit()

func _on_quit_pressed() -> void:
    AudioManager.play_sfx(AudioManager.SFX.click)
    GameManager.resume_game()
    SceneManager.goto_scene(SceneManager.MAIN_MENU_SCENE)
