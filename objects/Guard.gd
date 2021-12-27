extends Node2D
class_name Guard
tool

export var guard_kills_uto = true
signal uto_overlapped


func _ready():
	if Engine.editor_hint:
		return
	if guard_kills_uto == false:
		$UtoGameoverArea.queue_free()
		$Area2D.monitoring = true


func get_size():
	return $Icon.texture.get_size() * $Icon.scale * scale


func _on_Area2D_body_entered(body):
	if body is Uto:
		emit_signal("uto_overlapped")
