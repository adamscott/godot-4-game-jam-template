extends Control

signal skip
signal end

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		emit_signal(&"skip")

func _on_end() -> void:
	emit_signal(&"end")
