extends Node2D

onready var uto := $BG/UTO
onready var toWin := $BG/Control/ToWin
onready var redText := $BG/Control/RedText
onready var dragUtoHere := $BG/Control/DragUtoHereLabel
onready var toStart := $BG/Control/ToStartLabel
onready var grayScaleShader = $BG/GrayScaleShader

onready var toWinLeftTrigger := $BG/Control/ToWin/LeftTrigger
onready var dragUtoHereRightTrigger := $BG/Control/DragUtoHereLabel/RightTrigger

export var textMovementSpeed = 1.5

var blueTextPushable = true
var redTextPushable = false

signal red_text_pushable
signal victory
signal gameover


func _ready():
	if Global.challengeData.get("soundEnabled") == false:
		$ChallengeVictorySound.bus = "MUTED"

	Global.data["currentChallenge"] = 4
	_setPositions()
	_loadChallengeData()
	$Overlay/AnimationPlayer.connect("animation_finished", self, "_onAnimationFinished")

	var movable_labels = [toWin, redText, dragUtoHere, toStart]
	for label in movable_labels:
		var topTrigger: Area2D = label.get_node("TopTrigger")
		var bottomTrigger: Area2D = label.get_node("BottomTrigger")
		topTrigger.connect("body_entered", self, "_on_TopTrigger_body_entered", [label])
		topTrigger.connect("body_exited", self, "_on_TopTrigger_body_exited", [label])
		bottomTrigger.connect("body_entered", self, "_on_BottomTrigger_body_entered", [label])
		bottomTrigger.connect("body_exited", self, "_on_BottomTrigger_body_exited", [label])


func _setPositions():
	$BG/Control/SettingsIcon.position = Vector2(50, get_viewport_rect().size.y - 60)
	uto.position.x = get_viewport_rect().size.x / 2

	var movedown = [
		$BG/Control/IsABarrier,
		$BG/Control/BlueTextCanBePushed,
		$BG/Control/RedText,
		$BG/Control/YouAreJustANumber,
		$BG/Control/AsAlwaysPlay,
		$BG/Control/ToWin
	]

	var titleBottom = $BG/Control/Title.rect_position.y + $BG/Control/Title.rect_size.y
	var textBottom = $BG/Control/AsAlwaysPlay.rect_position.y + $BG/Control/AsAlwaysPlay.rect_size.y
	var distanceFromTop = $BG/Control/IsABarrier.rect_position.y - titleBottom
	var distanceFromBot = $BG/Control/RedLineUpper.rect_position.y - textBottom

	var delta = distanceFromBot - distanceFromTop

	for el in movedown:
		el.rect_position.y += delta / 2 - 20


func _loadChallengeData():
	grayScaleShader.visible = Global.challengeData.get("monochrome", false)

	if Global.challengeData.get("redTextPosition"):
		redText.rect_position = Global.challengeData["redTextPosition"]
		# assume that we correctly saved all the other data as well...
		toWin.rect_position = Global.challengeData["toWinPosition"]
		dragUtoHere.rect_position = Global.challengeData["DragUtoHere"]
		toStart.rect_position = Global.challengeData["ToStart"]
		uto.position = Vector2(uto.size.x + 10, get_viewport_rect().size.y - 200)



func _process(delta):
	if blueTextPushable:
		updateTextPosition(toWin)
	if redTextPushable:
		updateTextPosition(dragUtoHere)
		updateTextPosition(toStart)

	if !redText.arrivedAtDestination:
		updateTextPosition(redText)

	if checkVictory():
		emit_signal("victory")
		set_process(false)

	if checkGameover():
		emit_signal("gameover")
		set_process(false)
		if dragUtoHere.utoIsDown:
			dragUtoHere.rect_position.y = toStart.rect_position.y
		else:
			toStart.rect_position.y = dragUtoHere.rect_position.y


func checkVictory():
	if dragUtoHere.rect_position.y < $BG/Control/RedLineUpper.rect_position.y or dragUtoHere.rect_position.y - 20 > $BG/Control/RedLineBottom.rect_position.y:
		return false
	if dragUtoHereRightTrigger.overlaps_area(toWinLeftTrigger):
		return true
	return false


func checkGameover():
	if dragUtoHere.rect_position.y < $BG/Control/RedLineUpper.rect_position.y or dragUtoHere.rect_position.y + dragUtoHere.rect_size.y > $BG/Control/RedLineBottom.rect_position.y:
		return false
	if dragUtoHereRightTrigger.overlaps_area($BG/Control/ToStartLabel/TopTrigger):
		return true
	return false


func updateTextPosition(movableLabel: Label):
	# if trying to push it outside the screen from the bottom
	if movableLabel.rect_position.y > get_viewport_rect().size.y - movableLabel.rect_size.y:
		return
	# if trying to push it outside the screen from the top
	if movableLabel.rect_position.y < 5:
		return

	if movableLabel.utoIsUp and uto.target_position.y + uto.size.y / 2 > movableLabel.rect_position.y:
		movableLabel.rect_position.y += textMovementSpeed
	if movableLabel.utoIsDown and uto.target_position.y - uto.size.y / 2  < movableLabel.rect_position.y + toWin.rect_size.y:
		movableLabel.rect_position.y -= textMovementSpeed


func _on_TopTrigger_body_entered(body, label):
	if body is Uto:
		label.utoIsUp = true


func _on_TopTrigger_body_exited(body, label):
	if body is Uto:
		label.utoIsUp = false


func _on_BottomTrigger_body_entered(body, label):
	if body is Uto:
		label.utoIsDown = true


func _on_BottomTrigger_body_exited(body, label):
	if body is Uto:
		label.utoIsDown = false


func _on_BlueTextCanBePushed_Area2D_area_entered(area):
	if area.get_parent().name == "RedText":
		area.get_parent().arrivedAtDestination = true
		emit_signal("red_text_pushable")
		redTextPushable = true
		blueTextPushable = false


func _on_SettingsIcon_body_entered(body):
	if body is Uto:
#		Global.challengeData["redTextPushable"] = redTextPushable
#		Global.challengeData["blueTextPushable"] = blueTextPushable
		saveEntitiesPositions()
		Global.challengeData["utoEnteredSettings"] = true
		SceneManager.goto_scene("res://scenes/settings/SettingsScreen.tscn")


func saveEntitiesPositions():
	Global.challengeData["redTextPosition"] = redText.rect_position
	Global.challengeData["toWinPosition"] = toWin.rect_position
	Global.challengeData["DragUtoHere"] = dragUtoHere.rect_position
	Global.challengeData["ToStart"] = toStart.rect_position


func _on_Challenge4Intro_victory():
	uto.set_physics_process(false)
	$ChallengeVictorySound.play()
	yield($ChallengeVictorySound, "finished")
	$Overlay/AnimationPlayer.play("gloria")


func _on_Challenge4Intro_gameover():
	uto.set_physics_process(false)
	yield(get_tree().create_timer(1), "timeout")
	$Overlay/AnimationPlayer.play("blink")


func _onAnimationFinished(animName):
	if animName == "gloria":
		SceneManager.goto_scene("res://scenes/victory/VictoryScreen.tscn", { "use_legacy_code": true })

	if animName == "blink":
		SceneManager.goto_scene("res://scenes/gameover/GameOverScreen.tscn", {
			"text": "YOU ARE YOU.\nGAME IS ALREADY ON!",
			"hideQuitButton": true,
		})
