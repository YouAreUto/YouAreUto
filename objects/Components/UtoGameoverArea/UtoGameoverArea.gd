extends Area2D

signal uto_touched_gameover_area


func _enter_tree():
	connect(
		"body_entered",
		self,
		"_on_body_entered"
	)
	connect(
		"uto_touched_gameover_area",
		SceneManager.current_challenge,
		"_on_uto_touched_gameover_area"
	)


func _on_body_entered(body):
	if body is Uto:
		emit_signal("uto_touched_gameover_area")


