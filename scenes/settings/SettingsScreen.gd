extends CanvasLayer

onready var soundBtn = $Container/VBoxContainer/Sound/ToggleButton
onready var colorBtn = $Container/VBoxContainer/Color/Button2
onready var grayScaleShader = $Container/GrayScaleShader
onready var settingsActions = $Container/SettingsActions
onready var speedControl = $Container/VBoxContainer/GuardSpeed/RangeControl/ColorRect/Label
onready var container = $Container


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
	match Global.data["currentChallenge"]:
		7:
			grayScaleShader.queue_free()
			colorBtn.disconnect("pressed", self, "_on_Button2_pressed")
			colorBtn.disconnect("button_down", colorBtn, "_on_ToggleButton_button_down")


func guardSpeedCheck():
	# init guard speed control
	if Global.challengeData.get("guardSpeed") != null:
		speedControl.text = str(Global.challengeData.get("guardSpeed"))
	else:
		speedControl.text = str(1.0)

	match Global.data["currentChallenge"]:
		6, 7:
			challenge6customization()


func challenge6customization():
	$Container/VBoxContainer/GuardSpeed.disable()


func soundCheck():
	if Global.challengeData.get("soundEnabled") == false:
		soundBtn.setStatus(false)


func setPositions():
	container.rect_position.x = get_viewport().get_visible_rect().size.x / 2 - container.rect_size.x / 2
	var vwSize = get_viewport().get_visible_rect().size
	settingsActions.rect_position.x = vwSize.x / 2 - settingsActions.rect_size.x / 2


func _on_Quit_pressed():
	Global.challengeData = {}
	SceneManager.goto_scene("res://scenes/MainMenu/MainMenu.tscn")


func _on_Confirm_pressed():
	Global.challengeData["monochrome"] = !$Container/VBoxContainer/Color/Button2.on
	Global.challengeData["guardSpeed"] = $Container/VBoxContainer/GuardSpeed.getSpeed()
	var scn = Global.getChallengePath(Global.data.currentChallenge).challenge
	SceneManager.goto_scene(scn)


func _on_Restart_pressed():
	Global.challengeData = {}
	var scn = Global.getChallengePath(Global.data.currentChallenge).intro
	SceneManager.goto_scene(scn)


func _on_Button2_pressed():
	if colorBtn.on:
		grayScaleShader.hide()
	else:
		grayScaleShader.show()


func _on_ToggleButton_pressed():
	Global.challengeData["soundEnabled"] = soundBtn.on
