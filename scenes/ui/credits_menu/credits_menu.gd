extends Control

const CREDITS_LIST: CreditsList = preload("res://resources/credits_list.tres")

@onready var credits_container: VBoxContainer = %CreditsContainer
@onready var back_button: Button = %BackButton

func _ready() -> void:
	back_button.pressed.connect(_on_back_pressed)
	for entry in CREDITS_LIST.entries:
		var label := Label.new()
		label.text = "%s — %s" % [entry.role, entry.display_name]
		credits_container.add_child(label)

func _on_back_pressed() -> void:
	AudioManager.play_sfx(AudioManager.SFX.click)
	SceneManager.goto_scene(SceneManager.MAIN_MENU_SCENE)
