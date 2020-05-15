extends Area2D

signal gameover_area_touched


func _on_UtoGameoverArea_body_entered(body):
	if body is Uto:
		emit_signal("gameover_area_touched")


func _enter_tree():
	connect("gameover_area_touched", SceneManager.current_challenge, "_on_uto_gameover_area_touched")
