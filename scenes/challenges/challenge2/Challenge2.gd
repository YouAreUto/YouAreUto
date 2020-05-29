extends Node2D

# dependencies

onready var uto: Uto = $ChallengeEntities/UTO
onready var utoBehaviour: Uto = $ChallengeEntities/UTO/Challenge2Behaviour
onready var definitely := $BG/Sprite/Definitely
onready var servant := $ChallengeEntities/Servant
onready var servant2 := $ChallengeEntities/Servant2
onready var servant3 := $ChallengeEntities/Servant3
onready var background := $BG/Sprite
onready var castle = $BG/ObjectiveArea
onready var textBarrier = $BG/Sprite/Collisions/TextBarrier
onready var settingsIcon = $"BG/ui-settings"


func _ready():
	Global.data["currentChallenge"] = 2
	# if sound enabled is not specified
	if !Global.challengeData.has("soundEnabled"):
		# default it to enabled
		Global.challengeData["soundEnabled"] = true
	setPositions()
	$ChallengeEntities.setServantPaths()

	var animationsSpeed = Global.challengeData.get("guardSpeed")
	if animationsSpeed != null:
		for ap in get_tree().get_nodes_in_group("enemyAnimationPlayers"):
			var a: AnimationPlayer = ap
			a.playback_speed = a.playback_speed * pow(animationsSpeed, 1.3)

	# if there is no data initialized for the challenge
	if Global.challengeData.get("UtoIsAServant") == null:
		# initialize it
		Global.challengeData["UtoIsAServant"] = false
		Global.challengeData["monochrome"] = false
		Global.challengeData["utoEnteredSettings"] = false
	else:
		# if Uto is a servant
		if Global.challengeData["UtoIsAServant"]:
			$ChallengeEntities._on_Definitely_UtoBecameACastleServant()
			utoBehaviour.becomeAServant()
			definitely.position = Global.challengeData["definitelyTextPosition"]
		if Global.challengeData["utoEnteredSettings"]:
			var settingsBounds: Vector2 = 3 * settingsIcon.get_node("CollisionShape2D").shape.extents * settingsIcon.scale
			uto.global_position = settingsIcon.global_position - 1.2*settingsBounds
		if Global.challengeData["monochrome"]:
			applyMonochrome()
			$BG/Sprite/Collisions/TextBarrier/CollisionShape2D.disabled = true
			$BG/Sprite/Collisions/YouText/CollisionShape2D.disabled = true
			definitely.get_node("CollisionShape2D").disabled = true
			definitely.set_process(false)


func setPositions():
	var vw_size = get_viewport().get_visible_rect().size
	$BG/Sprite.position.x = vw_size.x / 2
	$BG/Sprite.position.y = vw_size.y * 0.5
	settingsIcon.position = Vector2(vw_size.x - 100, vw_size.y - 100)

	castle.position.x = vw_size.x / 2
	castle.global_position.y = textBarrier.global_position.y - 120

	servant2.position.x = vw_size.x / 2 # center
	servant.position.x = servant2.position.x - 3.75 * uto.getUtoSize().x # left
	servant3.position.x = servant2.position.x + 3.75 * uto.getUtoSize().x # right

	servant.global_position.y = textBarrier.global_position.y + 100
	servant2.position.y = servant.position.y
	servant3.position.y = servant.position.y

	uto.position.x = vw_size.x / 2
	uto.position.y = vw_size.y * 0.45


func applyMonochrome():
	$Overlay/GrayScaleShader.show()
#	$BG/Sprite.hide()
#	$BG/Definitely/blue.hide()


func _on_Definitely_UtoBecameACastleServant():
	Global.challengeData["UtoIsAServant"] = true
	$UtoBecomeServantSound.play()


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "blink":
		SceneManager.goto_scene("res://scenes/gameover/GameOverScreen.tscn")
	if anim_name == "gloria":
		SceneManager.goto_scene("res://scenes/victory/VictoryScreen.tscn")


func _on_ObjectiveArea_body_entered(body):
	if body is Uto:
		Global.data.solved.challenge2 = true
		for c in get_tree().get_nodes_in_group("enemyAnimationPlayers"):
			c.stop()

		uto.set_physics_process(false)
		var challengeSound = $BG/ObjectiveArea/ChallengeSound
		if Global.challengeData.get("soundEnabled"):
			challengeSound.play()
			yield(challengeSound, "finished")

		$Overlay/AnimationPlayer.play("gloria")
		uto.set_process_input(false)


func _on_UTO_killed():
	$ChallengeEntities/ServantCenterPath/AnimationPlayer.stop()
	$ChallengeEntities/ServantLeftPath/AnimationPlayer.stop()
	$ChallengeEntities/ServantRightPath/AnimationPlayer.stop()



func _on_uisettings_body_entered(body: PhysicsBody2D) -> void:
	if body is Uto:
		Global.challengeData["definitelyTextPosition"] = definitely.position
		Global.challengeData["utoEnteredSettings"] = true
		SceneManager.goto_scene("res://scenes/challenges/settings/SettingsScreen.tscn")
