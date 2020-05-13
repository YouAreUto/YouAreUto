extends Node2D

var vwSize := Vector2() # viewport size, updated on resize
var originalVwSize := Vector2()

onready var characters = [
	$King,
	$HeraldPath,
	$SwordPath,
	$SwordPath2,
	$SwordPath3,
	$SwordPath4,
	$SwordPath5,
	$SwordPath6,
	$SwordPath7
]

onready var settingsIcon = $SettingsIcon


func _ready():
	Global.data["currentChallenge"] = 1

	# setGuardSpeed()

	$Overlay/GrayScaleShader.visible = Global.challengeData.get("monochrome", false)

	vwSize = get_viewport_rect().size
	originalVwSize = vwSize

	positionObjects()
	get_viewport().connect("size_changed", self, "_on_size_changed")


func setGuardSpeed():
	var animationsSpeed = Global.challengeData.get("guardSpeed")
	if animationsSpeed != null:
		for ap in get_tree().get_nodes_in_group("enemyAnimationPlayers"):
			var a: AnimationPlayer = ap
			a.playback_speed = a.playback_speed * pow(animationsSpeed, 1.3)

func positionObjects():
	setPositions()


func setPositions():
	"""Positions UTO, NPCs, sprites, enemies. Note: calling this during gameplay can break the gameplay"""
	$UTO.position = Vector2(vwSize.x / 2, vwSize.y / 2)

	var margin = {
		"king": {
			"top": 20
		},
		"heraldMinions": {
			"h": 110,
		}
	}
	$King.position = Vector2(vwSize.x / 2, margin.king.top + $King/Sprite.texture.get_height() / 2 * $King/Sprite.scale.y * $King.scale.y)
	# herald
	$HeraldPath.position.x = $King.position.x
	$HeraldPath.position.y = vwSize.y - 200
	# herald left minions
	$SwordPath.position.x = $HeraldPath.position.x - margin.heraldMinions.h
	$SwordPath3.position.x = $HeraldPath.position.x - margin.heraldMinions.h - 10
	# herald right minions
	$SwordPath2.position.x = $HeraldPath.position.x + margin.heraldMinions.h
	$SwordPath4.position.x = $HeraldPath.position.x + margin.heraldMinions.h + 10
	#
	$SwordPath.position.y = $HeraldPath.position.y - margin.heraldMinions.h
	$SwordPath2.position.y = $HeraldPath.position.y - margin.heraldMinions.h
	$SwordPath3.position.y = $HeraldPath.position.y + margin.heraldMinions.h
	$SwordPath4.position.y = $HeraldPath.position.y + margin.heraldMinions.h

	# king minions
	$SwordPath6.position.x = $King.position.x
	$SwordPath6.position.y = $King.position.y + 150
	$SwordPath5.position.x = $King.position.x - 190
	$SwordPath5.position.y = $King.position.y + 50
	$SwordPath7.position.x = $King.position.x + 190
	$SwordPath7.position.y = $King.position.y + 50

	settingsIcon.position = Vector2(
		vwSize.x - 100,
		vwSize.y - 100
	)

func stopMinions():
	$EnemiesMovement.stop()
	$SwordPath5/AnimationPlayer.stop()
	$SwordPath7/AnimationPlayer.stop()

# signals

func _on_UTO_kingKilled():
	$King.kill()
	for c in get_tree().get_nodes_in_group("enemyAnimationPlayers"):
		c.stop()
	$UTO.set_physics_process(false)
	yield($King/KilledSound, "finished")
	$Overlay/AnimationPlayer.play("gloria")
	stopMinions()
	$UTO.set_process_input(false)


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "gloria":
		Global.data.solved.challenge1 = true
		SceneManager.goto_scene("res://scenes/victory/VictoryScreen.tscn")
	if anim_name == "blink":
		SceneManager.goto_scene("res://scenes/gameover/GameOverScreen.tscn")


func _on_size_changed():
	# update member variable
	vwSize = get_viewport_rect().size
	positionObjects()


func _on_SettingsIcon_body_entered(body: PhysicsBody2D) -> void:
	if body is Uto:
		Global.challengeData["utoEnteredSettings"] = true
		SceneManager.goto_scene("res://scenes/challenges/settings/SettingsScreen.tscn")


func _on_UTO_killed() -> void:
	stopMinions()
