extends CanvasLayer

@onready var progress_bar: ProgressBar = $CenterContainer/VBoxContainer/ProgressBar

func _ready() -> void:
    visible = false

func show_screen() -> void:
    progress_bar.value = 0.0
    visible = true

func hide_screen() -> void:
    visible = false

func set_progress(ratio: float) -> void:
    progress_bar.value = ratio * 100.0
