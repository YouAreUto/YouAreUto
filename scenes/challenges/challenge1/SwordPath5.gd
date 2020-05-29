extends Path2D

var shouldUpdatePath = false


func updatePatrolAnim():
	if shouldUpdatePath:
		shouldUpdatePath = false
		$AnimationPlayer.play("patrol2")


func _on_UTO_hit():
	shouldUpdatePath = true
