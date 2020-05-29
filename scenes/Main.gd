class_name Main
extends Node

onready var anim: AnimationPlayer = $Transition/AnimationPlayer
onready var current_scene := $CurrentScene


func _ready():
	hide_overlay()
#	SceneManager.goto_scene("res://scenes/challenges/challenge2/Challenge2.tscn")


func show_overlay():
	anim.play("show_overlay")


func hide_overlay():
	anim.play("hide_overlay")


func _on_Button3_pressed() -> void:
	get_tree().quit()


func _on_ChallengeSelectionList_challengeSelected(id) -> void:
	var playBtn = $BG/Buttons/PlayButton
	playBtn.disabled = false
	playBtn.modulate.a = 1

