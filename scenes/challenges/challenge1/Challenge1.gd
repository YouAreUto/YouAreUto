extends Challenge

onready var uto: Uto = $UTO
onready var king = $King
onready var characters = [
	king,
	$HeraldPath,
	$SwordPath,
	$SwordPath2,
	$SwordPath3,
	$SwordPath4,
	$SwordPath5,
	$SwordPath6,
	$SwordPath7
]

var viewport_size := Vector2() # viewport size, updated on resize


func _init():
	title = "Royal Rules"
	

func _ready():
	Global.data["currentChallenge"] = 1
	# set_guard_speed()
	$Overlay/GrayScaleShader.visible = Global.challengeData.get("monochrome", false)
	viewport_size = get_viewport_rect().size
	set_positions()
	# useful for development (eg: if you resize the game window)
	get_viewport().connect("size_changed", self, "_on_viewport_size_changed")


func set_guard_speed():
	var animations_speed = Global.challengeData.get("guardSpeed")
	if animations_speed != null:
		for ap in get_tree().get_nodes_in_group("enemyAnimationPlayers"):
			var a: AnimationPlayer = ap
			a.playback_speed = a.playback_speed * pow(animations_speed, 1.3)


func set_positions():
	"""Positions UTO, NPCs, sprites, enemies. Note: calling this during gameplay can break the gameplay"""
	uto.position = Vector2(viewport_size.x / 2, viewport_size.y / 2)

	var margin = {
		"king": {
			"top": 20
		},
		"heraldMinions": {
			"h": 110,
		}
	}
	var king_sprite = king.get_node("Sprite")
	king.position = Vector2(viewport_size.x / 2, margin.king.top + king_sprite.texture.get_height() / 2 * king_sprite.scale.y * king.scale.y)
	# herald
	$HeraldPath.position.x = king.position.x
	$HeraldPath.position.y = viewport_size.y - 200
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
	$SwordPath6.position.x = king.position.x
	$SwordPath6.position.y = king.position.y + 150
	$SwordPath5.position.x = king.position.x - 190
	$SwordPath5.position.y = king.position.y + 50
	$SwordPath7.position.x = king.position.x + 190
	$SwordPath7.position.y = king.position.y + 50

	$SettingsIcon.position = Vector2(
		viewport_size.x - 100,
		viewport_size.y - 100
	)

func stop_enemies():
	$EnemiesMovement.stop()
	$SwordPath5/AnimationPlayer.stop()
	$SwordPath7/AnimationPlayer.stop()
	#	for c in get_tree().get_nodes_in_group("enemyAnimationPlayers"):
	#		c.stop()

# signals

func _on_UTO_killed() -> void:
	stop_enemies()


func _on_viewport_size_changed():
	viewport_size = get_viewport_rect().size
	set_positions()


func _on_Challenge1_victory():
	# Stop game objects
	stop_enemies()
	uto.set_physics_process(false)
