extends Node2D

onready var textSprite = $Text
onready var uto = $UTO
onready var roof = $Roof
onready var poet = $PoetPath2D/PathFollow2D/Poet
onready var poetPath = $PoetPath2D
onready var settingsIcon = $SettingsIcon
onready var servantStopPoint = $Servant1StopPoint

onready var saved_time = OS.get_unix_time()  # used only to check if the time has been modified
var seconds_after_last_check = 0 # sec
onready var last_check = OS.get_unix_time() #sec

var vs
var textStartY
var underText
var debug_time = { # solution: 3:33
	"enabled": false,
	"hour": 3,
	"minute": 33
}
# Eg: 9:43 is shown for minutes from 9:38:00 to 9:47:59
# Eg: 9:53 is shown for minutes from 9:48:00 to 9:57:59


func _ready() -> void:
	Global.data["currentChallenge"] = 3
	get_viewport().connect("size_changed", self, "setLayout")
	setLayout()
	setPatrolPaths()
	# setGuardSpeed()


func isPuzzleSolved():
	var time = OS.get_time()
	if debug_time.enabled:
		time.hour = debug_time.hour
		time.minute = debug_time.minute
	return ((time.hour == 3 or time.hour == 15) and (28 <= time.minute and time.minute < 38))


func setLayout():
	# get viewport size
	vs = get_viewport().get_visible_rect().size
	textStartY = vs.y * 0.42
	underText = vs.y * 0.73 # just under the text
	# textSprite's texture size
	var textureSize = textSprite.texture.get_size()
	# stretch sprite horizontally to fit viewport
	textSprite.scale.x = vs.x / textureSize.x
	textSprite.scale.y = textSprite.scale.x
	# clamp the height
	if textureSize.y * textSprite.scale.y > vs.y:
		textSprite.scale.y = vs.y / textSprite.texture.get_size().y
		textSprite.scale.x = textSprite.scale.y
	# center the sprite
	textSprite.position.x = vs.x / 2
	textSprite.position.y = vs.y / 2

	# position entities
	uto.position.x = vs.x / 2
	roof.position.x = uto.position.x

	settingsIcon.position.x = vs.x - 100
	settingsIcon.position.y = vs.y - 100


func setGuardSpeed():
	var animationsSpeed = Global.challengeData.get("guardSpeed")
	if animationsSpeed != null:
		for ap in get_tree().get_nodes_in_group("enemyAnimationPlayers"):
			var a: AnimationPlayer = ap
			a.playback_speed = a.playback_speed * pow(animationsSpeed, 1.3)


func setPatrolPaths():
	var vs = get_viewport().get_visible_rect().size
	if isPuzzleSolved():
		patrolPathForPuzzleSolved(vs)
	else:
		patrolPathForPuzzleNotSolved(vs)

	# servant 3
	var servantPath3 = $Servant3Path
	var servant3 = $Servant3Path/PathFollow2D/Servant3
	servant3.position = Vector2()
	servantPath3.position = Vector2()
	servantPath3.curve = Curve2D.new()
	var bottom = vs.y * 0.94

	servantPath3.curve.add_point(Vector2(vs.x * 0.1, bottom))
	servantPath3.curve.add_point(Vector2(vs.x * 0.1, underText))
	servantPath3.curve.add_point(Vector2(vs.x * 0.5, underText))
	servantPath3.curve.add_point(Vector2(vs.x * 0.9, underText))
	servantPath3.curve.add_point(Vector2(vs.x * 0.9, bottom))

	# poet
	poet.position = Vector2()
	poetPath.position = Vector2()
	poetPath.curve = Curve2D.new()
	var centerX = vs.x * 0.5
	poetPath.curve.add_point(Vector2(vs.x * 0.72, bottom))
	poetPath.curve.add_point(Vector2(vs.x * 0.28, bottom))


func patrolPathForPuzzleSolved(vs):
	var servantPath = $ServantPath
	var servant = $ServantPath/PathFollow2D/Servant
	servant.position = Vector2()
	servantPath.position = Vector2()
	servantPath.curve = Curve2D.new()
	var textureWidth = 80
	var space = 90 # average servant width
	var roofWidth = roof.texture.get_width() + 20
	servantPath.curve.add_point(Vector2(space, textStartY))
	servantPath.curve.add_point(Vector2(space, space))
	servantPath.curve.add_point(Vector2(roof.position.x - roofWidth, space))
	servantPath.curve.add_point(Vector2(roof.position.x - roofWidth, roof.position.y + roofWidth))
	servantPath.curve.add_point(Vector2(roof.position.x, roof.position.y + roofWidth))
	var bottomPoint = Vector2(roof.position.x, vs.y * 0.62) # this is the point where servant 1 stops
	servantPath.curve.add_point(bottomPoint)
	servantPath.curve.add_point(Vector2(roof.position.x, textStartY))
	servantPath.curve.add_point(Vector2(space, textStartY))
	servantPath.get_node("AnimationPlayer").play("patrol")
	# add area to the point where the servant 1 needs to stop
	servantStopPoint.position = bottomPoint


	var servantPath2 = $Servant2Path
	var servant2 = $Servant2Path/PathFollow2D/Servant2
	servant2.position = Vector2()
	servantPath2.position = Vector2()
	servantPath2.curve = Curve2D.new()
	servantPath2.curve.add_point(Vector2(vs.x - space, textStartY))
	servantPath2.curve.add_point(Vector2(vs.x - space, space))
	servantPath2.curve.add_point(Vector2(roof.position.x + roofWidth, space))
	servantPath2.curve.add_point(Vector2(roof.position.x + roofWidth, roof.position.y + roofWidth))
	servantPath2.curve.add_point(Vector2(roof.position.x, roof.position.y + roofWidth))
	servantPath2.curve.add_point(Vector2(roof.position.x, textStartY))
	servantPath2.curve.add_point(Vector2(vs.x - space, textStartY))
	$Servant2Path/PathFollow2D.unit_offset = 0
	servantPath2.get_node("AnimationPlayer").play("patrol")


