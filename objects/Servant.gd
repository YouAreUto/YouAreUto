extends Node2D

signal uto_entered

func getSize() -> Vector2:
	return $Sprite.texture.get_size() * scale


func _on_Area2D_body_entered(body):
	if body is Uto:
		emit_signal("uto_entered", body)
