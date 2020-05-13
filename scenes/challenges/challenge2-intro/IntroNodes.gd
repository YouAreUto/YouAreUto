extends Node2D

onready var overlayAnims = get_parent().get_node("Overlay/AnimationPlayer")
onready var challengeNodes = get_parent().get_node("ChallengeNodes")


func _on_Area2D_body_entered(body):
	if body is Uto:
		overlayAnims.play("appear")


func _on_AnimationPlayer_animation_finished(anim_name):
	# if overlay appeared
	if anim_name == "appear":
		overlayAnims.play("disappear")
		hide()
		SceneManager.goto_scene("res://scenes/challenges/challenge2/Challenge2.tscn")