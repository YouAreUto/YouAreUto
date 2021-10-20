extends Node2D

# shortcuts to inner nodes

onready var text := $Node2D/Text
onready var nextChallengeBtn := $CanvasLayer/VBoxContainer/Next
onready var quitButton := $CanvasLayer/VBoxContainer/Quit
onready var restartButton := $CanvasLayer/VBoxContainer/Restart

var use_legacy_code = false


func _ready():
	Global.challengeData = {}
	setPositions()
	if Global.data.currentChallenge == 4:
		if OS.get_name() == "iOS":
			nextChallengeBtn.hide()



func init(conf: Dictionary):
	if conf and conf.has("use_legacy_code"):
		use_legacy_code = conf.get("use_legacy_code")


func setPositions():
	text.rect_position.x = get_viewport().get_visible_rect().size.x / 2 - text.rect_size.x / 2
	nextChallengeBtn.rect_position.x = get_viewport().get_visible_rect().size.x / 2 - nextChallengeBtn.rect_size.x / 2
	quitButton.rect_position.x = get_viewport().get_visible_rect().size.x / 2 - quitButton.rect_size.x / 2
	restartButton.rect_position.x = get_viewport().get_visible_rect().size.x / 2 - restartButton.rect_size.x / 2


func _on_Restart_pressed() -> void:
	if use_legacy_code:
		SceneManager.goto_scene(Global.getChallengePath(Global.data.currentChallenge).intro)
	else:
		SceneManager.restart_challenge()


func _on_Quit_pressed() -> void:
	SceneManager.goto_scene("res://scenes/MainMenu/MainMenu.tscn")


func _on_Next_pressed():
	Global.goToNextChallenge(true)

