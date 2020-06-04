extends AudioStreamPlayer

func _ready() -> void:
	pass


func _on_RainSound_finished() -> void:
	play()
