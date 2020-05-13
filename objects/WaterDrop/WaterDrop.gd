extends Node2D

signal dropFinished


func animate():
	$AnimationPlayer.seek(0, true)
	$AnimationPlayer.play("drop")
	visible = true


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	$AnimationPlayer.stop()
	$AnimationPlayer.seek(0, true)
	if anim_name == "drop":
		emit_signal("dropFinished")

