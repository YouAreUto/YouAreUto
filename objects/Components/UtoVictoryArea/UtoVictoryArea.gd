extends Area2D

signal uto_touched_victory_area


func _enter_tree():
	connect(
		"body_entered",
		self,
		"_on_body_entered"
	)
	if SceneManager.current_challenge:
		connect(
			"uto_touched_victory_area",
			SceneManager.current_challenge,
			"_on_uto_touched_victory_area"
		)
	else:
		printerr("UtoVictoryArea ERROR: 'SceneManager.current_challenge' is null")


func _on_body_entered(body):
	if body is Uto:
		body.set_physics_process(false)
		emit_signal("uto_touched_victory_area")
