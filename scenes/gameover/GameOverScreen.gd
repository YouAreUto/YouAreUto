extends Node2D

onready var text := $CanvasLayer/Text

var use_legacy_code = true


func _ready():
	setPositions()
	Global.challengeData = {}


func init(conf: Dictionary):
	if conf.has("text"):
		text.text = conf.text
	if conf.has("hideQuitButton"):
		$CanvasLayer/VBoxContainer/QuitButton.hide()
	if conf.has("use_legacy_code"):
		use_legacy_code = conf.get("use_legacy_code")



func setPositions():
	text.rect_position.x = get_viewport_rect().size.x * 0.5 - text.rect_size.x / 2


func _on_QuitButton_pressed():
	SceneManager.goto_scene("res://scenes/MainMenu/MainMenu.tscn")


func _on_RestartButton_pressed():
	if use_legacy_code:
		SceneManager.goto_scene(Global.getChallengePath(Global.data.currentChallenge).intro)
	else:
		SceneManager.restart_challenge()
