extends Area2D


signal chestTouched

var opened = false


func _on_Chest_body_entered(body):
	if opened:
		return
	if body is Uto:
		emit_signal("chestTouched")
