extends Control

const SFX_PREVIEW_DEBOUNCE := 0.1

@onready var master_slider: HSlider = %MasterSlider
@onready var music_slider: HSlider = %MusicSlider
@onready var sfx_slider: HSlider = %SFXSlider
@onready var fullscreen_check: CheckButton = %FullscreenCheck
@onready var back_button: Button = %BackButton

var _sfx_preview_timer: Timer
var _previously_focused: Control

func _ready() -> void:
    visible = false
    master_slider.value = SettingsManager.master_volume
    music_slider.value = SettingsManager.music_volume
    sfx_slider.value = SettingsManager.sfx_volume
    fullscreen_check.button_pressed = SettingsManager.fullscreen

    _sfx_preview_timer = Timer.new()
    _sfx_preview_timer.wait_time = SFX_PREVIEW_DEBOUNCE
    _sfx_preview_timer.one_shot = true
    _sfx_preview_timer.timeout.connect(_on_sfx_preview_timeout)
    add_child(_sfx_preview_timer)

    master_slider.value_changed.connect(SettingsManager.set_master_volume)
    music_slider.value_changed.connect(SettingsManager.set_music_volume)
    sfx_slider.value_changed.connect(_on_sfx_slider_value_changed)
    fullscreen_check.toggled.connect(SettingsManager.set_fullscreen)
    back_button.pressed.connect(_on_back_pressed)
    EventBus.settings_requested.connect(_on_settings_requested)

func close() -> void:
    AudioManager.play_sfx(AudioManager.SFX.click)
    SettingsManager.save_settings()
    visible = false
    if is_instance_valid(_previously_focused):
        _previously_focused.grab_focus()

func _on_settings_requested() -> void:
    _previously_focused = get_viewport().gui_get_focus_owner()
    visible = true
    master_slider.grab_focus()

# Applies the volume immediately and plays a preview sfx (debounced).
func _on_sfx_slider_value_changed(value: float) -> void:
    SettingsManager.set_sfx_volume(value)
    _sfx_preview_timer.start()

func _on_sfx_preview_timeout() -> void:
    AudioManager.play_sfx(AudioManager.SFX.click)

func _on_back_pressed() -> void:
    close()
