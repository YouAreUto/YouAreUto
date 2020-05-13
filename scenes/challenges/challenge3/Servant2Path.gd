extends Path2D

func _ready() -> void:
	pass

func _on_Timer_timeout() -> void:
	$AnimationPlayer.play("patrol")
