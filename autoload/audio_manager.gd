extends Node

const MAX_SFX_VOICES := 8
const SFX: SfxLibrary = preload("res://resources/sfx_library.tres")

var _bgm_player: AudioStreamPlayer
var _sfx_players: Array[AudioStreamPlayer] = []

func _ready() -> void:
	_bgm_player = AudioStreamPlayer.new()
	_bgm_player.bus = "Music"
	add_child(_bgm_player)

	for i in MAX_SFX_VOICES:
		var player := AudioStreamPlayer.new()
		player.bus = "SFX"
		add_child(player)
		_sfx_players.append(player)

func play_bgm(stream: AudioStream, fade_in_duration: float = 0.0) -> void:
	if stream == null or (_bgm_player.stream == stream and _bgm_player.playing):
		return
	_bgm_player.stream = stream
	_bgm_player.volume_db = -40.0 if fade_in_duration > 0.0 else 0.0
	_bgm_player.play()
	if fade_in_duration > 0.0:
		var tween := create_tween()
		tween.tween_property(_bgm_player, "volume_db", 0.0, fade_in_duration)

func stop_bgm(fade_out_duration: float = 0.0) -> void:
	if not _bgm_player.playing:
		return
	if fade_out_duration <= 0.0:
		_bgm_player.stop()
		return
	var tween := create_tween()
	tween.tween_property(_bgm_player, "volume_db", -40.0, fade_out_duration)
	tween.finished.connect(_bgm_player.stop)

# Overlapping sounds are supported up to MAX_SFX_VOICES; if every voice is
# busy, the new sound is dropped rather than cutting off an existing one.
func play_sfx(stream: AudioStream, volume_db: float = 0.0) -> void:
	if stream == null:
		return
	var player := _get_free_sfx_player()
	if player == null:
		return
	player.stream = stream
	player.volume_db = volume_db
	player.play()

func _get_free_sfx_player() -> AudioStreamPlayer:
	for player in _sfx_players:
		if not player.playing:
			return player
	return null
