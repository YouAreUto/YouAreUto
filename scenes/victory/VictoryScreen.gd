extends Node2D

# shortcuts to inner nodes

onready var text := $Node2D/Text
onready var nextChallengeBtn := $CanvasLayer/VBoxContainer/Next
onready var quitButton := $CanvasLayer/VBoxContainer/Quit
onready var restartButton := $CanvasLayer/VBoxContainer/Restart


func _ready():
	Global.challengeData = {}
	setPositions()


func setPositions():
	text.rect_position.x = get_viewport().get_visible_rect().size.x / 2 - text.rect_size.x / 2
	nextChallengeBtn.rect_position.x = get_viewport().get_visible_rect().size.x / 2 - nextChallengeBtn.rect_size.x / 2
	quitButton.rect_position.x = get_viewport().get_visible_rect().size.x / 2 - quitButton.rect_size.x / 2
	restartButton.rect_position.x = get_viewport().get_visible_rect().size.x / 2 - restartButton.rect_size.x / 2


func _on_Restart_pressed() -> void:
	SceneManager.goto_scene(Global.getChallengePath(Global.data.currentChallenge).intro)


func _on_Quit_pressed() -> void:
	SceneManager.goto_scene("res://scenes/Main.tscn")
