extends Node2D

# dependencies
onready var soundBtn = $CanvasLayer/Container/VBoxContainer/Sound/ToggleButton
onready var colorBtn = $CanvasLayer/Container/VBoxContainer/Color/Button2
onready var grayScaleShader = $CanvasLayer/Container/GrayScaleShader
onready var settingsActions = $CanvasLayer/Container/SettingsActions
onready var speedControl = $CanvasLayer/Container/VBoxContainer/GuardSpeed/RangeControl/ColorRect/Label


func _ready():
	monochromeCheck()
	guardSpeedCheck()
	soundCheck()
	setPositions()


func monochromeCheck():
	# init monochrome control
	if Global.challengeData.get("monochrome"):
		grayScaleShader.show()
		colorBtn.setStatus(false)


func guardSpeedCheck():
	# init guard speed control
	if Global.challengeData.get("guardSpeed") != null:
		speedControl.text = str(Global.challengeData.get("guardSpeed"))
	else:
		speedControl.text = str(1.0)


func soundCheck():
	if Global.challengeData.get("soundEnabled") == false:
		soundBtn.setStatus(false)


func setPositions():
	$CanvasLayer/Container.rect_position.x = get_viewport().get_visible_rect().size.x / 2 - $CanvasLayer/Container.rect_size.x / 2
	var vwSize = get_viewport().get_visible_rect().size
	settingsActions.rect_position.x = vwSize.x / 2 - settingsActions.rect_size.x / 2

# events subscriptions

func _on_Quit_pressed():
	Global.challengeData = {}
	SceneManager.goto_scene("res://scenes/MainMenu/MainMenu.tscn")


func _on_Confirm_pressed():
	Global.challengeData["monochrome"] = !$CanvasLayer/Container/VBoxContainer/Color/Button2.on
	Global.challengeData["guardSpeed"] = $CanvasLayer/Container/VBoxContainer/GuardSpeed.getSpeed()
	var scn = Global.getChallengePath(Global.data.currentChallenge).challenge
	SceneManager.goto_scene(scn)


func _on_Restart_pressed():
	Global.challengeData = {}
	var scn = Global.getChallengePath(Global.data.currentChallenge).intro
	SceneManager.goto_scene(scn)
#	SceneManager.goto_scene("res://scenes/Challenges/challenge2-intro/Challenge2Intro.tscn")


func _on_Button2_button_up():
	if colorBtn.on:
		grayScaleShader.hide()
	else:
		grayScaleShader.show()


func _on_ToggleButton_button_up():
	Global.challengeData["soundEnabled"] = soundBtn.on
