extends Node

enum State { MENU, PLAYING, PAUSED }

var state: State = State.MENU

func pause_game() -> void:
	if state != State.PLAYING:
		return
	state = State.PAUSED
	get_tree().paused = true
	EventBus.game_paused.emit()

func resume_game() -> void:
	if state != State.PAUSED:
		return
	state = State.PLAYING
	get_tree().paused = false
	EventBus.game_resumed.emit()