func patrolPathForPuzzleNotSolved(vs):
	var servantPath = $ServantPath
	var servant = $ServantPath/PathFollow2D/Servant
	servant.position = Vector2()
	servantPath.position = Vector2()
	servantPath.curve = Curve2D.new()
	var textureWidth = 80
	var space = 90 # average servant width

	var roofWidth = roof.texture.get_width() + 20
	servantPath.curve.add_point(Vector2(space, space))
	servantPath.curve.add_point(Vector2(roof.position.x - roofWidth, space))
	servantPath.curve.add_point(Vector2(roof.position.x - roofWidth, roof.position.y + roofWidth))
	servantPath.curve.add_point(Vector2(roof.position.x, roof.position.y + roofWidth))
	servantPath.curve.add_point(Vector2(roof.position.x, textStartY))
	servantPath.curve.add_point(Vector2(space, textStartY))
	servantPath.curve.add_point(Vector2(space, space))
	servantPath.get_node("AnimationPlayer").play("patrol-puzzle-not-solved")

	var servantPath2 = $Servant2Path
	var servant2 = $Servant2Path/PathFollow2D/Servant2
	servant2.position = Vector2()
	servantPath2.position = Vector2()
	servantPath2.curve = Curve2D.new()
	servantPath2.curve.add_point(Vector2(vs.x - space, textStartY))
	servantPath2.curve.add_point(Vector2(vs.x - space, space))
	servantPath2.curve.add_point(Vector2(roof.position.x + roofWidth, space))
	servantPath2.curve.add_point(Vector2(roof.position.x + roofWidth, roof.position.y + roofWidth))
	servantPath2.curve.add_point(Vector2(roof.position.x, roof.position.y + roofWidth))
	servantPath2.curve.add_point(Vector2(roof.position.x, textStartY))
	servantPath2.curve.add_point(Vector2(vs.x - space, textStartY))

	$Servant2Path/PathFollow2D.unit_offset = 0
	servantPath2.get_node("AnimationPlayer").play("patrol-puzzle-not-solved")


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "blink":
		SceneManager.goto_scene("res://scenes/gameover/GameOverScreen.tscn")
	if anim_name == "gloria":
		SceneManager.goto_scene("res://scenes/challenges/challenge3-poet-dialogue/Challenge3PoetDialogue.tscn")


func _on_SettingsIcon_body_entered(body: PhysicsBody2D) -> void:
	if body is Uto:
#		if !body.alive:
#			return
		Global.challengeData["utoEnteredSettings"] = true
		SceneManager.goto_scene("res://scenes/challenges/settings/SettingsScreen.tscn")


func _on_WinArea_body_entered(body: PhysicsBody2D) -> void:
	if body is Uto:
		var sound = $PoetPath2D/PathFollow2D/Poet/Umbrella/WinArea/AudioStreamPlayer
		sound.play()
		uto.set_physics_process(false)
		for c in get_tree().get_nodes_in_group("enemyAnimationPlayers"):
			c.stop()
		yield(sound, "finished")
		Global.data.solved.challenge3 = true
		$Overlay/AnimationPlayer.play("gloria")

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		get_node("/root/Challenge3/Overlay/AnimationPlayer").play("forward_time")


func _on_Timer_timeout() -> void:
	var time = OS.get_unix_time()
	var delta_s = time - saved_time
	seconds_after_last_check = time - last_check
	last_check = time
	if abs(delta_s) > 60 and seconds_after_last_check != 1:
		saved_time = time
		get_node("/root/Challenge3/Overlay/AnimationPlayer").play("forward_time")
	else:
		pass
#		print("not triggered")
#		print("delta ", delta_s)
#		print(seconds_after_last_check)
#		print("----")


func forwardTime():
	# stop animations
	for c in get_tree().get_nodes_in_group('enemyAnimationPlayers'):
		var a: AnimationPlayer = c
		a.stop()
		a.seek(0, true)
	# reset layout and update paths
	setLayout()
	setPatrolPaths()
	# update the textures of hours and minutes and collisions
	$"Text/Hours"._ready()
	$"Text/Minutes"._ready()
	$ServantPath._ready()
	# play animations
	$PoetPath2D/AnimationPlayer.play("patrol")
	$Servant3Path/AnimationPlayer.play("patrol")
