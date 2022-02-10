extends Area2D
class_name GameOverArea

signal uto_touched_gameover_area


func _ready():
	connect(
		"body_entered",
		self,
		"_on_body_entered"
	)
	if SceneManager.current_challenge:
		connect(
			"uto_touched_gameover_area",
			SceneManager.current_challenge,
			"_on_uto_touched_gameover_area"
		)


func _on_body_entered(body):
	if body is Uto:
		body.kill()
		emit_signal("uto_touched_gameover_area")
