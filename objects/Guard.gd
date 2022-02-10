extends Node2D
class_name Guard
tool

export var guard_kills_uto = true setget set_guard_kills_uto
signal uto_overlapped


func _ready():
	if Engine.editor_hint:
		return


func set_guard_kills_uto(val):
	guard_kills_uto = val
	$UtoGameoverArea.monitoring = val
	$Area2D.monitoring = val


func get_size():
	return $Icon.texture.get_size() * $Icon.scale * scale


func _on_Area2D_body_entered(body):
	if body is Uto:
		emit_signal("uto_overlapped")
