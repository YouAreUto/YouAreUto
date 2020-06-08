extends Node2D

var debug = {
	"enabled":  false,
	"flashlightOn": false
}
var roomIsLit = false
var keyTaken = false
var checkFlashEvery = 0.6 # ms
var flashTimer = 0

onready var uto = $Bg/UTO
onready var settingsIcon = $Bg/SettingsIcon
onready var bgSprite = $Bg/Background1
onready var bgSprite2 = $Bg/Background2
onready var guardSpawner := $Bg/GuardSpawner
signal torch_activated
signal torch_disabled


func _ready():
	Global.data["currentChallenge"] = 5
	hideBackgrounds()
	applyChallengeData()
	# update debug button
	if debug.get("enabled"):
		$flash.show()
		if Global.challengeData.get("debug_flash"):
			$flash.pressed = true
	# if starting the challenge with the flashlight on
	if Global.isFlashlightOn(debug.enabled, $flash.pressed):
		handleTorchEnabled()
	_setPositions()


func positionGuards():
	$Bg/GuardsWhenSpeedIsZero.showAndActivate()


func _process(delta):
	flashTimer += delta
	if flashTimer > checkFlashEvery:
		flashTimer = 0
		handleFlashlight()


func handleFlashlight():
	if debug.enabled:
		mockHandleFlashlight()
		return
	if Global.isFlashlightOn() and !roomIsLit:
		handleTorchEnabled()
	if !Global.isFlashlightOn() and roomIsLit:
		handleTorchDisabled()


func mockHandleFlashlight():
	if $flash.pressed and !roomIsLit:
		Global.challengeData["debug_flash"] = true
		handleTorchEnabled()
	if !$flash.pressed and roomIsLit:
		Global.challengeData["debug_flash"] = false
		handleTorchDisabled()


func handleTorchEnabled():
	roomIsLit = true
	emit_signal("torch_activated")
	var vs = get_viewport_rect().size
	if keyTaken:
		call_deferred("switchToSecondBackground")
		# uto to the top left corner
		uto.position.x = 80
		uto.global_position.y = $Bg/Background1/Position2D.global_position.y
		if $Bg/Chest:
			$Bg/Chest.show()
	else:
		# uto to the bottom right corner
		uto.position.x = vs.x - uto.getUtoSize().x - 30
		uto.global_position.y = $Bg/Background1/Position2D.global_position.y
		call_deferred("switchToFirstBackground")


func handleTorchDisabled():
	roomIsLit = false
	emit_signal("torch_disabled")
	call_deferred("hideBackgrounds")


func applyChallengeData():
	if !Global.challengeData.get("utoEnteredSettings"):
		return
	# guards speed
	var gSpd = Global.challengeData.get("guardSpeed")
	if gSpd != null:
		if gSpd > 0:
			guardSpawner.screenTime *= (1 / gSpd)
	# monochrome
	if Global.challengeData.get("monochrome"):
		$CanvasLayer/GrayScaleShader.visible = true
	# room is lit
	var _isLit = Global.challengeData.get("roomIsLit")
	if _isLit:
		roomIsLit = true
	# keyTaken
	keyTaken = Global.challengeData.get("keyTaken", false)
	if roomIsLit:
		if keyTaken:
			_removeKey($Bg/Key)
			call_deferred("switchToSecondBackground")
			if $Bg/Chest:
				$Bg/Chest.show()
		else:
			call_deferred("switchToFirstBackground")


func hideBackgrounds():
	bgSprite.hide()
	bgSprite2.hide()
	var shapes = get_tree().get_nodes_in_group("Bg2CollisionShapes")
	shapes += get_tree().get_nodes_in_group("Bg1CollisionShapes")
	for collisionShape in shapes:
		collisionShape.disabled = true
	if $Bg/Key:
		$Bg/Key.hide()
	if $Bg/Chest:
		$Bg/Chest.hide()


func switchToFirstBackground():
	$Bg/Chest.show()
	if $Bg/Key:
		$Bg/Key.show()
	bgSprite.show()
	bgSprite2.hide()
	for collisionShape in get_tree().get_nodes_in_group("Bg1CollisionShapes"):
		collisionShape.disabled = false


