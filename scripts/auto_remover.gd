extends Node

func _on_timer_timeout() -> void:
	get_parent().queue_free()