extends Area2D

signal victory_area_touched


func _on_UtoVictoryArea_body_entered(body):
	if body is Uto:
		emit_signal("victory_area_touched")


func _enter_tree():
	connect("victory_area_touched", SceneManager.current_challenge, "_on_uto_victory_area_touched")

