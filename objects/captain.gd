extends Area2D
class_name Captain

signal uto_entered

onready var sprite = $Sprite


func _ready():
	set_size(130, 130)


func set_size(w, h):
	scale.x = w / sprite.texture.get_size().x
	scale.y = h / sprite.texture.get_size().y


func get_bounds() -> Vector2:
	return $Sprite.texture.get_size() * $Sprite.global_scale


func _on_Captain_body_entered(body):
	if body is Uto:
		emit_signal("uto_entered")
