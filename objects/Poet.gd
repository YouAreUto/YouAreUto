extends Area2D
class_name Poet


signal uto_entered


func _ready():
	pass # Replace with function body.


func get_bounds() -> Vector2:
	return $Sprite.texture.get_size() * $Sprite.global_scale


func _on_Poet_body_entered(body: Node) -> void:
	if body is Uto:
		emit_signal("uto_entered")
