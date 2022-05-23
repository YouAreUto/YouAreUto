extends Node2D

# dependencies
onready var uto: Uto = $ChallengeEntities/UTO
onready var utoBehaviour = $ChallengeEntities/UTO/Challenge2Behaviour
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
	var vw_size = Global.vw.size
	$BG/Sprite.position.x = vw_size.x / 2
	$BG/Sprite.position.y = vw_size.y * 0.5
	settingsIcon.position = Vector2(vw_size.x - 100, vw_size.y - 100)

	castle.position.x = vw_size.x / 2
	castle.global_position.y = textBarrier.global_position.y - 120

	var servants_gap = 1.7 * uto.size.x
	servant2.position.x = vw_size.x / 2 # center
	servant.position.x = servant2.position.x - servants_gap # left
	servant3.position.x = servant2.position.x + servants_gap # right

	servant.global_position.y = textBarrier.global_position.y + 100
	servant2.position.y = servant.position.y
	servant3.position.y = servant.position.y

	# make guards cover the entire width
	var guards_needed_to_fill_width = int(ceil(vw_size.x / servants_gap))
	if guards_needed_to_fill_width % 2 == 0:
		guards_needed_to_fill_width += 1
	if guards_needed_to_fill_width > 3 :
		var guards = get_tree().get_nodes_in_group("guards")
		var guards_count = len(guards) - 3
		var j = 0
		while guards_count < guards_needed_to_fill_width:
			var new_servant_l = servant2.duplicate()
			var new_servant_r = servant2.duplicate()
			servant2.get_parent().add_child(new_servant_l)
			servant2.get_parent().add_child(new_servant_r)
			new_servant_l.position.x = servant2.position.x - servants_gap * (2 + j)
			new_servant_r.position.x = servant2.position.x + servants_gap * (2 + j)
			guards = get_tree().get_nodes_in_group("guards")
			guards_count = len(guards) - 3
			j += 1

	make_barrier_text_cover_the_entire_width()


	uto.position.x = vw_size.x / 2
	uto.position.y = vw_size.y * 0.45




func make_barrier_text_cover_the_entire_width():
	var barrier_text: Label = $BG/Sprite/RedTextIsABarrierText
	var its = 0
	if not barrier_text.has_meta("start_pos"):
		barrier_text.set_meta("start_pos", barrier_text.rect_position)
	while barrier_text.rect_size.x < Global.vw.size.x:
		barrier_text.text = " - " + barrier_text.text + " - "
		barrier_text.set_anchors_and_margins_preset(Control.PRESET_CENTER_TOP)
		barrier_text.rect_position.y = barrier_text.get_meta("start_pos").y
		if its > 20:
			break
		its += 1


func applyMonochrome():
	$Overlay/GrayScaleShader.show()


func _on_Definitely_UtoBecameACastleServant():
	Global.challengeData["UtoIsAServant"] = true
	$UtoBecomeServantSound.play()


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "blink":
		SceneManager.goto_scene("res://scenes/gameover/GameOverScreen.tscn", { "use_legacy_code": true })
	if anim_name == "gloria":
		SceneManager.goto_scene("res://scenes/victory/VictoryScreen.tscn", { "use_legacy_code": true })


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
		SceneManager.goto_scene("res://scenes/settings/SettingsScreen.tscn")