func switchToSecondBackground():
	bgSprite.hide()
	bgSprite2.show()
	# disable bg1 collisions
	for collisionShape in get_tree().get_nodes_in_group("Bg1CollisionShapes"):
		collisionShape.disabled = true
	# enable bg2 collisions
	for collisionShape in get_tree().get_nodes_in_group("Bg2CollisionShapes"):
		collisionShape.disabled = false


func _setPositions():
	var vs = get_viewport_rect().size
	# force the sprite to fit vertically
	var bgSize = bgSprite.texture.get_size()
	var scaleToFitVertically = vs.y / bgSize.y
	var scaleIncrementToFitVertically = scaleToFitVertically - bgSprite.scale.y
	if scaleIncrementToFitVertically > 0:
		bgSprite.scale.y = bgSprite.scale.y + scaleIncrementToFitVertically
		bgSprite.scale.x = bgSprite.scale.y
		# update uto size
		uto.scale.x = uto.scale.x + uto.scale.x * scaleIncrementToFitVertically
		uto.scale.y = uto.scale.x
	# center bg
	bgSprite.position = Vector2(vs.x / 2, vs.y / 2)
	bgSprite2.scale = bgSprite.scale
	bgSprite2.position = bgSprite.position
	# settings icon
	settingsIcon.position.x = 80
	settingsIcon.position.y = 80

	# position uto to the bottom right corner
	uto.position.x = vs.x - uto.getUtoSize().x - 30
	uto.global_position.y = $Bg/Background1/Position2D.global_position.y

	if $Bg.find_node("Key"):
		$Bg/Key.position = Vector2(settingsIcon.position.x, vs.y - 90)
	if $Bg.find_node("Chest"):
		$Bg/Chest.position = Vector2(uto.position.x, settingsIcon.position.y)

	guardSpawner.global_position.y = $Bg/Background2/Position2D.global_position.y

	# if positioning after going to settings
	if Global.challengeData.get("utoEnteredSettings"):
		# if the room was lit before entering the settings
		if Global.challengeData.get("roomIsLit"):
			# position uto to the top left corner
			uto.position = settingsIcon.position + Vector2(
				0,
				(settingsIcon.get_node("Sprite").texture.get_size() * settingsIcon.scale).y + uto.getUtoSize().y / 2
			)
		else: # room was not lit
			if keyTaken:
				# position uto to the top left corner
				uto.position = settingsIcon.position + Vector2(
					0,
					(settingsIcon.get_node("Sprite").texture.get_size() * settingsIcon.scale).y + uto.getUtoSize().y / 2
				)
	$Bg/GuardsWhenSpeedIsZero.position.x = vs.x - 250
	$Bg/GuardsWhenSpeedIsZero.position.y = guardSpawner.position.y


func _on_Key_keyTaken(key):
	call_deferred("_removeKey", key)
	call_deferred("switchToSecondBackground")
	keyTaken = true
	Global.challengeData["keyTaken"] = true


func _removeKey(key):
	key.get_parent().remove_child(key)


func _on_Chest_chestTouched():
	if keyTaken and Global.isFlashlightOn(debug.enabled, $flash.pressed):
		$Bg/Chest.opened = true
		uto.set_physics_process(false)
		if Global.challengeData.get("soundEnabled", true):
			$AudioStreamPlayer.play()
			yield($AudioStreamPlayer, "finished")
		$CanvasLayer/AnimationPlayer.play("victory")
		yield($CanvasLayer/AnimationPlayer, "animation_finished")
		SceneManager.goto_scene("res://scenes/victory/VictoryScreen.tscn", { "use_legacy_code": true })


func _on_SettingsIcon_body_entered(body):
	if body is Uto:
		Global.challengeData["utoEnteredSettings"] = true
		Global.challengeData["roomIsLit"] = roomIsLit
		SceneManager.goto_scene("res://scenes/settings/SettingsScreen.tscn")


func _on_UTO_killed():
	$Bg/GuardSpawner.stopGuards()
	$CanvasLayer/AnimationPlayer.play("victory")
	yield($CanvasLayer/AnimationPlayer, "animation_finished")
	SceneManager.goto_scene("res://scenes/gameover/GameOverScreen.tscn", { "use_legacy_code": true })
