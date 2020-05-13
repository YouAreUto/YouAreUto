extends Node2D
class_name Key


signal keyTaken

var isKeyTaken = false


func _on_Area2D_body_entered(body):
	if visible:
		if body is Uto and !isKeyTaken:
			isKeyTaken = true
			emit_signal("keyTaken", self)
