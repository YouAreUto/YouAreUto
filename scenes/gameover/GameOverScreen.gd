extends Node2D

# shortcuts to inner nodes

onready var text := $CanvasLayer/Text
onready var nextChallengeBtn := $Node2D/NextChallengeButton


func _ready():
	setPositions()
	Global.challengeData = {}


func init(param):
	if param.text:
		text.text = param.text
	if param.hideQuitButton:
		$CanvasLayer/VBoxContainer/QuitButton.hide()


func setPositions():
	text.rect_position.x = get_viewport_rect().size.x * 0.5 - text.rect_size.x / 2


func _on_QuitButton_pressed():
	SceneManager.goto_scene("res://scenes/Main.tscn")


func _on_RestartButton_pressed():
	SceneManager.goto_scene(Global.getChallengePath(Global.data.currentChallenge).intro)
