extends Node

# Stub only. Not referenced by any other autoload -- if a project doesn't
# need saving, delete this file and its entry in Project Settings > Autoload.

const SAVE_PATH := "user://save.json"

# Not a secret -- anyone can read this from the exported binary. It only
# deters casual editing/corruption, not a determined cheater.
const CHECKSUM_SALT := "skeleton-save-v1"

func save_game(data: Dictionary) -> void:
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		return
	file.store_string(JSON.stringify({
		"data": data,
		"checksum": _compute_checksum(JSON.stringify(data)),
	}))

func load_game() -> Dictionary:
	if not FileAccess.file_exists(SAVE_PATH):
		return {}
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if not parsed is Dictionary or not parsed.has("data") or not parsed.has("checksum"):
		return {}
	var data: Variant = parsed["data"]
	if not data is Dictionary:
		return {}
	if _compute_checksum(JSON.stringify(data)) != parsed["checksum"]:
		push_warning("SaveManager: save file checksum mismatch, ignoring corrupted/tampered save.")
		return {}
	return data

func _compute_checksum(json_string: String) -> String:
	var ctx := HashingContext.new()
	ctx.start(HashingContext.HASH_SHA256)
	ctx.update((json_string + CHECKSUM_SALT).to_utf8_buffer())
	return ctx.finish().hex_encode()
