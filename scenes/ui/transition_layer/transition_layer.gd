extends CanvasLayer

const FADE_DURATION := 0.25

@onready var rect: ColorRect = $ColorRect

func fade_out() -> void:
	rect.mouse_filter = Control.MOUSE_FILTER_STOP
	var tween := create_tween()
	tween.tween_property(rect, "color:a", 1.0, FADE_DURATION)
	await tween.finished

func fade_in() -> void:
	var tween := create_tween()
	tween.tween_property(rect, "color:a", 0.0, FADE_DURATION)
	await tween.finished
	rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
